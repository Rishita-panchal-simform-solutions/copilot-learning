---
name: app-store-submission
description: Deep-reference skill for App Store submission — covers anti-patterns with rejection causes,privacy manifest requirements, Sign in with Apple rules, metadata completeness, IAP review, encryption export compliance, screenshot requirements, App Store Connect upload workflow, and Accessibility Nutrition Labels. Use this skill when an iOS developer asks about specific App Store rejection guidelines, needs a detailed pre-flight checklist, wants to understand why a submission was rejected, or needs reference data for any phase of the App Store submission process. Complements app-store-submission (which handles interactive workflow) with authoritative reference content. Trigger for any query involving App Store guidelines, rejection reasons, privacy manifests, SIWA requirements, IAP rules, or ASC metadata fields.
license: MIT
metadata:
  version: "1.0.0"
---

# App Store Submission

## Overview

Systematic pre-flight checklist that catches 90% of App Store rejection causes before submission. **Core principle**: Ship once, ship right. Over 40% of App Store rejections cite Guideline 2.1 (App Completeness) — crashes, placeholders, broken links. Another 30% are metadata and privacy issues. A disciplined pre-flight process eliminates these preventable rejections.

**Key insight**: Apple rejected nearly 1.93 million submissions in 2024. Most rejections are not policy disagreements — they are checklist failures. A 30-minute pre-flight saves 3-7 days of rejection-fix-resubmit cycles.

## When to Use This Skill

✅ **Use this skill when**:
- Preparing to submit an app or update to the App Store
- Submitting your first app as a new developer
- Responding to an App Review rejection
- Running a pre-submission audit before TestFlight or production
- Updating an existing app after a long gap (new requirements may apply)
- Wondering "is my app ready to submit?"

❌ **Do NOT use this skill for**:
- Code signing and provisioning profiles (use build-debugging)
- CI/CD pipeline setup
- Performance optimization (use ios-performance)
- UI testing automation (use ui-testing)
- In-app purchase implementation (use storekit-ref)
- Privacy manifest details (use privacy-ux for deep implementation)

## Example Prompts

Real questions developers ask that this skill answers:

#### 1. "Is my app ready to submit to the App Store?"
> The skill provides a complete pre-flight checklist covering build, privacy, metadata, accounts, review info, content, and regional requirements

#### 2. "What do I need before submitting my first iOS app?"
> The skill walks through every requirement from scratch — privacy manifest, metadata fields, screenshots, demo credentials, age rating

#### 3. "I keep getting rejected, what am I missing?"
> The skill provides anti-patterns with specific rejection causes and the decision tree to identify gaps

#### 4. "What's the pre-submission checklist for App Store?"
> The skill provides a categorized mandatory checklist with every item that triggers rejection if missing

#### 5. "Do I need a privacy manifest?"
> Yes. Since May 2024, missing privacy manifests cause automatic rejection. The skill explains when and how.

#### 6. "My app update was rejected for metadata issues"
> The skill covers metadata completeness requirements and the common gaps that trigger Guideline 2.3 rejections

---

## Anti-Patterns

### 1. Submitting without device testing

**Time cost**: 3-7 days (rejection + fix + resubmit wait)

**Symptom**: Rejection for Guideline 2.1 — App Completeness. Crashes, broken flows, or missing functionality discovered by App Review.

❌ **BAD**: Test only in Simulator, submit when build succeeds
```
"It works in Simulator, ship it"
→ Rejection: App crashes on launch on iPhone 15 Pro (memory limit)
→ 3-7 day delay
```

✅ **GOOD**: Test on physical device with latest shipping OS, exercise all user flows
```bash
# Build for device
xcodebuild -scheme YourApp \
  -destination 'platform=iOS,name=Your iPhone'

# Test critical paths:
# - Launch → main screen loads
# - All tabs/screens accessible
# - Core user flows complete without crash
# - Edge cases: no network, low storage, interruptions
```

**Why it works**: Simulator hides real-device constraints — memory limits, cellular networking behavior, hardware-specific APIs, thermal throttling. App Review tests on physical devices.

---

### 2. Missing or inadequate privacy policy

**Time cost**: 2-5 days (rejection + policy creation + resubmit)

**Symptom**: Rejection for Guideline 5.1.1(i) — Data Collection and Storage. Privacy policy missing, inaccessible, or inconsistent with actual data practices.

❌ **BAD**: No privacy policy URL, or a generic template that doesn't match actual data collection
```
Privacy Policy URL: (empty)
— or —
Privacy Policy: "We respect your privacy" (generic, no specifics)
```

✅ **GOOD**: Privacy policy accessible in two places, specific to your app's data practices
```
1. App Store Connect → App Information → Privacy Policy URL
2. In-app → Settings/About screen → Privacy Policy link
3. Policy content lists:
   - All collected data types
   - How each type is used
   - Third-party sharing (who and why)
   - Data retention period
   - How to request deletion
```

**Three-way consistency**: Apple compares (a) your app's actual behavior, (b) your privacy policy content, and (c) your Privacy Nutrition Labels in ASC. All three must agree. If any of these three disagree, you get a 5.1.1 rejection. Check each SDK's documentation for its privacy manifest and data collection disclosure — your app's total data collection is your code PLUS all SDK data collection.

**Why it works**: Guideline 5.1.1(i) requires privacy policy accessible BOTH in ASC metadata AND within the app. The policy must specifically describe your app's data practices, not a generic template.

---

### 3. Placeholder content left in build

**Time cost**: 3-5 days (rejection + content replacement + resubmit)

