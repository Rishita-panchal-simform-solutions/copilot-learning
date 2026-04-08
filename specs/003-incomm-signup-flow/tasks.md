# Tasks: InComm Benefits Signup Flow

**Input**: Design documents from `/specs/003-incomm-signup-flow/`  
**Prerequisites**: [plan.md](plan.md) · [spec.md](spec.md) · [research.md](research.md) · [data-model.md](data-model.md) · [contracts/signup-api.md](contracts/signup-api.md) · [quickstart.md](quickstart.md)  
**Branch**: `003-incomm-signup-flow`  
**Generated**: 2026-04-08

## Format: `[ID] [P?] [Story?] Description — file path`

- **[P]**: Can run in parallel (different files, no incomplete dependencies)
- **[Story]**: User story this task belongs to (US1–US5); omitted for Setup/Foundation/Polish

---

## Phase 1: Setup

**Purpose**: Project initialization — color assets, constants, and scaffolding needed by every subsequent task.

- [X] T001 Add named color assets for signup palette (Background `#001B47`, Primary Text `#FFFFFF`, Accent `#FAC300`, Error `#CC3333`) in `GithubCopilotLearning/Resources/Assets.xcassets`
- [X] T002 [P] Add `signupSupportEmail` constant (Contact Us address) and `SignupStrings` namespace for reusable copy in `GithubCopilotLearning/Constants/Constants.swift`
- [X] T003 [P] Verify R.swift regenerates correctly after new color assets are added; resolve any project file registration issues in `GithubCopilotLearning/GithubCopilotLearning.xcodeproj/project.pbxproj`

**Checkpoint**: Color assets compile, constant is accessible app-wide, R.swift references are valid.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Shared infrastructure that ALL user story phases depend on. No user story work can begin until this phase is complete.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete.

- [X] T004 Create `SignupSession.swift` (in-memory session struct with all 11 fields + `BenefitAccountType`, `AccountStatus` enums per data-model.md §1–2) in `GithubCopilotLearning/Models/SignupSession.swift`
- [X] T005 [P] Create `LoadingOverlayView.swift` (full-screen semi-transparent overlay with centred `ProgressView`; disabled interaction while visible) in `GithubCopilotLearning/Scenes/Signup/Subviews/LoadingOverlayView.swift`
- [X] T006 [P] Create `ErrorCalloutView.swift` (inline banner accepting a message string and optional CTA button; styled with error colour asset) in `GithubCopilotLearning/Scenes/Signup/Subviews/ErrorCalloutView.swift`
- [X] T007 Extend `APITarget.swift` with 5 new signup cases: `.signupLookup`, `.signupResendOTP`, `.signupVerifyOTP`, `.signupCreatePassword`, `.signupAcceptTerms` — each with `path`, `method: .post`, and `httpPreTokenHeader`, plus a `#warning` placeholder noting API paths must be confirmed with backend in `GithubCopilotLearning/NetworkLayer/APITarget.swift`
- [X] T008 Create `SignupRouterPath.swift` (`@MainActor ObservableObject` with `@Published var path: [SignupRouterDestination]`, `navigate(_:)`, `removeLast()`, `popToRoot()`) in `GithubCopilotLearning/Routers/Signup/SignupRouterPath.swift`
- [X] T009 Create `SignupAppRegistry.swift` (`View` extension with `navigationDestination(for: SignupRouterDestination.self)` registering all signup screen destinations; `SignupRouterDestination` enum with cases for each screen) in `GithubCopilotLearning/Routers/Signup/SignupAppRegistry.swift`

**Checkpoint**: Project compiles. `APITarget` has 5 new cases. Router enum and path object exist. Subview components render in Xcode Previews.

---

## Phase 3: User Story 1 — Personal Information Entry (Priority: P1) 🎯 MVP

**Goal**: Welcome screen + Personal Information form + account-lookup API integration. Delivers the entry point of the entire flow.

