# Feature Specification: InComm Benefits Signup Flow

**Feature Branch**: `003-incomm-signup-flow`  
**Created**: 2026-04-08  
**Status**: Draft  
**Figma Reference**: [InComm Internal – Sign Up section](https://www.figma.com/design/PPEIt1bMPiJ7XDOhMro7dl/InComm-Internal?node-id=2-6640)

## Clarifications

### Session 2026-04-08

- Q: If a user starts signup and then backgrounds or force-quits the app, what should happen when they relaunch? → A: Restart from Welcome screen — all transient signup state is in-memory only; killing or backgrounding the app discards it and the user must start over.
- Q: After the user taps Resend on the Verify Identity screen, should there be a cooldown before they can tap Resend again? → A: Timed cooldown — after tapping Resend the button is disabled for 60 seconds with a visible countdown timer; the server may also enforce its own rate limit.
- Q: While async operations are in progress (account lookup, OTP verification, account creation), what should the UI show to block further input? → A: Full-screen overlay with spinner — a semi-transparent overlay covers the entire screen with a centred activity indicator, preventing all user interaction until the response arrives.
- Q: What should tapping Contact Us do on the four screens where it appears? → A: Open default mail client — tapping Contact Us opens the device's default mail app with the support email address pre-filled (address stored as an app configuration constant).
- Q: On the "It looks like you already have an account" error callout, what should the CTA button do? → A: Navigate to Login screen — button label "Go to Login"; pops the signup navigation stack and routes the user to the existing login entry point.

## User Scenarios & Testing *(mandatory)*

### User Story 1 – Personal Information Entry (Priority: P1)

A first-time user opens the InComm Benefits app for the first time and is presented with a welcome screen ("Welcome to InComm Benefits!"). They tap **Sign Up** and are taken to the Personal Information screen ("Let's find your account."). They enter their last 4 digits of their Social Security Number, Date of Birth (using a date picker accessed via a calendar icon), and Work Email address, then tap **Submit** to proceed.

**Why this priority**: This is the entry point of the entire signup flow. Without a working Personal Information screen, no subsequent step can be reached. It also covers the welcome/landing screen which is the first thing every new user sees.

**Independent Test**: Can be fully tested by launching the app in the unauthenticated state, tapping Sign Up, filling in all three fields with valid data, and confirming the "Submit" action triggers navigation to the next screen. Delivers a working account-lookup entry point.

**Acceptance Scenarios**:

1. **Given** the app is opened for the first time (no authenticated session), **When** the user views the launch screen, **Then** the welcome screen is displayed with the title "Welcome to InComm Benefits!", a Sign Up primary button, and an "Already registered? Log In" secondary link.
2. **Given** the user is on the welcome screen, **When** they tap **Sign Up**, **Then** the Personal Information screen is displayed with the title "Let's find your account." and three input fields: Last 4 digits of SSN, Date of Birth (with calendar icon), Work Email.
3. **Given** all three fields are filled with valid values, **When** the user taps **Submit**, **Then** a full-screen loading overlay with a spinner is displayed, the app calls the account-lookup API, and on success the overlay is dismissed and the user is navigated to the Verify Identity screen.
4. **Given** the user is on the Personal Information screen, **When** they tap **Back**, **Then** the app navigates back to the welcome screen.
5. **Given** the user is on the Personal Information screen, **When** they tap **Contact Us**, **Then** the device's default mail client opens with the support email address pre-filled.
6. **Given** the account-lookup API returns a duplicate-account error, **When** the callout is displayed, **Then** a **Go to Login** button is shown; tapping it pops the signup navigation stack and navigates the user to the Login screen.

---

### User Story 2 – Identity Verification via 6-Digit OTP (Priority: P2)

After personal information is submitted and the account is found, the user is taken to the Verify Identity screen ("Verify your identity."). The screen displays the employer name and the masked email to which the code was sent. The user enters the 6-digit security code and taps **Verify** to proceed. If they did not receive the code they can tap **Resend**.

**Why this priority**: OTP verification is the security gate that proves the user owns the work email account. Without this step, account creation cannot proceed securely.

**Independent Test**: Can be fully tested by pre-populating a known account state and navigating directly to the Verify Identity screen, submitting a valid code, and confirming progression to the Create Password screen.

**Acceptance Scenarios**:

1. **Given** the user arrives on the Verify Identity screen, **When** the screen loads, **Then** it displays the employer name and the masked destination email address where the code was sent.
2. **Given** the user enters a valid 6-digit code, **When** they tap **Verify**, **Then** a full-screen loading overlay with a spinner is displayed, the code is validated, and on success the overlay is dismissed and the user is navigated to the Create Password screen.
3. **Given** the user enters an incorrect code, **When** they tap **Verify**, **Then** an error callout is displayed with the message "The code you entered is invalid. Please try again." and the input remains editable.
4. **Given** the user has not received a code, **When** they tap **Resend**, **Then** a new code is dispatched, a confirmation indication is shown, and the Resend button is disabled for 60 seconds with a visible countdown timer. Once the timer expires the button re-enables.
5. **Given** the user taps **Back**, **Then** the app navigates back to the Personal Information screen.

---

### User Story 3 – Password Creation with Real-Time Validation (Priority: P3)

After identity is verified the user reaches the Create Password screen ("Hi [FirstName]! Let's create your login."). Their work email is pre-filled as a read-only field. The user enters a new password in a masked field (with a show/hide eye toggle). As they type, four validation rules update in real-time with pass/fail indicators: capital letter required, lowercase letter required, number required, 8 characters required. Tapping **Next** proceeds once all rules pass.

**Why this priority**: Password creation is the final authentication credential setup step. Real-time validation prevents user frustration and support tickets caused by rejected passwords.

**Independent Test**: Can be fully tested by navigating to the Create Password screen with a pre-verified session state, typing a password, observing each rule indicator update live, and confirming "Next" is actionable only when all rules pass.

**Acceptance Scenarios**:

1. **Given** the user is on the Create Password screen, **When** the screen loads, **Then** the Email field is populated with the user's work email and is not editable (read-only / NoEdit mode).
2. **Given** the user begins typing a password, **When** each character is entered, **Then** each applicable rule indicator updates immediately: green-filled circle = rule satisfied, red-filled circle = rule not yet satisfied.
3. **Given** the password satisfies all four rules (capital letter, lowercase letter, number, 8+ characters), **When** the user taps **Next**, **Then** the app proceeds to the Terms & Agreements screen.
4. **Given** one or more rules are not satisfied, **When** the user taps **Next**, **Then** submission is blocked and unsatisfied rules remain highlighted in red.
5. **Given** the user taps the eye icon, **When** toggled, **Then** the password text alternates between masked (••••••) and plain text display.
6. **Given** the user taps **Contact Us**, **Then** the device's default mail client opens with the support email address pre-filled.

---

### User Story 4 – Terms & Agreements Acceptance (Priority: P4)

After password creation the user is presented with the "One final step!" screen containing a dynamically composed list of agreement checkboxes. The agreements shown depend on the user's account type (Just HSA, Just FSA, Just DCFSA, or Both HSA & FSA). All required checkboxes must be checked before the user can tap **Create Login**.

**Why this priority**: Legal acceptance of terms is required before account activation. The dynamic agreement list ensures users only see agreements relevant to their benefit plan.

**Independent Test**: Can be tested independently by rendering the Read & Agree screen for each of the four account-type variants, verifying the correct subset of checkboxes is displayed, and confirming "Create Login" remains disabled until all boxes are checked.

**Acceptance Scenarios**:

1. **Given** the user arrives on the Terms & Agreements screen, **When** the screen loads, **Then** the title "One final step!" and subtitle "By clicking Create Login, you agree to, and have read:" are displayed.
2. **Given** the account type is HSA-only, **When** the screen renders, **Then** three checkboxes are shown: E-SIGN Consent Disclosure, Privacy Policy and User Agreement, Coastal Community Bank Privacy Policy and HSA Agreement.
3. **Given** the account type is FSA-only, **When** the screen renders, **Then** three checkboxes are shown: Privacy Policy and User Agreement, Coastal Community Bank Privacy Policy and Cardholder Agreement, and the FSA card-usage certification statement.
4. **Given** the account type is DCFSA-only, **When** the screen renders, **Then** two checkboxes are shown: Privacy Policy and User Agreement, Coastal Community Bank Privacy Policy.
5. **Given** the account type is Both HSA & FSA, **When** the screen renders, **Then** four checkboxes are shown: E-SIGN Consent Disclosure, Privacy Policy and User Agreement, Coastal Community Bank Privacy Policy and HSA Agreement, and the FSA card-usage certification statement.
6. **Given** all required checkboxes are checked, **When** the user taps **Create Login**, **Then** a full-screen loading overlay with a spinner is displayed, the account creation API is called, and on success the overlay is dismissed and the user advances to the post-signup steps.
7. **Given** at least one required checkbox is unchecked, **When** the user taps **Create Login**, **Then** submission is blocked.

---

### User Story 5 – Post-Signup Optional Setup (Priority: P5)

After account creation the user sees a "Login created successfully!" confirmation and is then guided through two optional setup steps:
1. **Notifications** – "Would it be ok if we send notifications?" with **Agree to Notifications** or **Skip This Step**.
2. **Biometric Login** – "Do you want to use Face ID / Touch ID to log into InComm Benefits?" with **Set Up Face ID Login** (or Touch ID) or **Skip This Step**.

The biometric prompt adapts to the device capability (Face ID or Touch ID).

**Why this priority**: These steps improve retention and convenience but are optional; the core signup is complete without them.

**Independent Test**: Can be tested by simulating a post-creation state and verifying that both prompts appear in sequence, that "Skip This Step" on either prompt advances correctly, and that the biometric prompt shows the correct option per device capability.

**Acceptance Scenarios**:

1. **Given** account creation succeeds, **When** the user is redirected, **Then** a "Login created successfully!" confirmation is briefly displayed before the notifications prompt.
2. **Given** the notifications prompt is displayed, **When** the user taps **Agree to Notifications**, **Then** the system requests push notification permission and advances to the biometric prompt.
3. **Given** the notifications prompt is displayed, **When** the user taps **Skip This Step**, **Then** the app advances to the biometric prompt without requesting notification permission.
4. **Given** the device supports Face ID, **When** the biometric prompt displays, **Then** the prompt reads "Do you want to use Face ID to log into InComm Benefits?" with a **Set Up Face ID Login** button.
5. **Given** the device supports Touch ID instead, **When** the biometric prompt displays, **Then** the prompt reads "Do you want to use Touch ID to log into InComm Benefits?" with a **Set Up Touch ID Login** button.
6. **Given** the biometric prompt is displayed, **When** the user taps **Skip This Step**, **Then** the signup flow completes and the user is taken to the main app experience.

---

### Edge Cases

- What happens when the account lookup returns "Account not ready"? → A callout banner is displayed on the Personal Information screen with the message "Your account is not ready. Your account start date is {start_date_from_server}. Please check back on or after this date." (the start date is a dynamic value returned by the server, e.g. 01/01/2025). The form remains visible but the user cannot proceed until the start date is reached.
- What happens when the lookup finds an existing account (duplicate)? → A callout banner is displayed: "It looks like you already have an account." with a **Go to Login** button that pops the entire signup navigation stack and routes the user to the Login screen.
- What happens when the lookup cannot locate an HSA for the user? → A callout banner is displayed: "We were unable to locate an HSA for you. Please contact us for assistance." with a Contact Us action button.
- What happens when the OTP entered is invalid? → An error callout banner appears on the Verify Identity screen: "The code you entered is invalid. Please try again." No navigation occurs.
- What happens when internet connectivity is lost mid-flow? → The app detects the disconnection before any API call and shows a connectivity error, preventing partial state submission.
- What happens when the user presses Back from the Personal Information screen? → The user is returned to the Welcome screen.
- What happens when the user presses Back from the Verify Identity screen? → The user is returned to the Personal Information screen.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The app MUST display a Welcome screen ("Welcome to InComm Benefits!") with a **Sign Up** primary CTA and an **Already registered? Log In** secondary link for users who have no authenticated session.
- **FR-002**: The Personal Information screen MUST collect three fields: Last 4 digits of Social Security Number (numeric, exactly 4 digits), Date of Birth (via date-picker with calendar icon, formatted MM/DD/YYYY), and Work Email (standard email format).
- **FR-003**: The system MUST validate internet connectivity before submitting the Personal Information form and present a connectivity error if offline.
- **FR-004**: On successful account lookup, the system MUST send a 6-digit one-time passcode to the user's work email and navigate to the Verify Identity screen.
- **FR-005**: The Verify Identity screen MUST display the employer name and the masked destination email for the security code.
- **FR-006**: The system MUST validate the submitted 6-digit code against the server-issued OTP and display a specific error callout when the code is invalid.
- **FR-007**: The system MUST provide a **Resend** action on the Verify Identity screen that triggers a new OTP dispatch. After tapping Resend, the button MUST be disabled client-side for 60 seconds and display a visible countdown timer; it re-enables automatically when the timer reaches zero.
- **FR-008**: The Create Password screen MUST display the user's work email in a non-editable (read-only) field.
- **FR-009**: The password input MUST include a show/hide toggle (eye icon) that switches the field between masked and plain-text display.
- **FR-010**: The Create Password screen MUST perform real-time validation against four rules as the user types: (1) at least one capital letter, (2) at least one lowercase letter, (3) at least one number, (4) minimum 8 characters. Each rule MUST be accompanied by a visual indicator that turns green when satisfied and red when not.
- **FR-011**: The **Next** button on the Create Password screen MUST be blocked from submitting until all four password rules are satisfied.
- **FR-012**: The Terms & Agreements screen MUST dynamically display the correct set of agreement checkboxes based on the user's benefit account type (HSA-only, FSA-only, DCFSA-only, or Both HSA & FSA).
- **FR-013**: The **Create Login** button on the Terms & Agreements screen MUST be disabled until every displayed checkbox is checked.
- **FR-014**: After successful account creation, the system MUST display a "Login created successfully!" confirmation before presenting further setup prompts.
- **FR-015**: The Notifications prompt MUST offer **Agree to Notifications** and **Skip This Step** actions. Agreeing MUST trigger the OS-level push notification permission request.
- **FR-016**: The Biometric Login prompt MUST adapt to device capability, displaying Face ID or Touch ID options accordingly, with a **Skip This Step** fallback.
- **FR-017**: All error states from the server (account not ready, duplicate account, HSA not found, invalid OTP) MUST be surfaced as styled inline callout banners — not modal dialogs — on the relevant screens.
- **FR-018**: The **Contact Us** action MUST be accessible from the Personal Information, Verify Identity, Create Password, and Terms & Agreements screens. Tapping it MUST open the device's default mail client with the support email address pre-filled; the address MUST be stored as an app configuration constant (not hardcoded inline).
- **FR-019**: Navigation MUST use push/pop via UINavigationController. Back buttons MUST pop to the previous screen in the stack; no new VC instances should be created for back-navigation.
- **FR-020**: All screen layouts MUST use Storyboard or XIB with Size Classes for adaptive layout across iPhone and iPad screen sizes.
- **FR-021**: During every async API call (account lookup, OTP verification, account creation), the app MUST display a full-screen semi-transparent overlay with a centred activity indicator. The overlay MUST block all user interaction and MUST be dismissed — on both success and failure — before any navigation or error state is presented.

### Key Entities

- **SignupSession**: Holds transient **in-memory-only** state captured during the multi-step signup flow — SSN last 4, date of birth, work email, verified OTP status, created password (never persisted to disk or Keychain), accepted terms flags, biometric setup preference. If the user force-quits or the OS terminates the app, this state is discarded and the user must restart from the Welcome screen.
- **AccountLookupResult**: The server response to the personal information submission — includes account status (found / not ready / duplicate / HSA not found), employer name, masked email for OTP delivery, and benefit account type (HSA / FSA / DCFSA / both).
- **OTPVerification**: Tracks the current OTP session — issuance timestamp, expiry, validation status, and client-side resend cooldown state (last resend timestamp, used to drive the 60-second countdown UI).
- **TermsSet**: The set of legal agreement documents to present, determined server-side based on the user's benefit account type; each item has an identifier, display text, and link to full document.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A new user with a valid employer account can complete the full signup flow — from Welcome screen to post-signup biometric prompt — in under 5 minutes under typical conditions.
- **SC-002**: 95% of users who reach the Create Password screen complete it successfully on the first attempt, as measured by password-rule validation pass rates.
- **SC-003**: The OTP entry error rate (invalid code submissions) is below 10% in production, indicating the code delivery and UX are clear enough for most users.
- **SC-004**: All four error states (account not ready, duplicate, HSA not found, invalid OTP) are surfaced to users without the app crashing or entering an unrecoverable state, verified by 100% scenario coverage in QA.
- **SC-005**: The Terms & Agreements screen renders the correct agreement set for each of the four account types with zero mismatches, verified by automated or manual testing of all four variants.
- **SC-006**: Screen transitions are smooth (no visible lag) across both the smallest supported iPhone and iPad devices, per visual QA sign-off.

## Assumptions

- Internet connectivity is required throughout the signup flow; offline usage is not supported and will surface a connectivity error.
- Signup session state is held entirely in memory. Force-quitting the app, backgrounding it, or OS termination discards all state — the user must restart from the Welcome screen. No partial state is written to disk, Keychain, or any persistent store during signup.
- A backend API already exists for account lookup, OTP dispatch/validation, password creation, and terms acceptance; this feature covers only the iOS client implementation.
- The benefit account type (HSA / FSA / DCFSA / both) is returned by the server as part of the account-lookup response and determines which agreements are shown.
- OTP codes expire after a standard industry-appropriate window (assumed 10 minutes); the server handles expiry enforcement.
- The "Contact Us" action opens the device's default mail client with a pre-configured support email address pre-filled; this address is stored as an app configuration constant. No phone-dialer or WebView behaviour is required.
- Biometric authentication integration (Face ID / Touch ID) uses the device's LocalAuthentication framework; the prompt type is determined at runtime based on device capability.
- All screen text, button labels, and error messages shown in the Figma are final copy; no further content changes are expected during implementation.
- The duplicate-account error callout CTA button is labelled **Go to Login** and pops the signup stack to route the user to the Login screen.