**Symptom**: Rejection for Guideline 2.1 — App Completeness. Reviewers find placeholder text, empty screens, or TODO artifacts.

❌ **BAD**: Ship with development artifacts visible to users
```
- "Lorem ipsum" text in onboarding
- Empty tab that shows "Coming Soon"
- Button that opens alert "Not implemented yet"
- Default app icon (white grid)
```

✅ **GOOD**: Every screen has final content and production assets
```
Pre-submission content audit:
- [ ] Every screen has real content (no lorem ipsum)
- [ ] All images are final production assets
- [ ] No "Coming Soon" or "Under Construction" screens
- [ ] All buttons perform their intended action
- [ ] Default/empty states have proper messaging
- [ ] App icon is final and meets spec (1024x1024, no alpha)
```

**Why it works**: App Review tests every screen and tab, including states you might consider edge cases. They open every menu, tap every button, and switch every tab.

---

### 4. Ignoring privacy manifest

**Time cost**: 1-3 days (automatic rejection + manifest creation + resubmit)

**Symptom**: Automatic rejection before human review. Missing `PrivacyInfo.xcprivacy` or undeclared Required Reason APIs.

❌ **BAD**: No privacy manifest, or missing Required Reason API declarations
```
No PrivacyInfo.xcprivacy in project
— or —
Using UserDefaults, file timestamps, disk space APIs
without declaring approved reasons
```

✅ **GOOD**: Privacy manifest present with all Required Reason APIs declared
```
Project must contain:
├── PrivacyInfo.xcprivacy
│   ├── NSPrivacyTracking (true/false)
│   ├── NSPrivacyTrackingDomains (if tracking)
│   ├── NSPrivacyCollectedDataTypes (all types)
│   └── NSPrivacyAccessedAPITypes (all Required Reason APIs)
│
└── Third-party SDK manifests (each SDK includes its own)
```

Common Required Reason APIs that need declaration:
- `UserDefaults` → Reason `CA92.1`
- File timestamp APIs → Reason `C617.1`
- Disk space APIs → Reason `E174.1`
- System boot time → Reason `35F9.1`

**Why it works**: Since May 2024, this is an automated gate. No human reviewer involved — the build processing system rejects submissions missing required privacy declarations.

---

### 5. Missing Sign in with Apple

**Time cost**: 3-7 days (SIWA implementation + resubmit)

**Symptom**: Rejection for Guideline 4.8. App offers third-party login (Google, Facebook, email) but no Sign in with Apple option.

❌ **BAD**: Third-party login without SIWA
```swift
// Login screen offers:
// - Sign in with Google
// - Sign in with Facebook
// - Email/password
// ← Missing: Sign in with Apple
```

✅ **GOOD**: SIWA offered as equivalent option alongside any third-party login
```swift
// Login screen offers:
// - Sign in with Apple ← Required if others exist
// - Sign in with Google
// - Sign in with Facebook
// - Email/password
```

**Exceptions** (SIWA not required):
- Company-internal or employee-only apps
- Education apps using existing school accounts
- Government/tax/banking apps requiring government ID
- Apps that are a client for a specific third-party service
- Apps using only the company's own authentication system

**Why it works**: Guideline 4.8 requires SIWA as an option whenever ANY third-party or social login is offered. Apple enforces this strictly.

---

### 6. No account deletion flow

**Time cost**: 5-10 days (implementation + testing + resubmit)

**Symptom**: Rejection for Guideline 5.1.1(v). App allows account creation but provides no way to delete the account.

❌ **BAD**: Account creation without deletion capability
```
- Sign up button exists
- No "Delete Account" anywhere in app
- "Contact support to delete" (not sufficient)
- "Deactivate account" (not the same as delete)
```

✅ **GOOD**: Full account deletion flow accessible in-app
```
Account deletion requirements:
1. Discoverable in Settings/Profile (not hidden)
2. Clearly labeled "Delete Account" (not "Deactivate")
3. Explains what deletion means (data removed, timeline)
4. Confirms completion to user
5. If Sign in with Apple used → revoke SIWA token
6. If active subscriptions → inform user to cancel first
7. Deletion completes within reasonable timeframe (days, not months)
```

```swift
// Revoking Sign in with Apple token (required)
let appleIDProvider = ASAuthorizationAppleIDProvider()
let request = appleIDProvider.createRequest()

// After user confirms deletion:
// POST to Apple's revoke endpoint with the user's token
// Then delete server-side account data
```

**Why it works**: Required since June 2022. Must be actual deletion (not deactivation), must be in-app (not just email/website), and must revoke SIWA tokens if used. Apple tests this flow specifically.

---

### 7. Wrong age rating

**Time cost**: 2-4 days (re-answer questionnaire + possible content changes + resubmit)

**Symptom**: Rejection for Guideline 2.3.6 — Inaccurate metadata. Age rating doesn't reflect actual app content or capabilities.

❌ **BAD**: Understate content to get lower rating
```
App has user-generated content (chat, posts)
but age rating questionnaire answered "No UGC"

App has cartoon violence in gameplay
but answered "No violence"
```

✅ **GOOD**: Answer age rating questionnaire accurately
```
Declare honestly:
- User-generated content (chat, forums, social features)
- Violence (even cartoon/fantasy)
- Mature themes
- Profanity / crude humor
- Gambling (simulated or real)
- Horror / fear themes
- Medical / treatment information
- Unrestricted web access (WebView with open URLs)
```