**Independent Test**: Launch app unauthenticated → tap Sign Up → fill SSN last-4, DOB, work email → tap Submit → loading overlay appears → (mock or live API) success navigates to next screen. All three error callout variants (not ready, duplicate, HSA not found) render correctly.

### Implementation for User Story 1

- [X] T010 [P] [US1] Create `SignupLookupRequest.swift` (`Codable` struct: `ssnLast4`, `dateOfBirth: String`, `workEmail`) in `GithubCopilotLearning/Models/Request/SignupLookupRequest.swift`
- [X] T011 [P] [US1] Create `SignupLookupResponse.swift` (`Codable` struct: `accountStatus: AccountStatus`, `employerName: String?`, `maskedEmail: String?`, `accountStartDate: String?`, `benefitAccountType: BenefitAccountType?`) in `GithubCopilotLearning/Models/Response/SignupLookupResponse.swift`
- [X] T012 [US1] Implement `PersonalInfoViewModel.swift` (`@MainActor ObservableObject`; `@Published` fields for `ssnLast4`, `dateOfBirth`, `workEmail`, `isLoading`, `errorMessage`, `lookupResult`; `submitPersonalInfo()` calls `APITarget.signupLookup`; checks `ReachabilityManager.shared.isNetworkReachable` before API call; populates `SignupSession` on success) in `GithubCopilotLearning/Scenes/Signup/ViewModel/PersonalInfoViewModel.swift`
- [X] T013 [US1] Implement `WelcomeView.swift` (SwiftUI view: "Welcome to InComm Benefits!" title, Sign Up primary button calling `routerPath.navigate(.personalInfo)`, "Already registered? Log In" secondary link pops signup stack) in `GithubCopilotLearning/Scenes/Signup/View/WelcomeView.swift`
- [X] T014 [US1] Implement `PersonalInfoView.swift` (SwiftUI view: three input fields — SSN last-4 numeric, DOB `DatePicker` with calendar icon, work email; Submit button guarded by field validity; `ZStack` with `LoadingOverlayView` while `viewModel.isLoading`; `ErrorCalloutView` for each error variant; Contact Us mailto action; Back button calls `routerPath.removeLast()`) in `GithubCopilotLearning/Scenes/Signup/View/PersonalInfoView.swift`
- [X] T015 [US1] Register `.welcome` and `.personalInfo` destinations in `SignupAppRegistry.swift` and wire the signup `NavigationStack` entry point from `LoginView` (add a `NavigationLink` or `.fullScreenCover` that presents `WelcomeView` inside a `NavigationStack` owned by a new `SignupRouterPath` instance) in `GithubCopilotLearning/Scenes/Signup/SignupAppRegistry.swift` and `GithubCopilotLearning/Scenes/Login/View/LoginView.swift`

**Checkpoint**: User Story 1 is fully functional. Welcome → Personal Info → (mock lookup) → navigation transition works. All three lookup error callouts render. Back navigation returns to Welcome without recreating it.

---

## Phase 4: User Story 2 — Identity Verification via OTP (Priority: P2)

**Goal**: Verify Identity screen with 6-digit code entry, invalid-code error, and 60-second resend cooldown.

**Independent Test**: Navigate directly to VerifyIdentityView with a pre-seeded `SignupSession` (employerName + maskedEmail populated). Submit a valid code → mock success → navigates to Create Password. Submit invalid code → error callout renders. Tap Resend → countdown starts; button re-enables at 0.

### Implementation for User Story 2

