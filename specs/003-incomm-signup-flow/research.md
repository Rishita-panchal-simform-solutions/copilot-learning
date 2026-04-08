# Research: InComm Benefits Signup Flow

**Feature**: 003-incomm-signup-flow  
**Date**: 2026-04-08  
**Status**: Complete — all NEEDS CLARIFICATION resolved

---

## R-001: LocalAuthentication (Face ID / Touch ID) in SwiftUI, iOS 18

### Decision
Use `LAContext` from the `LocalAuthentication` framework. Check `biometryType` after calling `canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics)` to determine Face ID vs Touch ID at runtime. Request auth with `evaluatePolicy` on a background task; publish result back to `@MainActor`.

### Rationale
`LAContext` is the only Apple-supported API for biometric auth. It reliably distinguishes `.faceID` vs `.touchID` via `biometryType` (available after `canEvaluatePolicy` call). No third-party library needed.

### Implementation Pattern
```swift
import LocalAuthentication

@MainActor
class PostSignupBiometricViewModel: ObservableObject {
    @Published var biometryType: LABiometryType = .none
    @Published var enrollmentResult: BiometricEnrollmentResult = .notStarted

    func checkBiometryType() {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            biometryType = .none
            return
        }
        biometryType = context.biometryType
    }

    func enrollBiometric() async {
        let context = LAContext()
        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Set up biometric login for InComm Benefits"
            )
            enrollmentResult = success ? .enrolled : .failed
        } catch {
            enrollmentResult = .failed
        }
    }
}
```

### Alternatives Considered
- `SecAccessControl` with Keychain: overkill for a signup preference prompt; full biometric auth belongs in the login flow, not signup.

---

## R-002: 60-Second OTP Resend Countdown in SwiftUI

### Decision
Use a `Timer.publish(every: 1, on: .main)` combined with an `@Published var resendCooldownSeconds: Int` in the ViewModel. The countdown starts at 60 when Resend is tapped and counts down to 0, at which point the button re-enables.

### Rationale
`Timer.publish` with `autoconnect()` is the idiomatic SwiftUI pattern. It runs on the main runloop, integrates cleanly with Combine, and does not block any background threads.

### Implementation Pattern
```swift
import Combine

@MainActor
class VerifyIdentityViewModel: ObservableObject {
    @Published var resendCooldownSeconds: Int = 0
    var isResendEnabled: Bool { resendCooldownSeconds == 0 }
    private var cancellables = Set<AnyCancellable>()
    private var timerCancellable: AnyCancellable?

    func startResendCooldown() {
        resendCooldownSeconds = 60
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                if resendCooldownSeconds > 0 {
                    resendCooldownSeconds -= 1
                } else {
                    timerCancellable?.cancel()
                }
            }
    }
}
```

### Alternatives Considered
- `Task.sleep` loop: less idiomatic with SwiftUI's `ObservableObject`; harder to cancel.
- `DispatchQueue.main.asyncAfter` recursive calls: cancellation is non-trivial.

---

## R-003: Real-Time Password Validation in SwiftUI

### Decision
Bind the password text field to an `@Published var password: String` in the ViewModel and compute a `PasswordValidationState` struct via a computed property (or `onChange` sink). Each of the four rules is a `Bool` derived from string predicates, updated synchronously on every keystroke.

### Rationale
SwiftUI `TextField`/`SecureField` binding to a `@Published` property triggers a View update on every character. Computing rule booleans is O(n) string iteration — imperceptible delay for a password field. No debounce needed.

### Implementation Pattern
```swift
struct PasswordValidationState {
    var hasUppercase: Bool
    var hasLowercase: Bool
    var hasNumber: Bool
    var hasMinLength: Bool
    var allSatisfied: Bool { hasUppercase && hasLowercase && hasNumber && hasMinLength }
}

@MainActor
class CreatePasswordViewModel: ObservableObject {
    @Published var password: String = ""

    var validationState: PasswordValidationState {
        PasswordValidationState(
            hasUppercase: password.range(of: "[A-Z]", options: .regularExpression) != nil,
            hasLowercase: password.range(of: "[a-z]", options: .regularExpression) != nil,
            hasNumber:    password.range(of: "[0-9]", options: .regularExpression) != nil,
            hasMinLength: password.count >= 8
        )
    }
}
```

