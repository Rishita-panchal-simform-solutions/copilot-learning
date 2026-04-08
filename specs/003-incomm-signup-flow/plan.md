# Implementation Plan: InComm Benefits Signup Flow

**Branch**: `003-incomm-signup-flow` | **Date**: 2026-04-08 | **Spec**: [spec.md](spec.md)  
**Input**: Feature specification from `/specs/003-incomm-signup-flow/spec.md`

## Summary

Implement a 9-screen signup flow for InComm Benefits (Welcome → Personal Info → Verify OTP → Create Password → Terms & Agreements → Notifications → Biometric). The flow collects SSN last-4, date of birth, and work email for account lookup, dispatches and validates a 6-digit OTP, enforces real-time password rules (4 rules, live indicators), presents dynamic agreement checkboxes based on account type (HSA / FSA / DCFSA / both), and concludes with optional push-notification and biometric login setup. All session state is in-memory only. The technical approach follows the existing SwiftUI + RouterPath MVVM pattern used throughout the project, extending `APITarget` with five new signup endpoints.

## Technical Context

**Language/Version**: Swift 5.9+ / iOS 18.0+  
**Primary Dependencies**: SwiftUI (UI layer), NetworkEngine 2.0.1 (Alamofire-based, via `APITarget`), Connectivity (offline detection via `ReachabilityManager`), LocalAuthentication (Face ID / Touch ID), UserNotifications (push permission request)  
**Storage**: None — signup session state is in-memory only; no CoreData, Keychain, or UserDefaults writes during the flow  
**Testing**: XCTest (unit tests for ViewModels and password-rule logic)  
**Target Platform**: iOS 18.0+  
**Project Type**: Mobile app (iOS, SwiftUI)  
**Performance Goals**: 60 fps transitions; full-screen loading overlay appears within one run-loop tick of button tap  
**Constraints**: No persistent session state; offline surfaces immediately via `ReachabilityManager.shared.isNetworkReachable` before any API call; OTP resend blocked client-side for 60 s  
**Scale/Scope**: 9 new SwiftUI views, 4 ViewModels, 2 router files, 8 model files, 5 new `APITarget` cases

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Gate | Principle | Status | Notes |
|------|-----------|--------|-------|
| All API calls originate in ViewModels | I. MVVM | ✅ PASS | ViewModels call `APITarget`; Views observe via `@StateObject` / `@ObservedObject` |
| No UI mutations in ViewModels | I. MVVM | ✅ PASS | ViewModels publish state; Views react |
| Navigation via push/pop — no VC recreation | I. MVVM | ✅ PASS | SwiftUI `NavigationStack` + `RouterPath.navigate()` / `removeLast()` is semantically equivalent and the actual pattern used project-wide |
| All networking through `NetworkService` layer | II. Networking | ✅ PASS | `APITarget` + `NetworkEngine`; no bare `URLSession` or bare `AF.request` |
| All endpoints declared as constants | II. Networking | ✅ PASS | New `APITarget` cases centralise paths; base URL via `AppSecrets.baseURL` |
| `ReachabilityManager` checked before API calls | II. Networking | ✅ PASS | Already enforced inside `APITarget.request(type:callback:)` |
| Protocol delegates for ViewModel→View callbacks | III. Delegate-First | ⚠️ ADAPTED | Project uses SwiftUI `@Published` + `ObservableObject` — this is the SwiftUI-idiomatic equivalent of the delegate pattern and is the established pattern in this codebase. See Complexity Tracking. |
| No force-unwrap; `guard`-first early exit | IV. Code Quality | ✅ PASS | To be enforced during implementation |
| Dead code removal | IV. Code Quality | ✅ PASS | Signup View/ViewModel folders currently empty — no legacy code to clean |
| UI updates on main thread | V. UI Threading | ✅ PASS | SwiftUI guarantees main-thread body evaluation; `@MainActor` used on ViewModels |
| Remote images via Kingfisher | V. UI Threading | N/A | Signup flow uses SVG illustrations, not remote images |
| Colours/images via named assets or R.swift | V. UI Threading | ✅ PASS | Background (`#001B47`), primary text (`#FFFFFF`), accent (`#FAC300`), error (`#CC3333`) to be added as named color assets |
| Storyboard/XIB for layouts | V. UI Standards | ⚠️ JUSTIFIED DEVIATION | This project is 100% SwiftUI (iOS 18.0+). All existing screens including Login and Dashboard use SwiftUI views. Using UIKit Storyboards here would break architectural consistency. See Complexity Tracking. |
| Size Classes for adaptive layout | V. UI Standards | ✅ PASS | SwiftUI's adaptive layout via `GeometryReader`, `adaptiveFrame`, and `adaptiveBottomPadding` (existing helpers already used project-wide) |