- [X] T016 [P] [US2] Create `OTPVerificationRequest.swift` (`Codable` struct: `workEmail`, `code`) in `GithubCopilotLearning/Models/Request/OTPVerificationRequest.swift`
- [X] T017 [P] [US2] Create `ResendOTPRequest.swift` (`Codable` struct: `workEmail`) in `GithubCopilotLearning/Models/Request/ResendOTPRequest.swift`
- [X] T018 [P] [US2] Create `OTPVerificationResponse.swift` (`Codable` struct: `verified: Bool`) in `GithubCopilotLearning/Models/Response/OTPVerificationResponse.swift`
- [X] T019 [US2] Implement `VerifyIdentityViewModel.swift` (`@MainActor ObservableObject`; `@Published` fields for `otpCode`, `isLoading`, `errorMessage`, `resendCooldownSeconds`; `verify()` calls `APITarget.signupVerifyOTP`; `resend()` calls `APITarget.signupResendOTP` then starts `Timer.publish(every: 1, on: .main)` counting down from 60; checks `ReachabilityManager.shared.isNetworkReachable` before each call) in `GithubCopilotLearning/Scenes/Signup/ViewModel/VerifyIdentityViewModel.swift`
- [X] T020 [US2] Implement `VerifyIdentityView.swift` (SwiftUI view: employer name + masked email display; 6-digit code input; Verify button with loading overlay; `ErrorCalloutView` for invalid code; Resend button disabled when `viewModel.resendCooldownSeconds > 0` showing countdown label; Back button calls `routerPath.removeLast()`) in `GithubCopilotLearning/Scenes/Signup/View/VerifyIdentityView.swift`
- [X] T021 [US2] Register `.verifyIdentity` destination in `SignupAppRegistry.swift` in `GithubCopilotLearning/Routers/Signup/SignupAppRegistry.swift`

**Checkpoint**: User Story 2 is fully functional and independently testable. Countdown timer works correctly. Invalid-code error does not navigate away.

---

## Phase 5: User Story 3 — Password Creation with Real-Time Validation (Priority: P3)

**Goal**: Create Password screen with live 4-rule validation indicators, show/hide toggle, and blocked Submit until all rules pass.

**Independent Test**: Navigate directly to CreatePasswordView with pre-seeded `SignupSession`. Type characters — confirm each of the 4 rule rows updates live (green / red). Type a fully valid password → Next button enabled → tapping it navigates to Terms screen. Type a partial password → Next tapping is blocked.

### Implementation for User Story 3

- [X] T022 [P] [US3] Create `CreatePasswordRequest.swift` (`Codable` struct: `workEmail`, `password`) in `GithubCopilotLearning/Models/Request/CreatePasswordRequest.swift`
- [X] T023 [P] [US3] Create `CreatePasswordResponse.swift` (`Codable` struct: `userId: String`) in `GithubCopilotLearning/Models/Response/CreatePasswordResponse.swift`
- [X] T024 [P] [US3] Create `PasswordRuleRowView.swift` (reusable row: coloured circle indicator + rule label; takes `isSatisfied: Bool` and `label: String`) in `GithubCopilotLearning/Scenes/Signup/Subviews/PasswordRuleRowView.swift`
- [X] T025 [US3] Implement `CreatePasswordViewModel.swift` (`@MainActor ObservableObject`; `@Published var password: String`; computed `PasswordValidationState` (`hasUppercase`, `hasLowercase`, `hasNumber`, `hasMinLength`, `allSatisfied`) updated on every `password` change via `onChange`; `@Published var isPasswordVisible: Bool`; `@Published var isLoading: Bool`; `createPassword()` calls `APITarget.signupCreatePassword`, stores `userId` in `SignupSession`, checks reachability) in `GithubCopilotLearning/Scenes/Signup/ViewModel/CreatePasswordViewModel.swift`
- [X] T026 [US3] Implement `CreatePasswordView.swift` (SwiftUI view: read-only email field; password `SecureField` / `TextField` toggled by `isPasswordVisible`; eye-icon toggle button; four `PasswordRuleRowView` rows driven by `viewModel.validationState`; Next button disabled when `!viewModel.validationState.allSatisfied`; loading overlay; Contact Us mailto) in `GithubCopilotLearning/Scenes/Signup/View/CreatePasswordView.swift`
- [X] T027 [US3] Register `.createPassword` destination in `SignupAppRegistry.swift` in `GithubCopilotLearning/Routers/Signup/SignupAppRegistry.swift`