**New age ratings (January 31, 2026)**: Apple expanded from 4+/9+/12+/17+ to 5 tiers (4+/9+/13+/16+/18+) with new capability declarations for messaging, UGC, advertising, and parental controls. All developers must complete the updated questionnaire or app updates will be blocked.

**Why it works**: Mismatched ratings violate Guideline 2.3.6. Apple compares your questionnaire answers against observed app behavior. UGC and web access are the most commonly missed declarations.

---

### 8. Missing demo credentials

**Time cost**: 3-5 days (rejection + credential creation + resubmit wait)

**Symptom**: Rejection for Guideline 2.1. Reviewer unable to test app because login is required and no test account was provided.

❌ **BAD**: App requires login, but no demo account in review notes
```
App Review Information:
  Notes: (empty)
  Demo Account: (empty)
  Demo Password: (empty)
→ Reviewer sees login screen, can't proceed, rejects
```

✅ **GOOD**: Working demo credentials with clear instructions
```
App Review Information:
  Demo Account: demo@yourapp.com
  Demo Password: AppReview2025!
  Notes: "Log in with the demo account above.
         The account has sample data pre-loaded.
         To test [feature X], navigate to Tab 2 > Settings.
         If 2FA is required, use code: 123456"

Requirements:
- Account must not expire during review (1-2 weeks minimum)
- Account must have representative data
- Include any special setup steps
- If hardware required, explain workarounds
- If location-specific, provide test coordinates
```

**Why it works**: Reviewers cannot test what they cannot access. They will not create their own account. If your app requires any form of authentication, demo credentials are mandatory. This is one of the most common rejection reasons for apps with login flows.

---

## Decision Tree

```
Is my app ready to submit?
│
├─ Does it crash on a real device?
│  ├─ YES → STOP. Fix crashes first (Guideline 2.1)
│  └─ NO → Continue
│
├─ Privacy manifest (PrivacyInfo.xcprivacy) present?
│  ├─ NO → Add privacy manifest with Required Reason APIs
│  └─ YES → Continue
│
├─ Privacy policy URL set in App Store Connect?
│  ├─ NO → Add privacy policy URL in ASC
│  └─ YES → Is it also accessible in-app?
│     ├─ NO → Add in-app privacy policy link
│     └─ YES → Continue
│
├─ All screenshots final and matching current app?
│  ├─ NO → Update screenshots for all required device sizes
│  └─ YES → Continue
│
├─ Does app create user accounts?
│  ├─ YES → Account deletion implemented and discoverable?
│  │  ├─ NO → Implement account deletion flow
│  │  └─ YES → Continue
│  └─ NO → Continue
│
├─ Does app offer third-party login (Google, Facebook, etc.)?
│  ├─ YES → Sign in with Apple offered?
│  │  ├─ NO → Add SIWA (unless exemption applies)
│  │  └─ YES → Continue
│  └─ NO → Continue
│
├─ Does app have in-app purchases or subscriptions?
│  ├─ YES → IAP items submitted for review in ASC?
│  │  ├─ NO → Submit IAP for review (can be reviewed separately)
│  │  └─ YES → Restore Purchases button implemented?
│  │     ├─ NO → Add Restore Purchases functionality
│  │     └─ YES → Continue
│  └─ NO → Continue
│
├─ Does app use encryption beyond standard HTTPS?
│  ├─ YES → Export compliance documentation uploaded?
│  │  ├─ NO → Add ITSAppUsesNonExemptEncryption to Info.plist
│  │  │       and upload compliance documentation
│  │  └─ YES → Continue
│  └─ NO → Set ITSAppUsesNonExemptEncryption = NO in Info.plist
│
├─ Distributing in EU?
│  ├─ YES → DSA trader status verified in ASC?
│  │  ├─ NO → Complete trader verification in ASC
│  │  └─ YES → Continue
│  └─ NO → Continue
│
├─ Does app require login to function?
│  ├─ YES → Demo credentials in App Review notes?
│  │  ├─ NO → Add working demo account + password + instructions
│  │  └─ YES → Continue
│  └─ NO → Continue
│
├─ Age rating questionnaire completed honestly?
│  ├─ NO → Complete updated questionnaire (new 13+/16+/18+ ratings)
│  └─ YES → Continue
│
├─ Any placeholder content remaining?
│  ├─ YES → Replace all placeholders with final content
│  └─ NO → Continue
│
└─ All checks passed → READY TO SUBMIT
```

---

## Mandatory Pre-Flight Checklist

Run this entire checklist before every submission. Check every item, not just the ones you think apply.

### 1. Build Configuration

- [ ] Built with current required SDK (iOS 18 SDK / Xcode 16 as of 2025; iOS 26 SDK / Xcode 26 required starting April 28, 2026)
- [ ] `ITSAppUsesNonExemptEncryption` set in Info.plist (`NO` if only HTTPS)
- [ ] App tested on physical device with latest shipping iOS version
- [ ] App works over IPv6-only network (Apple review network is IPv6)
- [ ] No private/undocumented API usage
- [ ] No references to pre-release/beta OS features unless targeting that OS
- [ ] Minimum deployment target is reasonable (not unnecessarily high)
- [ ] Release build tested (not just Debug configuration)

### 2. Privacy

- [ ] `PrivacyInfo.xcprivacy` file present in app target
- [ ] All Required Reason APIs declared with approved reason codes
- [ ] Third-party SDKs each include their own privacy manifests
- [ ] Privacy policy URL set in App Store Connect
- [ ] Privacy policy accessible in-app (Settings/About screen)
- [ ] Privacy policy content matches actual data collection practices
- [ ] All `NS*UsageDescription` purpose strings present (Camera, Location, etc.)
- [ ] Purpose strings explain user benefit (not just "we need access")
- [ ] App Tracking Transparency implemented if tracking users (ATT)
- [ ] Privacy Nutrition Labels completed in ASC matching manifest