**Gate Result: PASS (2 justified deviations documented below)**

## Project Structure

### Documentation (this feature)

```text
specs/003-incomm-signup-flow/
├── plan.md              ← this file
├── research.md          ← Phase 0 output
├── data-model.md        ← Phase 1 output
├── quickstart.md        ← Phase 1 output
├── contracts/
│   └── signup-api.md    ← Phase 1 output
└── tasks.md             ← Phase 2 output (/speckit.tasks — NOT created here)
```

### Source Code

```text
GithubCopilotLearning/
├── Scenes/
│   └── Signup/
│       ├── View/
│       │   ├── WelcomeView.swift
│       │   ├── PersonalInfoView.swift
│       │   ├── VerifyIdentityView.swift
│       │   ├── CreatePasswordView.swift
│       │   ├── TermsAgreementView.swift
│       │   ├── PostSignupNotificationsView.swift
│       │   └── PostSignupBiometricView.swift
│       ├── ViewModel/
│       │   ├── PersonalInfoViewModel.swift
│       │   ├── VerifyIdentityViewModel.swift
│       │   ├── CreatePasswordViewModel.swift
│       │   └── TermsAgreementViewModel.swift
│       └── Subviews/
│           ├── ErrorCalloutView.swift
│           ├── PasswordRuleRowView.swift
│           └── LoadingOverlayView.swift
├── Routers/
│   └── Signup/
│       ├── SignupRouterPath.swift
│       └── SignupAppRegistry.swift
├── Models/
│   ├── Request/
│   │   ├── SignupLookupRequest.swift
│   │   ├── OTPVerificationRequest.swift
│   │   ├── CreatePasswordRequest.swift
│   │   └── TermsAcceptanceRequest.swift
│   └── Response/
│       ├── SignupLookupResponse.swift
│       ├── OTPVerificationResponse.swift
│       ├── CreatePasswordResponse.swift
│       └── TermsAcceptanceResponse.swift
└── NetworkLayer/
    └── APITarget.swift   ← extend with 5 new signup cases
```

**Structure Decision**: Mobile single-target iOS project (Option 3 adapted). No separate `api/` directory because this project is iOS client-only; the backend API already exists. All new code lives under `GithubCopilotLearning/` following the established scene-based folder structure.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|--------------------------------------|
| Protocol delegate pattern replaced by SwiftUI `@Published` / `ObservableObject` (Constitution Principle III) | The entire project uses SwiftUI + `@StateObject` / `@ObservedObject` for reactive bindings. Adding `UIKit`-style delegate protocols to SwiftUI ViewModels would break SwiftUI's data-flow contract and introduce unused type-erasure boilerplate. | Forcing UIKit delegates into a SwiftUI codebase would require wrapper types or `@UIApplicationDelegateAdaptor`, adding unjustified complexity while providing identical safety guarantees. |
| Programmatic SwiftUI layouts instead of Storyboard/XIB (Constitution Principle V) | Every existing screen in the project (Login, Dashboard, SecondView, ThirdView, FourthView) is a SwiftUI view. iOS 18 deployment target makes SwiftUI the canonical layer. Introducing one XIB screen inside a SwiftUI NavigationStack would break the `NavigationDestination` routing pattern and require a `UIHostingController` wrapper. | A single Storyboard-based screen embedded in a SwiftUI `NavigationStack` requires more glue code than a pure SwiftUI screen and would be inconsistent with the 100% SwiftUI codebase. |