**Checkpoint**: User Story 3 is fully functional. Rule indicators update in real-time. Next is only enabled when all 4 rules pass. Show/hide toggle works.

---

## Phase 6: User Story 4 — Terms & Agreements Acceptance (Priority: P4)

**Goal**: Terms & Agreements screen dynamically composing the correct agreement checklist per `BenefitAccountType`, with Create Login blocked until all boxes are checked.

**Independent Test**: Render `TermsAgreementView` for each of the four `BenefitAccountType` variants. Verify correct number of checkboxes (HSA=3, FSA=3, DCFSA=2, Both=4). Confirm Create Login is disabled until all are checked. Confirm API call fires and on success navigates to Notifications screen.

### Implementation for User Story 4

- [X] T028 [P] [US4] Create `TermsItem.swift` (value type: `id: String`, `displayText: String`, `documentURL: URL?`; static factory `TermsItem.items(for: BenefitAccountType) -> [TermsItem]` returning the correct subset per data-model.md §12 agreement matrix) in `GithubCopilotLearning/Models/TermsItem.swift`
- [X] T029 [P] [US4] Create `TermsAcceptanceRequest.swift` (`Codable` struct: `userId: String`, `acceptedTerms: [String]`) in `GithubCopilotLearning/Models/Request/TermsAcceptanceRequest.swift`
- [X] T030 [P] [US4] Create `TermsAcceptanceResponse.swift` (`Codable` struct: `accountCreated: Bool`) in `GithubCopilotLearning/Models/Response/TermsAcceptanceResponse.swift`
- [X] T031 [US4] Implement `TermsAgreementViewModel.swift` (`@MainActor ObservableObject`; derives `terms: [TermsItem]` from `session.benefitAccountType` via `TermsItem.items(for:)`; `@Published var checkedIds: Set<String>`; computed `allChecked: Bool`; `acceptTerms()` calls `APITarget.signupAcceptTerms` with `session.userId` and `Array(checkedIds)`; checks reachability) in `GithubCopilotLearning/Scenes/Signup/ViewModel/TermsAgreementViewModel.swift`
- [X] T032 [US4] Implement `TermsAgreementView.swift` (SwiftUI view: "One final step!" title; `ForEach` over `viewModel.terms` rendering a `Toggle` / checkbox row per item; Create Login button disabled when `!viewModel.allChecked`; loading overlay; on success navigates to `.postSignupNotifications`) in `GithubCopilotLearning/Scenes/Signup/View/TermsAgreementView.swift`
- [X] T033 [US4] Register `.termsAgreement` destination in `SignupAppRegistry.swift` in `GithubCopilotLearning/Routers/Signup/SignupAppRegistry.swift`

**Checkpoint**: User Story 4 is fully functional. All four account-type variants render the correct agreement list. Create Login fires API and advances on success.

---

## Phase 7: User Story 5 — Post-Signup Optional Setup (Priority: P5)

**Goal**: "Login created successfully!" confirmation + Notifications prompt + Biometric prompt (Face ID / Touch ID adaptive), each independently skippable.

**Independent Test**: Simulate post-account-creation state. Confirm Notifications prompt appears; Agree triggers `UNUserNotificationCenter.requestAuthorization`; Skip advances without requesting. Confirm Biometric prompt detects Face ID vs Touch ID via `LAContext.biometryType`. Skip on Biometric ends the signup flow and routes to the main app experience.

### Implementation for User Story 5

