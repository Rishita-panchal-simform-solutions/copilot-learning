# Quickstart: InComm Benefits Signup Flow

**Feature**: 003-incomm-signup-flow  
**Date**: 2026-04-08

## Overview

This feature adds a 9-screen signup flow to the GithubCopilotLearning iOS app. The entry point is the existing `LoginView` (the "Already registered? / Sign Up" link). The signup flow is isolated in its own `SignupRouterPath` + `NavigationStack`.

## Prerequisites

1. Xcode 15+ with iOS 18.0 simulator or device
2. Project builds and runs with `pod install` completed
3. `arkana` run with `.env` containing `BASE_URL` for your target environment
4. Feature branch checked out: `git checkout 003-incomm-signup-flow`

## File Locations

| What | Where |
|------|-------|
| Signup screens (Views) | `GithubCopilotLearning/Scenes/Signup/View/` |
| ViewModels | `GithubCopilotLearning/Scenes/Signup/ViewModel/` |
| Reusable sub-components | `GithubCopilotLearning/Scenes/Signup/Subviews/` |
| Router | `GithubCopilotLearning/Routers/Signup/` |
| Request models | `GithubCopilotLearning/Models/Request/` |
| Response models | `GithubCopilotLearning/Models/Response/` |
| API endpoints | `GithubCopilotLearning/NetworkLayer/APITarget.swift` |

## Navigation Entry Point

Signup is triggered from `LoginView` (existing screen). The `registerNow` button in `LoginView` should navigate to `WelcomeView` embedded in a `NavigationStack` using a new `SignupRouterPath`.

Connect it by adding a `SignupRouterDestination` case to the existing onboarding router **or** by presenting `WelcomeView` as a full-screen cover / new `NavigationStack` root. The exact wiring is an implementation decision for the task author; the `SignupRouterPath` is self-contained.

## Adding a New Screen

Follow this checklist for every new signup screen:

1. **Create the View** in `Scenes/Signup/View/`
   - `struct MyView { @StateObject private var viewModel = MyViewModel() }`
   - Root layout: `ZStack` with content + `if viewModel.isLoading { LoadingOverlayView() }`

2. **Create the ViewModel** in `Scenes/Signup/ViewModel/`
   - `@MainActor class MyViewModel: ObservableObject`
   - `@Published var isLoading = false`
   - Check `ReachabilityManager.shared.isNetworkReachable` before every API call (already enforced inside `APITarget.request` but add an explicit guard for immediate UI feedback)

3. **Add a router destination** in `SignupRouterPath.swift`
4. **Register the view** in `SignupAppRegistry.swift`
5. **Add an `APITarget` case** for any new endpoint
6. **Add request/response models** in `Models/Request/` and `Models/Response/`

## Running the Flow End-to-End

1. Build and run on any iOS 18 simulator
2. Tap "Sign Up" from the Login / Welcome screen
3. Fill in: SSN last-4 (e.g. `1234`), Date of Birth, Work Email → Submit
4. Enter the OTP code received at the work email → Verify
5. Create password (all 4 rule indicators must go green) → Next
6. Accept all agreement checkboxes → Create Login
7. Choose notification preference → Continue to biometric prompt → Skip or Set Up

## Key Patterns to Follow

### API Call (ViewModel)
```swift
func submitPersonalInfo() {
    guard ReachabilityManager.shared.isNetworkReachable else {
        // surface connectivity error via @Published errorMessage
        return
    }
    isLoading = true
    let request = AccountLookupRequest(
        ssnLast4: ssnLast4,
        dateOfBirth: dateOfBirthString,
        workEmail: workEmail
    )
    APITarget.signupLookup(request: request)
        .request(type: BaseResponseModel<AccountLookupResponse>.self) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    self?.handleLookupResponse(response)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
}
```

### Back Navigation (View)
```swift
// In View — pop, never recreate
Button("Back") {
    routerPath.removeLast()
}
// Equivalent to UINavigationController.popViewController in UIKit
```

### Loading Overlay (View)
```swift
ZStack {
    formContent
    if viewModel.isLoading {
        LoadingOverlayView()
    }
}
.disabled(viewModel.isLoading)
```

## Testing

Run unit tests from Xcode: `Product → Test` or `⌘U`.

Key test targets:
- `CreatePasswordViewModelTests` — verify all 4 password rule booleans update correctly per input
- `TermsAgreementViewModelTests` — verify correct agreement set per `BenefitAccountType`
- `VerifyIdentityViewModelTests` — verify 60-second countdown starts and stops correctly

## Known Constraints

- Signup session state is **in-memory only** — force-quitting resets the flow to Welcome
- OTP resend is locked for 60 seconds client-side after each tap
- Biometric setup at signup only registers the user preference; actual biometric auth is part of the Login flow (out of scope here)
- Backend API paths are placeholder (`/signup/...`); update `APITarget.path` when real paths are confirmed