### 3. Metadata

- [ ] App name (30 character limit, no keyword stuffing)
- [ ] Subtitle (30 character limit)
- [ ] Description (accurate, no misleading claims)
- [ ] Keywords (100 character limit, comma-separated)
- [ ] Category and secondary category set
- [ ] Screenshots for all required device sizes (6.9", 6.7", 6.5", 5.5" for iPhone; 13" for iPad if universal)
- [ ] Screenshots reflect current app UI (not outdated)
- [ ] App Preview videos current (if using)
- [ ] Support URL valid and accessible
- [ ] Marketing URL valid (if set)
- [ ] Copyright string current year
- [ ] Version number and build number incremented
- [ ] "What's New" text written (for updates)

---

## Interactive Metadata Preparation

When the user wants to prepare or review their App Store metadata, run this interactive flow. Ask questions one field group at a time. Never dump all questions at once.

### How to Start

When the user says anything like "help me fill in metadata", "prepare my App Store listing", "what do I put in the metadata fields", or "my metadata was rejected" — begin the flow immediately:

> "Let's build your App Store metadata together. I'll ask you about each field, check your answers against Apple's rules, and show you the result as a table with exactly why Apple requires each item. Ready? Let's start with the basics."

Then proceed field group by field group. After completing each group, show a results table and ask:

> "Here's what we have so far. Want to make any changes, or shall we move on to [next group]?"

Do NOT move to the next group until the user confirms.

---

### Group 1 — App Identity

Ask the user:
1. "What is your **app name**? (Apple allows max 30 characters — this appears under your icon on the App Store)"
2. "Do you have a **subtitle**? This is a short line under your app name — also 30 characters max. It's optional but great for keywords."
3. "What **category** best fits your app? (e.g., Productivity, Health & Fitness, Education, Games, Finance...)"
4. "Is there a **secondary category** that applies?"

After collecting answers, validate:
- App name: count characters, flag if > 30, flag keyword stuffing (repeated words, competitor names, "best", "free", "#1")
- Subtitle: count characters, flag if > 30
- Warn if app name + subtitle have duplicate keywords

Then show the Group 1 results table:

| Field | Your Value | Char Count | Status | Why Apple Requires This |
|-------|-----------|------------|--------|------------------------|
| App Name | [value] | [N]/30 | ✅/⚠️ | Appears under your icon; limited to 30 chars to keep listings clean. Keyword stuffing violates Guideline 2.3.1 and causes rejection. |
| Subtitle | [value or Not set] | [N]/30 | ✅/⚠️ | Secondary discovery surface; indexed for search. Optional but strongly recommended. Same 30-char rule applies. |
| Primary Category | [value] | — | ✅/⚠️ | Determines where your app appears in App Store Browse. Wrong category = harder to discover + potential 2.3 flag. |
| Secondary Category | [value or None] | — | ✅/⚠️ | Optional second browse placement. Pick only if genuinely applicable — misuse triggers Guideline 2.3. |

---

### Group 2 — Description & Keywords

Ask the user:
1. "Tell me about your app in a few sentences — what does it do and who is it for? I'll help you write the **description** from this."
2. "What are the **top 3 features** you want to highlight?"
3. "Who is your **target audience**?"
4. "Do you have **keywords** in mind? List any terms users might search for to find your app."

After collecting:
- Write a suggested description (lead with user benefit, not feature list; max 4000 chars; first 3 lines are critical — they show without "More")
- Generate keywords string: comma-separated, no spaces after commas, no repetition of app name, max 100 chars total
- Flag: no competitor app names in keywords (causes rejection), no trademarked terms you don't own

Show Group 2 results table:

| Field | Your Value / Suggestion | Char Count | Status | Why Apple Requires This |
|-------|------------------------|------------|--------|------------------------|
| Description | [first 100 chars of suggestion...] | [N]/4000 | ✅/⚠️ | Shown on your App Store product page. Must accurately describe the app — misleading descriptions violate Guideline 2.3. First 3 lines show without tapping "More". |
| Keywords | [generated keyword string] | [N]/100 | ✅/⚠️ | Used by App Store search algorithm. Not shown publicly. Competitor names, trademarked terms, or app name repetition cause rejection under Guideline 2.3. |

---

### Group 3 — URLs & Legal

Ask the user:
1. "What is your **Support URL**? (Must be a live webpage — Apple reviewers visit this)"
2. "Do you have a **Privacy Policy URL**? (Required for all apps — must describe your actual data practices)"
3. "Do you have a **Marketing URL**? (Optional — your app's website or landing page)"
4. "What is your **copyright string**? (Usually: © 2026 [Your Company Name])"

After collecting:
- Flag if Support URL or Privacy Policy URL is missing — both are required
- Flag if Privacy Policy URL points to a generic template domain (e.g., privacypolicygenerator.com without customization — Apple checks content)
- Flag if copyright year is not current

Show Group 3 results table:

| Field | Your Value | Status | Why Apple Requires This |
|-------|-----------|--------|------------------------|
| Support URL | [value] | ✅/⚠️ | Reviewers visit this to understand the app and contact you. Must be live and reachable. Missing = Guideline 2.3 rejection. |
| Privacy Policy URL | [value] | ✅/⚠️ | Required for ALL apps since 2018. Must be live, specific to your app's data practices, and match your Privacy Nutrition Labels. Missing = Guideline 5.1.1(i) rejection. |
| Marketing URL | [value or Not set] | ✅ | Optional. Links to your app's website from the App Store page. |
| Copyright | [value] | ✅/⚠️ | Displayed on your App Store listing. Must be current year + rights holder. Stale copyright can flag metadata review. |

---

### Group 4 — Version Info & Release Notes

Ask the user:
1. "What **version number** is this? (e.g., 2.1.0)"
2. "Is this a **new app** or an **update** to an existing app?"
3. If update: "What changed in this version? Give me bullet points and I'll write your **What's New** text."
4. "What **build number** will you use? (Must be strictly higher than any previously uploaded build)"

After collecting:
- For What's New: write it clearly and specifically (users read this; vague "bug fixes" annoys users and can draw reviewer scrutiny)
- Flag if build number looks the same as a previous upload

Show Group 4 results table:

| Field | Your Value | Status | Why Apple Requires This |
|-------|-----------|--------|------------------------|
| Version Number | [value] | ✅/⚠️ | Shown publicly on App Store. Must follow SemVer convention. Cannot be lower than the currently live version. |
| Build Number | [value] | ✅/⚠️ | Internal identifier. Must be strictly higher than ANY previously uploaded build for this app, including TestFlight builds. Duplicate = upload rejected. |
| What's New | [first 100 chars...] | ✅/⚠️ | Shown to existing users deciding whether to update. Must be accurate — misleading release notes violate Guideline 2.3. Max 4000 chars. |

---

### Group 5 — Age Rating & Review Info

Ask the user:
1. "Does your app have any of these? (answer yes/no for each):
   - User-generated content (chat, posts, comments)
   - Violence (even cartoon)
   - Mature or suggestive content
   - Gambling or simulated gambling
   - Unrestricted web browsing (WebView with open URLs)
   - Alcohol, tobacco, or drug references"
2. "Does your app **require login** to function?"
3. If yes: "Please provide **demo account credentials** — username/email and password — that Apple's reviewer can use. The account must not expire within 2 weeks."
4. "Are there any features the reviewer might not find on their own that need explanation?"

After collecting:
- Determine appropriate age rating based on answers (new 2026 tiers: 4+/9+/13+/16+/18+)
- Flag UGC without moderation → 17+ minimum
- Flag unrestricted web → must declare
- Draft review notes text if demo credentials or special instructions provided

Show Group 5 results table:

| Field | Your Value | Status | Why Apple Requires This |
|-------|-----------|--------|------------------------|
| Age Rating | [suggested rating] | ✅/⚠️ | Shown on App Store listing; determines who can download. Inaccurate rating = Guideline 2.3.6 rejection. Apple updated to 5 tiers in January 2026. |
| UGC Declared | [Yes/No] | ✅/⚠️ | Apps with user-generated content must declare it — failure to do so is one of the most common rating mismatches Apple catches. |
| Demo Account | [username provided or Missing] | ✅/⚠️ | Required if any part of the app needs login. Reviewer will not create their own account. Missing = Guideline 2.1 rejection. |
| Review Notes | [summary or None] | ✅/⚠️ | Helps reviewers understand non-obvious flows, special hardware needs, or regional restrictions. Reduces rejection risk significantly. |

---

### Final Metadata Summary Table

After all 5 groups are complete, show the full summary:

| # | Field | Value | Status | Apple Guideline |
|---|-------|-------|--------|-----------------|
| 1 | App Name | [value] | ✅/⚠️ | 2.3.1 |
| 2 | Subtitle | [value] | ✅/⚠️ | 2.3 |
| 3 | Primary Category | [value] | ✅/⚠️ | 2.3 |
| 4 | Description | [first 60 chars...] | ✅/⚠️ | 2.3 |
| 5 | Keywords | [value] | ✅/⚠️ | 2.3.1 |
| 6 | Support URL | [value] | ✅/⚠️ | 2.3 |
| 7 | Privacy Policy URL | [value] | ✅/⚠️ | 5.1.1(i) |
| 8 | Copyright | [value] | ✅/⚠️ | 2.3 |
| 9 | Version Number | [value] | ✅/⚠️ | 2.3 |
| 10 | Build Number | [value] | ✅/⚠️ | — |
| 11 | What's New | [first 60 chars...] | ✅/⚠️ | 2.3 |
| 12 | Age Rating | [value] | ✅/⚠️ | 2.3.6 |
| 13 | Demo Account | [✅ Provided / ⚠️ Missing] | ✅/⚠️ | 2.1 |
| 14 | Review Notes | [✅ Written / Not set] | ✅/⚠️ | 2.1 |

Then say:

> "Your metadata is [X/14 fields complete]. [List any ⚠️ items with specific fixes needed.]
> Ready to move on to screenshots, or want to revisit any field?"

---

## Phase Gate — Always Ask Before Moving Forward

After completing ANY phase of the submission process — metadata, screenshots, build validation, privacy, IAP — always pause and ask:

> "✅ [Phase name] is complete. Here's what we covered:
> [show phase summary table]
>
> **Do you want to:**
> - ✏️ Go back and change anything in this phase
> - ➡️ Move on to [next phase name]
> - 🔍 Deep dive into any specific item"

Never automatically advance to the next phase. Always wait for explicit confirmation.

### Phase Order (default flow)

| Phase | What it covers | Gate question |
|-------|---------------|---------------|
| 1. Build | SDK, build number, device testing, encryption | "Build looks good — move on to Privacy?" |
| 2. Privacy | Manifest, privacy policy, ATT, nutrition labels | "Privacy covered — move on to Metadata?" |
| 3. Metadata | All ASC fields, description, keywords, URLs | "Metadata complete — move on to Screenshots?" |
| 4. Screenshots | Visual review of each screenshot | "Screenshots approved — move on to Review Info?" |
| 5. Review Info | Demo credentials, notes, age rating | "Review info ready — move on to Final Checklist?" |
| 6. Final Checklist | IAP, regional, 2025-2026 new requirements | "All phases complete — ready to submit!" |

### 4. Account and Authentication

- [ ] Account deletion flow implemented (if account creation exists)
- [ ] Account deletion is actual deletion (not just deactivation)
- [ ] SIWA token revocation on account deletion (if SIWA used)
- [ ] Sign in with Apple offered (if any third-party login exists)
- [ ] Active subscriptions handled during account deletion
- [ ] Restore Purchases button works (if IAP exists)
- [ ] IAP items submitted for review in ASC (if new/changed)
- [ ] Subscription terms clearly communicated before purchase

### 5. App Review Information

- [ ] Contact information (name, phone, email) provided
- [ ] Demo account username provided (if login required)
- [ ] Demo account password provided (if login required)
- [ ] Demo account won't expire during review period (1-2 weeks)
- [ ] Demo account has representative sample data
- [ ] Special instructions for hardware-dependent features
- [ ] Notes explain any non-obvious features or flows
- [ ] If app uses location, provide test coordinates

### 6. Content Completeness

- [ ] No placeholder text (lorem ipsum, TODO, "Coming Soon")
- [ ] No broken links or dead-end screens
- [ ] All images are production assets (no stock watermarks)
- [ ] App icon meets spec (1024x1024, no alpha channel, no rounded corners)
- [ ] All tabs/screens have functional content
- [ ] Error states and empty states have proper messaging
- [ ] Onboarding/tutorial flows complete and accurate
- [ ] All deep links and universal links resolve correctly

### 7. Regional and Compliance

- [ ] EU DSA trader status verified (if distributing in EU)
- [ ] Age rating questionnaire completed with updated categories (13+/16+/18+)
- [ ] Age rating reflects actual content (UGC, violence, web access declared)
- [ ] Export compliance documentation uploaded (if non-exempt encryption)
- [ ] Content complies with local laws for each distribution territory
- [ ] GDPR compliance (if distributing in EU)

### 8. New for 2025-2026

- [ ] Updated age rating questionnaire completed (deadline: January 31, 2026)
- [ ] Accessibility Nutrition Labels declared (becoming required for new submissions)
- [ ] External AI service consent modal (if app sends personal data to external AI)
- [ ] SDK minimum version met (Xcode 16/iOS 18 SDK now; Xcode 26/iOS 26 SDK starting April 28, 2026)

---

## Pressure Scenarios

### Scenario 1: "Ship by end of day"

**Setup**: PM says the app must be submitted today for a marketing launch next week.

**Pressure**: Deadline + executive visibility

**Rationalization traps**:
- "We'll fix the privacy policy after approval"
- "The placeholder is only on one screen, they won't notice"
- "We'll add account deletion in the next update"
- "It passed internal testing, no need for device testing"

**MANDATORY**: Run the full pre-flight checklist. Every item. Missing items cause rejection, which costs 3-7 MORE days — far worse than the 30 minutes the checklist takes.

Skipping the checklist to save 30 minutes costs 3-7 days when it causes rejection.

**Communication template**: "The pre-flight check found [N] issues that will cause rejection. Fixing them takes [X hours]. Submitting without fixing guarantees rejection, which costs 3-7 days minimum. Let me fix these now — it's the fastest path to being live."

---

### Scenario 2: "Third rejection, just make it work"

**Setup**: App rejected 3 times for different issues each time. Developer is frustrated and tempted to cut corners or argue with Apple.

**Pressure**: Frustration + sunk cost + temptation to appeal instead of fix

**Rationalization traps**:
- "They keep finding new issues — they're being unfair"
- "I'll appeal this one, it's unreasonable"
- "I'll just hide that screen from reviewers"

**MANDATORY**: Read the FULL text of every rejection message. Run the complete pre-flight checklist from scratch. Reviewers often find new issues on subsequent reviews because they test deeper each pass — they explore screens they didn't reach before, test flows they skipped, and review with stricter attention.

Each rejection is a signal that the pre-submission process has gaps. Do not fight the feedback — absorb it and close the gaps systematically.

**Communication template**: "Multiple rejections mean we have systematic gaps, not bad luck. I'm running the complete pre-flight checklist — this takes 30 minutes but prevents the 3-7 day cycle of partial fixes followed by new rejections."

---

### Scenario 3: "It's just a bug fix update"

**Setup**: Simple one-line bug fix. Developer assumes the update will sail through because the app was already approved.

**Pressure**: Complacency + false confidence from prior approval

**Rationalization traps**:
- "It was approved last time with the same metadata"
- "I only changed one file, they don't need to re-review everything"
- "They won't re-check the privacy stuff, it hasn't changed"

**MANDATORY**: Updates are reviewed against CURRENT guidelines. Requirements change between releases. Privacy manifests became mandatory mid-cycle. Age rating questionnaire was overhauled. SDK minimums increase annually. A bug fix update can be rejected for issues that didn't exist when the previous version was approved.

Run the pre-flight checklist every time. Requirements that didn't exist when your app was last reviewed may now be enforced.

**Communication template**: "Even for a bug fix, App Review applies current guidelines — not the ones from when we were last approved. The privacy manifest requirement and age rating overhaul both came mid-cycle. Running the 30-minute pre-flight now prevents a surprise rejection."

---

## Screenshot Requirements & Visual Review

Screenshots must match current app UI. See `references/part1-screenshot-sizes.md` for required sizes, dimensions, and rules.

### Proactive Screenshot Review — Always Do This

Whenever the user mentions screenshots, is preparing for submission, or asks if their screenshots are ready — **immediately ask them to share the screenshots** before doing anything else. Do not wait for them to offer. Say exactly this:

> "Before we go any further — drop your screenshots here one by one and I'll review each one for you. I'll give you a clear ✅ or ⚠️ on every item before you upload anything to App Store Connect."

If the user says they don't have screenshots ready yet, ask:
> "How many screenshots do you have so far, and which device sizes? I can help you figure out what's missing."

---

### When the User Shares a Screenshot — Full Review Protocol

Inspect every screenshot image shared and report on ALL items below. Be specific — name exactly what you see, don't just say "looks good":

**1. Size & Device Check**
- Ask the user which device this screenshot is for (iPhone 16 Pro Max? iPad? etc.)
- Remind them you cannot measure pixels from a preview — ask them to confirm dimensions via right-click → Get Info on Mac, or check their Simulator export settings
- Flag if dimensions look wrong for the stated device (e.g., portrait/landscape mismatch)

**2. Status Bar Check**
- Time shown — must be **9:41 AM**. Flag any other time.
- Signal bars — must be full. Flag if empty or partial.
- WiFi icon — must be showing. Flag if missing.
- Battery — must be **full (100%), not charging**. Flag if low or charging icon visible.
- Carrier name — must be hidden/blank. Flag if a real carrier name (e.g., Airtel, Jio, Vodafone, AT&T) is visible.

**3. Content Check**
- Is actual app UI visible? Flag if it looks like a pure marketing graphic with no real UI.
- Any placeholder text? (e.g., "Lorem ipsum", "TODO", "Sample Data", "Coming Soon") — flag immediately.
- Any broken layout, clipped elements, cut-off text, or overflow? Flag it.
- Is the app in a logical, complete state? (not mid-animation, not a loading spinner)

**4. Text Overlay Check** (if screenshot has marketing text)
- Is text legible at a glance? Flag if font is too small or low contrast.
- Does the copy match the screen being shown? Flag if mismatched.
- Any spelling errors? Flag them.

**5. Branding Check**
- Any third-party logos or brand assets the user may not own? Flag them.
- Any competitor app names or logos visible? Flag immediately.

**6. Device Frame Check**
- If a device frame is added — do the rounded corners look natural (from a frame tool)?
- Flag if rounded corners look manually cropped or pixelated.

---

### Output Format — Use This Structure for Every Screenshot

```
Screenshot [N] Review
─────────────────────
📐 Size/Device     — [device stated by user | reminder to verify px dimensions]
✅/⚠️ Status bar   — [what you see: time, signal, battery, carrier]
✅/⚠️ Content      — [what you see]
✅/⚠️ Text overlay — [what you see, or N/A]
✅/⚠️ Branding     — [what you see]
✅/⚠️ Device frame — [what you see, or N/A]

Verdict: ✅ Ready to upload  /  ⚠️ Fix before uploading
Issues to fix: [list each fix needed, or "None"]
```

---

### After All Screenshots Are Reviewed — Give a Summary

```
Screenshot Review Summary
──────────────────────────
Total reviewed: X
✅ Ready to upload: X
⚠️ Need fixes: X

Fixes required:
- Screenshot 2: Status bar shows real time (7:23 PM) — set to 9:41 AM
- Screenshot 4: Carrier name "Jio" visible — hide in Simulator status bar settings
[etc.]

⚠️ Important: Confirm pixel dimensions manually before uploading.
   Mac: right-click image → Get Info → dimensions
   Simulator: use Edit → Set Status Bar before capturing

✅ Once fixes are done, you're clear to upload to App Store Connect.
```

---

## Handling Rejections

### Reading the Rejection Message

Every rejection includes:
1. **Guideline number** — Specific section violated
2. **Description** — What the reviewer found
3. **Screenshots/recordings** — Visual evidence (if applicable)
4. **Suggestions** — Sometimes included with fixes

### Response Strategy

```
1. Read the FULL rejection message (every word)
2. Identify ALL guidelines cited (may be multiple)
3. Fix EVERY cited issue (not just the first one)
4. Run the complete pre-flight checklist
5. In your resubmission notes, explain what you fixed
6. Do NOT argue or explain why you think the rejection is wrong
```

### When to Appeal

Appeals are appropriate when:
- You believe the reviewer misunderstood your app's functionality
- Your app clearly complies with the cited guideline
- You have evidence supporting your position

Appeals are NOT appropriate when:
- You disagree with the guideline itself
- The rejection is technically correct but feels unfair
- You want to delay fixing the issue

### Appeal Process

```
App Store Connect → Resolution Center → Reply
- Explain clearly why you believe the rejection is incorrect
- Provide specific evidence (screenshots, documentation)
- Remain professional and factual
- Apple's App Review Board will re-review
```

### Metadata Rejected vs Binary Rejected

| Type | What it means | What to do |
|------|--------------|------------|
| Metadata Rejected | Screenshots, description, or ASC fields need fixing | Fix in ASC, resubmit (no new build needed) |
| Binary Rejected | Code/app issue needs fixing | Fix code, create new archive, upload new build |

---

## In-App Purchase Review

IAP items require separate review. Missing or broken IAP is a top rejection cause under Guideline 3.1.1.

### IAP Submission Checklist

- [ ] All IAP products created in ASC with screenshots
- [ ] IAP products submitted for review (can be submitted independently)
- [ ] Restore Purchases button visible and functional
- [ ] Subscription terms displayed before purchase confirmation
- [ ] Free trial terms clearly communicated
- [ ] Pricing displayed matches ASC configuration
- [ ] No external purchase links (Guideline 3.1.1) unless eligible for entitlement
- [ ] StoreKit testing completed in sandbox environment

### Common IAP Rejection Patterns

```
❌ "Buy Premium" button that does nothing → Guideline 3.1.1
❌ No Restore Purchases option → Guideline 3.1.1
❌ Subscription auto-renews without clear disclosure → Guideline 3.1.2
❌ Free trial duration not shown before purchase → Guideline 3.1.2
❌ External purchase link without entitlement → Guideline 3.1.1
```

---

## Common Rejection Reasons Quick Reference

| Guideline | Issue | Prevention |
|-----------|-------|------------|
| 2.1 | Crashes, broken features, incomplete | Device testing, content audit |
| 2.3 | Inaccurate metadata, wrong screenshots | Screenshot audit, metadata review |
| 2.3.6 | Incorrect age rating | Honest questionnaire, declare UGC |
| 3.1.1 | IAP issues, missing Restore Purchases | Test all IAP flows, add restore |
| 4.0 | Design: poor UI, non-standard patterns | Follow HIG, test on all sizes |
| 4.8 | Missing Sign in with Apple | Add SIWA with any third-party login |
| 5.1.1(i) | Privacy policy missing/inadequate | Both ASC and in-app, specific content |
| 5.1.1(v) | No account deletion | In-app deletion, not just deactivation |
| 5.1.2 | Missing Required Reason APIs | Complete privacy manifest |

---

## App Store Connect Submission Workflow

See `app-store-ref` Part 9 for the ASC upload workflow and build processing details.

---

## Encryption Export Compliance

Most apps need `ITSAppUsesNonExemptEncryption = false`. See `app-store-ref` Part 5 for the full decision tree.

---

## Accessibility Nutrition Labels (New 2025)

Accessibility Nutrition Labels are becoming required for new submissions. See `app-store-ref` Part 10 for the full label list and declaration rules. Run `axiom-accessibility-diag` before declaring.

---

## First-Time Developer Checklist

For developers submitting their first app, these are additional items often missed. If you need to create a privacy policy from scratch, use a privacy policy generator (many free options exist) and customize it to match your app's actual data practices — a generic template will be rejected.

### Apple Developer Program

- [ ] Enrolled in Apple Developer Program ($99/year)
- [ ] Accepted latest Apple Developer Program License Agreement
- [ ] Tax and banking information completed in ASC (for paid apps/IAP)
- [ ] Distribution certificate created
- [ ] App ID registered with correct bundle identifier
- [ ] Provisioning profile created for App Store distribution

### App Store Connect Setup

- [ ] New app record created in ASC
- [ ] Bundle ID matches Xcode project exactly
- [ ] Primary language set
- [ ] Content rights declared (original content or licensed)
- [ ] Pricing and availability configured
- [ ] Territory selection (worldwide or specific countries)

### Common First-Time Mistakes

| Mistake | Result | Fix |
|---------|--------|-----|
| Bundle ID mismatch between Xcode and ASC | Upload rejected | Match exactly, including case |
| Distribution cert expired/missing | Archive fails to upload | Create new cert in Developer Portal |
| License agreement not accepted | Upload blocked | Accept in developer.apple.com |
| Tax forms incomplete | Paid app not distributed | Complete in ASC → Agreements, Tax, and Banking |
| Wrong team selected in Xcode | Signing errors | Select correct team in Signing & Capabilities |

---

## Real-World Impact

**Before**: Developer submits without checklist → rejected for missing privacy manifest (3 days) → fixes, resubmits → rejected for missing SIWA (5 days) → fixes, resubmits → rejected for placeholder content (3 days) → 11 days lost to preventable issues

**After**: Developer runs 30-minute pre-flight → catches all three issues → fixes in 4 hours → approved on first submission

**Key insight**: The checklist takes 30 minutes. Each rejection cycle takes 3-7 days. The math is simple.

---

## Resources

**WWDC**: 2022-10166, 2025-328, 2025-224, 2025-241

**Docs**: /app-store/review/guidelines, /app-store/submitting, /app-store/app-privacy-details, /support/offering-account-deletion-in-your-app, /documentation/security/complying-with-encryption-export-regulations

**Skills**: axiom-privacy-ux, axiom-storekit-ref, axiom-accessibility-diag, axiom-testflight-triage, axiom-app-store-connect-ref

---

## Reference Files

When the main SKILL.md refers to a Part number, read the corresponding reference file:

| Part | File | Contents |
|------|------|----------|
| Part 1 | `references/part1-screenshot-sizes.md` | Required screenshot dimensions for all iPhone/iPad sizes, format rules, status bar normalization, tools |
| Part 5 | `references/part5-encryption-export.md` | Encryption export compliance decision tree, ITSAppUsesNonExemptEncryption, ERN process |
| Part 9 | `references/part9-asc-upload-workflow.md` | App Store Connect upload workflow, build states, Transporter, post-upload steps, submission flow |
| Part 10 | `references/part10-accessibility-nutrition-labels.md` | Accessibility Nutrition Label categories, declaration requirements, verification steps (2025) |

Load only the reference file(s) relevant to the user's current question.