- [X] T034 [US5] Implement `PostSignupNotificationsView.swift` (SwiftUI view: "Login created successfully!" banner at top; "Would it be ok if we send notifications?" prompt; **Agree to Notifications** button calls `UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])` then navigates to `.postSignupBiometric`; **Skip This Step** navigates directly to `.postSignupBiometric`) in `GithubCopilotLearning/Scenes/Signup/View/PostSignupNotificationsView.swift`
- [X] T035 [US5] Implement `PostSignupBiometricView.swift` (SwiftUI view: uses `LAContext().biometryType` at `onAppear` to set button label "Set Up Face ID Login" or "Set Up Touch ID Login"; **Set Up [FaceID/TouchID] Login** button calls `LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, ...)` then completes signup flow; **Skip This Step** completes signup flow without biometrics; "complete signup flow" = pop to root of main app navigation) in `GithubCopilotLearning/Scenes/Signup/View/PostSignupBiometricView.swift`
- [X] T036 [US5] Register `.postSignupNotifications` and `.postSignupBiometric` destinations in `SignupAppRegistry.swift`; implement flow-completion action (pop signup stack / route to main app) in `GithubCopilotLearning/Routers/Signup/SignupAppRegistry.swift`

**Checkpoint**: User Story 5 is fully functional. Both optional prompts appear in sequence. Skip on either skips correctly. Biometric label adapts to device. Flow completion routes to main app.

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Quality, accessibility, and final validation across all user stories.

- [X] T037 [P] Validate adaptive layout on iPad (Regular × Regular size class) for all 7 signup screens using `GeometryReader` / `adaptiveFrame` / `adaptiveBottomPadding` helpers already used project-wide in `GithubCopilotLearning/Scenes/Signup/View/`
- [X] T038 [P] Add accessibility labels and accessibility identifiers to all interactive elements across signup screens (SSN field, DOB picker, email field, OTP input, password field, eye toggle, all checkboxes, CTA buttons) in `GithubCopilotLearning/Scenes/Signup/View/`
- [X] T039 [P] Audit all 7 views and 4 ViewModels for dead code, force-unwraps (`!`), and force casts (`as!`); remove any unused boilerplate in `GithubCopilotLearning/Scenes/Signup/`
- [X] T040 Run quickstart.md end-to-end flow validation on iOS 18 simulator: Welcome → Personal Info → (live or mock backend) → Verify OTP → Create Password → Terms → Notifications → Biometric → main app; confirm no screen recreations and no main-thread warnings in Xcode console
- [X] T041 [P] Confirm `#warning("Replace endpoint paths…")` comments in `APITarget.swift` are visible and escalate removal to backend handoff task in `GithubCopilotLearning/NetworkLayer/APITarget.swift`

---

## Dependencies & Execution Order

### Phase Dependencies

| Phase | Depends On | Blocks |
|-------|------------|--------|
| Phase 1 Setup | Nothing | Phase 2 |
| Phase 2 Foundational | Phase 1 | All US phases |
| Phase 3 US1 (P1) | Phase 2 | Phase 8 |
| Phase 4 US2 (P2) | Phase 2 | Phase 8 |
| Phase 5 US3 (P3) | Phase 2 | Phase 8 |
| Phase 6 US4 (P4) | Phase 2 | Phase 8 |
| Phase 7 US5 (P5) | Phase 6 (needs account creation) | Phase 8 |
| Phase 8 Polish | All US phases | Nothing |

### User Story Dependencies

- **US1 (P1)**: Depends on Foundational only. No dependency on US2–5. Independently testable.
- **US2 (P2)**: Depends on Foundational. Uses `SignupSession.workEmail` populated by US1 (pass via constructor for independent testing).
- **US3 (P3)**: Depends on Foundational. Uses `SignupSession.workEmail`. Independently testable with pre-seeded session.
- **US4 (P4)**: Depends on Foundational. Uses `SignupSession.benefitAccountType` and `userId`. Independently testable with pre-seeded session.
- **US5 (P5)**: Depends on US4 completing account creation (needs the Notifications + Biometric screens to follow account activation). Can be UI-tested independently by navigating directly.

### Within Each User Story

1. Request model(s) [P] + Response model(s) [P] → can be created simultaneously
2. ViewModel (depends on models)
3. View (depends on ViewModel)
4. Router registration (depends on View existing)

