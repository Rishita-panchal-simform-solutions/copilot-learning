# API Contracts: InComm Benefits Signup Flow

**Feature**: 003-incomm-signup-flow  
**Date**: 2026-04-08  
**Scope**: iOS client → Backend API  
**Base URL**: `AppSecrets.baseURL` (environment-specific; set via Arkana)  
**Auth**: Pre-authentication endpoints — use `NetworkHelper.httpPreTokenHeader` (`Content-Type: application/json`; no `Authorization` header)

---

## C-001: Account Lookup

**Purpose**: Verify the user's identity using SSN last-4, date of birth, and work email. Returns account status, employer name, masked email, and benefit type.

**`APITarget` case**: `.signupLookup(request: AccountLookupRequest)`

```
POST /signup/lookup
```

**Request body**:
```json
{
  "ssn_last4": "1234",
  "date_of_birth": "12/08/1985",
  "work_email": "jsmith@worklife.com"
}
```

**Success response** (`200 OK`):
```json
{
  "status": true,
  "status_code": 200,
  "message": "Account found",
  "result": {
    "account_status": "FOUND",
    "employer_name": "WorkInTeck",
    "masked_email": "js***@work.com",
    "benefit_account_type": "HSA_FSA"
  }
}
```

**Error response variants** (`200 OK`, `status: false`):
```json
// Account not yet open
{
  "status": false,
  "status_code": 200,
  "message": "Account not ready",
  "result": {
    "account_status": "NOT_READY",
    "account_start_date": "01/01/2025"
  }
}

// Duplicate account
{
  "status": false,
  "status_code": 200,
  "message": "Account already exists",
  "result": {
    "account_status": "DUPLICATE"
  }
}

// HSA not found
{
  "status": false,
  "status_code": 200,
  "message": "HSA not found",
  "result": {
    "account_status": "HSA_NOT_FOUND"
  }
}
```

**Client handling**:
- `FOUND` → navigate to Verify Identity screen
- `NOT_READY` → display "Account not ready" callout with `account_start_date`
- `DUPLICATE` → display "Already have an account" callout with "Go to Login" CTA (pops signup stack)
- `HSA_NOT_FOUND` → display "Unable to locate HSA" callout with Contact Us action

---

## C-002: Resend OTP

**Purpose**: Request a new 6-digit security code to be sent to the user's work email.

**`APITarget` case**: `.signupResendOTP(request: ResendOTPRequest)`

```
POST /signup/resend-otp
```

**Request body**:
```json
{
  "work_email": "jsmith@worklife.com"
}
```

**Success response** (`200 OK`):
```json
{
  "status": true,
  "status_code": 200,
  "message": "OTP sent",
  "result": null
}
```

**Client handling**:
- On success: start 60-second client-side resend cooldown
- On failure: show SwiftMessages snackbar with error message; do not start cooldown

---

## C-003: Verify OTP

**Purpose**: Validate the 6-digit code entered by the user.

**`APITarget` case**: `.signupVerifyOTP(request: OTPVerificationRequest)`

```
POST /signup/verify-otp
```

**Request body**:
```json
{
  "work_email": "jsmith@worklife.com",
  "otp_code": "123456"
}
```

**Success response** (`200 OK`):
```json
{
  "status": true,
  "status_code": 200,
  "message": "OTP verified",
  "result": {
    "verified": true
  }
}
```

**Error response** (`200 OK`, `status: false`):
```json
{
  "status": false,
  "status_code": 200,
  "message": "Invalid OTP",
  "result": {
    "verified": false
  }
}
```

**Client handling**:
- `verified: true` → navigate to Create Password screen; dismiss loading overlay
- `verified: false` → display "Invalid code" error callout; keep user on Verify Identity screen

---

## C-004: Create Password

**Purpose**: Submit the user's chosen password after OTP verification.

**`APITarget` case**: `.signupCreatePassword(request: CreatePasswordRequest)`

```
POST /signup/create-password
```

**Request body**:
```json
{
  "work_email": "jsmith@worklife.com",
  "password": "SecurePass1"
}
```

**Success response** (`200 OK`):
```json
{
  "status": true,
  "status_code": 200,
  "message": "Password set",
  "result": {
    "user_id": "usr_abc123"
  }
}
```

**Client handling**:
- On success: store `user_id` in `SignupSession`; navigate to Terms & Agreements screen
- On failure: show error callout with server `message`

---

## C-005: Accept Terms

**Purpose**: Submit the user's acceptance of all required agreement documents to complete account creation.

**`APITarget` case**: `.signupAcceptTerms(request: TermsAcceptanceRequest)`

```
POST /signup/accept-terms
```

**Request body**:
```json
{
  "user_id": "usr_abc123",
  "accepted_terms": ["ESIGN", "PRIVACY_POLICY", "HSA_AGREEMENT", "FSA_CERTIFICATION"]
}
```

**Success response** (`200 OK`):
```json
{
  "status": true,
  "status_code": 200,
  "message": "Account created",
  "result": {
    "account_created": true
  }
}
```

**Client handling**:
- On success: clear `SignupSession`; navigate to Notifications prompt
- On failure: show error callout with server `message`; remain on Terms screen

---

## Notes

- All endpoints use `POST` with JSON body.
- All responses follow the project's `BaseResponseModel<T>` envelope: `{ status, status_code, message, result }`.
- Key decoding strategy: `.convertFromSnakeCase` (already default in `APITarget`).
- `#warning("Replace endpoint paths with actual server paths when backend is confirmed")` should be left as a reminder comment in `APITarget.swift` during implementation.