### Alternatives Considered
- `Navajo-Swift` (already a pod in the project): provides `NAVPasswordStrength` but doesn't map exactly to the four Figma rules. Using it would require translating its strength enum back to the four booleans anyway. Keeping the rules as simple predicates is clearer.

---

## R-004: Date Picker for Date of Birth in SwiftUI iOS 18

### Decision
Use a `DatePicker` with `displayedComponents: .date` styled as `.compact` or `.graphical`. Present it inline below the DOB text field label. Bind to `@Published var dateOfBirth: Date` in the ViewModel; format for display and API submission using `DateFormatter` with `"MM/dd/yyyy"` format.

### Rationale
iOS 16+ `DatePicker` with `.compact` style shows the calendar icon and tappable date label matching the Figma calendar-icon affordance. No custom component needed.

### Implementation Pattern
```swift
// In View
DatePicker(
    "Date of Birth",
    selection: $viewModel.dateOfBirth,
    in: ...Date.now,
    displayedComponents: .date
)
.datePickerStyle(.compact)
.labelsHidden()

// In ViewModel — format for API submission
var dateOfBirthString: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd/yyyy"
    return formatter.string(from: dateOfBirth)
}
```

### Alternatives Considered
- Custom text field with manual parsing: fragile, locale-sensitive, blocked by Navajo-Swift only for passwords. Not worth the complexity.

---

## R-005: Full-Screen Loading Overlay in SwiftUI

### Decision
Use a `ZStack` overlay driven by `@Published var isLoading: Bool` in each ViewModel. A reusable `LoadingOverlayView` wraps a `Color.black.opacity(0.45)` fill + `ProgressView()`. Applied at the bottom of each screen's root `ZStack` so it renders above all content.

### Rationale
A `ZStack`-based overlay in the View layer keeps loading state in the ViewModel (`isLoading`) while placing the visual presentation entirely in the View. This cleanly satisfies Principle I (no UI in ViewModel) and Principle IV (no state coupling).

### Implementation Pattern
```swift
// Reusable component — Subviews/LoadingOverlayView.swift
struct LoadingOverlayView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.45).ignoresSafeArea()
            ProgressView()
                .progressViewStyle(.circular)
                .tint(.white)
                .scaleEffect(1.5)
        }
    }
}

// Usage in any screen
ZStack {
    PersonalInfoContentView()
    if viewModel.isLoading {
        LoadingOverlayView()
    }
}
.disabled(viewModel.isLoading) // block interaction
```

### Alternatives Considered
- Sheet / full-screen cover: overkill; adds navigation stack noise.
- ProgressView in button label: does not block the rest of the form (FR-021 requires full-screen block).

---

## R-006: SignupRouterPath — Navigation Architecture

### Decision
Create a dedicated `SignupRouterPath` class following the exact pattern of `OnboardingRouterPath`. Define a `SignupRouterDestination` enum with cases for each of the 7 post-Welcome signup screens. Extend `View` with `signupWithAppRouter(_:)` and link destination views via `NavigationDestination`.

### Rationale
The project's entire navigation layer uses this RouterPath pattern. Introducing a second pattern for signup would create architectural inconsistency. The existing `OnboardingRouterPath` covers Welcome→Login; a separate `SignupRouterPath` keeps signup isolated and avoids polluting the onboarding destinations.

### Alternatives Considered
- Reusing `OnboardingRouterPath` for signup destinations: would create a single monolithic router with unrelated concerns mixed together.
- Environment-based sheet presentation: only appropriate for modal flows; signup is a full push flow.

---

## R-007: Error Callout Component

### Decision
Create a reusable `ErrorCalloutView(icon:title:body:ctaLabel:ctaAction:)` component in `Subviews/`. It mirrors the Figma "Variant2 Card" component — a horizontal row with a material icon, title + body text block, and an optional CTA button. Border stroke `#CC3333` (3px), background `#FFFFFF`, corner radius 8px.

### Rationale
Three distinct error states (account not ready, duplicate, HSA not found) plus the OTP invalid error use the same visual component with different content. A parameterised reusable view eliminates duplication across four screens.

### Alternatives Considered
- SwiftUI Alert: Figma specifies inline callout banners specifically (FR-017). Alerts are modal; they interrupt the background and deviate from the design.
- SwiftMessages (already a pod): designed for toast/snackbar messages, not for inline persistent banners. Using it here would fight its animation model.