---

## Parallel Opportunities

### Phase 2 Parallelism (all independent files)
```
T005 LoadingOverlayView.swift
T006 ErrorCalloutView.swift     ← run simultaneously with T005
T007 APITarget signup cases     ← run simultaneously
T008 SignupRouterPath.swift     ← run simultaneously with T007
T009 SignupAppRegistry.swift    ← run after T008 (needs destination enum)
```
Note: T004 `SignupSession.swift` must precede T007 (APITarget uses request types).

### Phase 3 Parallelism (US1)
```
T010 SignupLookupRequest.swift   ← run simultaneously
T011 SignupLookupResponse.swift  ← run simultaneously
→ T012 PersonalInfoViewModel.swift  (depends on T010, T011)
→ T013 WelcomeView.swift            (depends on T008 router)
→ T014 PersonalInfoView.swift       (depends on T012, T013)
→ T015 Router wiring               (depends on T014)
```

### Phase 4 Parallelism (US2)
```
T016 OTPVerificationRequest.swift  ← run simultaneously
T017 ResendOTPRequest.swift        ← run simultaneously
T018 OTPVerificationResponse.swift ← run simultaneously
→ T019 VerifyIdentityViewModel.swift
→ T020 VerifyIdentityView.swift
→ T021 Router registration
```

### Phase 5 Parallelism (US3)
```
T022 CreatePasswordRequest.swift  ← run simultaneously
T023 CreatePasswordResponse.swift ← run simultaneously
T024 PasswordRuleRowView.swift    ← run simultaneously
→ T025 CreatePasswordViewModel.swift
→ T026 CreatePasswordView.swift
→ T027 Router registration
```

### Phase 6 Parallelism (US4)
```
T028 TermsItem.swift              ← run simultaneously
T029 TermsAcceptanceRequest.swift ← run simultaneously
T030 TermsAcceptanceResponse.swift← run simultaneously
→ T031 TermsAgreementViewModel.swift
→ T032 TermsAgreementView.swift
→ T033 Router registration
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (T001–T003)
2. Complete Phase 2: Foundational (T004–T009) — **CRITICAL BLOCKER**
3. Complete Phase 3: US1 (T010–T015)
4. **STOP and VALIDATE**: Welcome → Personal Info → account lookup works end-to-end
5. Demo / review before continuing to US2

### Incremental Delivery

| Increment | Delivers | Test |
|-----------|---------|------|
| Phase 1 + 2 + 3 (US1) | Welcome + Personal Info + account-lookup API | MVP — entry point live |
| + Phase 4 (US2) | OTP entry + resend cooldown | Identity verification live |
| + Phase 5 (US3) | Password creation + real-time rules | Password setup live |
| + Phase 6 (US4) | Terms acceptance + dynamic agreement sets | Legal acceptance live |
| + Phase 7 (US5) | Notifications + Biometric prompts | Full flow complete |
| + Phase 8 | Polish, iPad layout, accessibility | Production-ready |

### Parallel Team Strategy

Once Phase 2 (Foundational) is complete, all four user story phases (US1–US4) can be worked on simultaneously by different developers, since each targets different files.

---

## Summary

| Metric | Count |
|--------|-------|
| Total tasks | 41 |
| Phase 1 Setup | 3 |
| Phase 2 Foundational | 6 |
| Phase 3 US1 (P1) | 6 |
| Phase 4 US2 (P2) | 6 |
| Phase 5 US3 (P3) | 6 |
| Phase 6 US4 (P4) | 6 |
| Phase 7 US5 (P5) | 3 |
| Phase 8 Polish | 5 |
| Parallelizable tasks [P] | 22 |
| Parallel batches available | 6 (one per story's model layer) |
| MVP scope | Phases 1–3 (US1) — 15 tasks |

**Format validation**: All 41 tasks follow `- [X] T### [P?] [US?] Description — file path` format. ✅
