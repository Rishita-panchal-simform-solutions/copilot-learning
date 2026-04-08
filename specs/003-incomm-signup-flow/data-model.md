# Data Model: InComm Benefits Signup Flow

**Feature**: 003-incomm-signup-flow  
**Date**: 2026-04-08

---

## Entities

### 1. `SignupSession` (in-memory only)

Holds all transient state collected across the multi-step signup flow. **Never persisted** — discarded when the app is force-quit or backgrounded.

| Field | Type | Description | Validation |
|-------|------|-------------|------------|
| `ssnLast4` | `String` | Last 4 digits of SSN | Exactly 4 numeric characters |
| `dateOfBirth` | `Date` | User date of birth | Must be in the past; formatted `MM/dd/yyyy` for API |
| `workEmail` | `String` | Work email address | Standard email format (RFC 5322) |
| `employerName` | `String?` | Returned from server after account lookup | Read-only; nil until lookup succeeds |
| `maskedEmail` | `String?` | Masked email shown on Verify Identity screen | Read-only; nil until lookup succeeds |
| `benefitAccountType` | `BenefitAccountType` | HSA / FSA / DCFSA / both — determines terms set | Set from server response |
| `otpValidated` | `Bool` | Whether the OTP step has been passed | Default `false` |
| `password` | `String` | New password (never written to disk) | Must satisfy all 4 password rules |
| `acceptedTerms` | `[String]` | Identifiers of accepted agreement documents | All required items must be present |
| `notificationsEnabled` | `Bool?` | User choice on notifications prompt | `nil` = not yet answered |
| `biometricSetup` | `Bool?` | User choice on biometric prompt | `nil` = not yet answered |

**State transitions**:
```
LOOKUP_PENDING → LOOKUP_SUCCESS | LOOKUP_ERROR
LOOKUP_SUCCESS → OTP_PENDING
OTP_PENDING → OTP_VERIFIED | OTP_ERROR
OTP_VERIFIED → PASSWORD_PENDING
PASSWORD_PENDING → TERMS_PENDING
TERMS_PENDING → ACCOUNT_CREATED
ACCOUNT_CREATED → NOTIFICATIONS_PENDING → BIOMETRIC_PENDING → COMPLETE
```

---

### 2. `BenefitAccountType` (enum)

Determines the agreement set on the Terms & Agreements screen.

```swift
enum BenefitAccountType: String, Codable {
    case hsaOnly   = "HSA"
    case fsaOnly   = "FSA"
    case dcfsaOnly = "DCFSA"
    case hsaAndFsa = "HSA_FSA"
}
```

---

### 3. `AccountLookupRequest` (request model)

Sent to the account-lookup endpoint on Personal Information submit.

| Field | Type | API Key |
|-------|------|---------|
| `ssnLast4` | `String` | `ssn_last4` |
| `dateOfBirth` | `String` | `date_of_birth` (MM/dd/yyyy) |
| `workEmail` | `String` | `work_email` |

---

### 4. `AccountLookupResponse` (response model)

Wrapped in `BaseResponseModel<AccountLookupResponse>`.

| Field | Type | Description |
|-------|------|-------------|
| `accountStatus` | `AccountStatus` | `found` / `notReady` / `duplicate` / `hsaNotFound` |
| `employerName` | `String?` | Employer name shown on Verify Identity screen |
| `maskedEmail` | `String?` | Masked destination email for OTP |
| `accountStartDate` | `String?` | ISO date; populated when `accountStatus == .notReady` |
| `benefitAccountType` | `BenefitAccountType?` | Populated when `accountStatus == .found` |

```swift
enum AccountStatus: String, Codable {
    case found       = "FOUND"
    case notReady    = "NOT_READY"
    case duplicate   = "DUPLICATE"
    case hsaNotFound = "HSA_NOT_FOUND"
}
```

---

### 5. `OTPVerificationRequest` (request model)

| Field | Type | API Key |
|-------|------|---------|
| `workEmail` | `String` | `work_email` |
| `code` | `String` | `otp_code` (6 digits) |

---

### 6. `OTPVerificationResponse` (response model)

Wrapped in `BaseResponseModel<OTPVerificationResponse>`.

| Field | Type | Description |
|-------|------|-------------|
| `verified` | `Bool` | `true` if code was valid and not expired |

---

### 7. `ResendOTPRequest` (request model)

| Field | Type | API Key |
|-------|------|---------|
| `workEmail` | `String` | `work_email` |

No distinct response body needed — server returns `BaseResponseModel` with `status: true` on success.

---

### 8. `CreatePasswordRequest` (request model)

| Field | Type | API Key |
|-------|------|---------|
| `workEmail` | `String` | `work_email` |
| `password` | `String` | `password` |

---

### 9. `CreatePasswordResponse` (response model)

Wrapped in `BaseResponseModel<CreatePasswordResponse>`.

| Field | Type | Description |
|-------|------|-------------|
| `userId` | `String` | Server-assigned user ID (for terms acceptance call) |

---

### 10. `TermsAcceptanceRequest` (request model)

| Field | Type | API Key |
|-------|------|---------|
| `userId` | `String` | `user_id` |
| `acceptedTerms` | `[String]` | `accepted_terms` (array of agreement document IDs) |

---

### 11. `TermsAcceptanceResponse` (response model)

Wrapped in `BaseResponseModel<TermsAcceptanceResponse>`.

| Field | Type | Description |
|-------|------|-------------|
| `accountCreated` | `Bool` | `true` if account activated successfully |

---

### 12. `TermsItem` (display model — not sent to server)

Describes one agreement checkbox shown on the Terms & Agreements screen.

| Field | Type | Description |
|-------|------|-------------|
| `id` | `String` | Stable identifier (e.g. `"ESIGN"`, `"PRIVACY_POLICY"`, `"HSA_AGREEMENT"`) |
| `displayText` | `String` | Full label shown next to checkbox |
| `documentURL` | `URL?` | Optional link to full document (future use) |

**Agreement set per account type:**

| Item | HSA-only | FSA-only | DCFSA-only | Both |
|------|----------|----------|------------|------|
| E-SIGN Consent Disclosure | ✅ | ❌ | ❌ | ✅ |
| Privacy Policy & User Agreement | ✅ | ✅ | ✅ | ✅ |
| Coastal Community Bank HSA Agreement | ✅ | ❌ | ❌ | ✅ |
| Coastal Community Bank Cardholder Agreement (FSA) | ❌ | ✅ | ❌ | ❌ |
| Coastal Community Bank Privacy Policy (DCFSA) | ❌ | ❌ | ✅ | ❌ |
| FSA Card-Usage Certification | ❌ | ✅ | ❌ | ✅ |

---

### 13. `PasswordValidationState` (computed — not sent to server)

| Field | Type | Rule |
|-------|------|------|
| `hasUppercase` | `Bool` | At least one `[A-Z]` character |
| `hasLowercase` | `Bool` | At least one `[a-z]` character |
| `hasNumber` | `Bool` | At least one `[0-9]` character |
| `hasMinLength` | `Bool` | `password.count >= 8` |
| `allSatisfied` | `Bool` | All four above are `true` |

---

### 14. `OTPCountdownState` (in-ViewModel — not sent to server)

| Field | Type | Description |
|-------|------|-------------|
| `resendCooldownSeconds` | `Int` | Counts down from 60 to 0; 0 = Resend enabled |
| `isResendEnabled` | `Bool` (computed) | `resendCooldownSeconds == 0` |
