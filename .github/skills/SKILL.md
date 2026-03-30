---
name: app-store-submission
description: >
  Guide iOS developers through the full Apple App Store submission process —
  from project readiness through build validation, screenshots, metadata, and
  final submission. Use this skill whenever an iOS developer mentions: submitting
  to the App Store, App Store Connect, TestFlight upload, build validation,
  app screenshots, app metadata, release checklist, preparing a release, app
  review, or archiving a build. Also trigger when the user says things like
  "I'm getting ready to ship", "prepping my app for release", or "what do I
  need before submitting". This skill applies even if the user only asks about
  one phase (e.g., just screenshots) — offer the full checklist so they don't
  miss anything.
---

# App Store Submission Skill

You are guiding an iOS developer through the full Apple App Store submission
pipeline. Work phase by phase, confirm completion before advancing, and adapt
to what the user already has done. Don't repeat steps they've confirmed.

---

## How to Start

Ask which phase they're in (or start from the top if they say "beginning"):
1. Project Readiness
2. Build Validation
3. Screenshots
4. Metadata
5. Submission Flow

If they describe a specific blocker (e.g., "my build is rejecting"), jump
straight to the relevant phase and diagnose before resuming the checklist.

---

## Phase 1 — Project Readiness

Goal: confirm the project is clean and correctly configured before touching
App Store Connect or Xcode's Organizer.

### Bundle & Signing
- [ ] Bundle ID matches exactly what's registered in App Store Connect
- [ ] Signing certificate is **Apple Distribution** (not Development)
- [ ] Provisioning profile is **App Store Distribution**, includes all capabilities used
- [ ] Entitlements file matches capabilities enabled in the Developer Portal
- [ ] If using Push Notifications — APNs key or cert is uploaded to App Store Connect

### Version & Build Number
- [ ] `CFBundleShortVersionString` (Marketing version) follows SemVer — e.g., `2.1.0`
- [ ] `CFBundleVersion` (Build number) is **strictly higher** than the last uploaded build
- [ ] Deployment target is set intentionally (not accidentally too low or too high)

### Dependencies & Third-Party SDKs
- [ ] All SDKs have privacy manifests (`PrivacyInfo.xcprivacy`) if required — Apple rejects builds missing these since May 2024
- [ ] No deprecated APIs generating warnings that could trigger review flags
- [ ] SPM / CocoaPods / Carthage packages are resolved and committed/locked

### App Capabilities Audit
- [ ] Every capability in the `.entitlements` file is enabled in the Developer Portal
- [ ] Any capability removed from the app is also removed from the portal
- [ ] If using In-App Purchases — products are created and in "Ready to Submit" state

**Tip:** Run `xcodebuild -showBuildSettings | grep PRODUCT_BUNDLE_IDENTIFIER` to
confirm the bundle ID Xcode is actually using, especially in multi-target projects.

---

## Phase 2 — Build Validation

Goal: produce a clean archive and pass App Store validation before uploading.

### Archive the Build
```
Product → Archive  (or: xcodebuild archive -scheme <YourScheme> -archivePath build/App.xcarchive)
```
- Select **Any iOS Device (arm64)** — not a simulator
- Confirm scheme is set to **Release** configuration

### Local Validation (before upload)
In Xcode Organizer → select archive → **Validate App**:
- Choose "Upload" distribution method
- Enable "Automatically manage signing" or select manual profile
- Fix ALL errors; warnings are usually safe but review them

Common validation errors and fixes:

| Error | Fix |
|---|---|
| `Missing privacy manifest` | Add `PrivacyInfo.xcprivacy` to the target |
| `Invalid Info.plist` key for this platform | Remove keys unsupported on iOS |
| `Binary is not permitted...` | Strip unused architectures or remove sim slices |
| `ITMS-90683: Missing Purpose String` | Add `NS*UsageDescription` keys for every permission used |
| `Bitcode is deprecated` | Disable Bitcode in Build Settings (Xcode 14+) |

### Upload via Xcode or Transporter
**Option A — Xcode Organizer:**
Validate → Distribute App → App Store Connect → Upload

**Option B — Transporter (recommended for CI):**
```bash
xcrun altool --upload-app -f MyApp.ipa \
  -t ios --apiKey <KEY_ID> --apiIssuer <ISSUER_ID>
```

### Post-Upload
- Check App Store Connect → **Activity** tab — processing takes 5–30 min
- Watch for email from Apple with any automated rejections
- Build must show **"Ready to Submit"** before you can attach it to a version

---

## Phase 3 — Screenshots

Read `references/screenshot-sizes.md` for the full size table.

### Required Devices (minimum set)
Apple currently requires screenshots for:
- **6.9" iPhone** (iPhone 16 Pro Max) — required since 2024
- **6.5" iPhone** (iPhone 14 Plus / 13 Pro Max) — or use 6.9" to cover both
- **12.9" iPad Pro** (if the app supports iPad)

You can use one screenshot set to satisfy multiple size classes if dimensions match.

### Screenshot Rules
- Format: PNG or JPEG, RGB, no alpha
- Must show actual app UI — no marketing graphics as the only content
- No device frames required (but allowed)
- No rounded corners applied by you (App Store adds them)
- Text must be legible; don't shrink UI to fit more in
- Localize screenshots for each language you support

### Generating Screenshots with fastlane snapshot
```ruby
# Snapfile
devices(["iPhone 16 Pro Max", "iPad Pro (12.9-inch) (6th generation)"])
languages(["en-US"])
scheme("MyAppUITests")
output_directory("./screenshots")
clear_previous_screenshots(true)
```
```bash
bundle exec fastlane snapshot
```

### Manual Screenshot Checklist
- [ ] Correct dimensions for each required device (see `references/screenshot-sizes.md`)
- [ ] No status bar showing real time, carrier, or low battery
- [ ] Use Simulator's **Edit → Set Status Bar** to normalize (9:41 AM, full signal, full battery)
- [ ] First screenshot is your strongest hook — it shows in search results
- [ ] Up to 10 screenshots per device; at least 1 required

### Visual Review Before Upload (always do this step)

Before the user uploads anything to App Store Connect, ask them to share
each screenshot image directly in the chat for a visual review. Say:

> "Before you upload, drop your screenshots here one by one — I'll review
> each one and give you a go/no-go before you touch App Store Connect."

When the user shares a screenshot image, inspect it and report on every
item below. Be specific — don't just say "looks good", call out exactly
what you see and whether it passes or fails:

**Status Bar Check**
- Time shown — must be 9:41 AM. Flag any other time.
- Signal bars — must be full. Flag if empty or partial.
- WiFi icon — must be showing. Flag if missing.
- Battery — must be full (100%), not charging. Flag if low or charging icon visible.
- Carrier name — must be hidden/blank. Flag if a real carrier name (e.g., Airtel, Vodafone, AT&T) is visible.

**Content Check**
- Is actual app UI visible? Flag if it looks like a pure graphic with no UI.
- Any placeholder text visible? (e.g., "Lorem ipsum", "TODO", "Sample Data") — flag immediately.
- Any broken layout, clipped elements, or overflow visible? Flag it.
- Is the app in a logical, complete state? (not mid-animation, not loading spinner)

**Text Overlay Check (if the screenshot has marketing text on it)**
- Is the text legible at a glance? Flag if font is too small or low contrast.
- Does the copy match the screen being shown? Flag if mismatched.
- Any spelling errors? Flag them.

**Branding Check**
- Any third-party logos or brand assets visible that the user may not own? Flag them.
- Any competitor app names or logos visible? Flag immediately.

**Device Frame Check**
- If a device frame is added — are the rounded corners natural (from the frame tool)?
- Flag if rounded corners look manually cropped or pixelated.

**Output Format — always respond with this structure for each screenshot:**

```
Screenshot [N] Review
─────────────────────
✅ Status bar      — [what you see]
✅/⚠️ Content       — [what you see]
✅/⚠️ Text overlays — [what you see, or N/A]
✅/⚠️ Branding      — [what you see]
✅/⚠️ Device frame  — [what you see, or N/A]

Verdict: ✅ Ready to upload  /  ⚠️ Fix before uploading
Issues to fix: [list specific fixes needed, or "None"]
```

After reviewing all screenshots, give a summary:
- Total count reviewed
- How many are ready vs need fixes
- Remind them to confirm pixel dimensions manually (you can't measure from preview)
- Only then tell them they're clear to upload to App Store Connect

---

## Phase 4 — Metadata

Read `references/metadata-template.md` for a fill-in-the-blank template.

### App Information (set once, version-independent)
| Field | Limit | Notes |
|---|---|---|
| App Name | 30 chars | Appears under icon; include primary keyword |
| Subtitle | 30 chars | Secondary keyword opportunity |
| Bundle ID | — | Cannot change after first submission |
| SKU | — | Internal identifier; your choice, immutable |
| Primary Category | — | Pick the most accurate one |
| Secondary Category | optional | |
| Content Rights | — | Confirm you own or have licensed all content |

### Version Information (per release)
| Field | Limit | Notes |
|---|---|---|
| Description | 4000 chars | First 3 lines show without "More"; lead with value |
| Keywords | 100 chars total | Comma-separated; no spaces after commas; no repeating app name |
| What's New | 4000 chars | Be specific; users read this for bug fixes |
| Support URL | required | Must be live and reachable |
| Marketing URL | optional | |
| Privacy Policy URL | required | Must describe actual data practices |

### Age Rating
Complete the questionnaire honestly. Key flags:
- Any user-generated content → 17+ unless you have moderation
- Mature/suggestive content → follow Apple's thresholds exactly
- Gambling mechanics → disclose

### Review Notes (often overlooked — don't skip)
- Demo account credentials if login is required
- Instructions for any feature that isn't obvious to a reviewer
- Explanation for any sensitive permissions (e.g., "Location is used to show nearby stores")

### App Encryption
- If you use **only Apple's standard encryption** (HTTPS/TLS): answer "No" to encryption
- If you use custom cryptography: you may need an ERN (Encryption Registration Number)

---

## Phase 5 — Submission Flow

### Pre-Submit Checklist
- [ ] Build is in "Ready to Submit" state in Activity tab
- [ ] All screenshots uploaded for required devices
- [ ] All metadata fields complete
- [ ] Age rating questionnaire complete
- [ ] Pricing set (even if free)
- [ ] Availability / territories configured
- [ ] Review notes filled in
- [ ] If IAP: all products in "Ready to Submit"

### Submitting for Review
1. App Store Connect → Your App → **+ Version or Platform**
2. Select the build from the dropdown
3. Attach screenshots, fill metadata
4. Click **Add for Review** → **Submit to App Review**

### Release Options
| Option | When to use |
|---|---|
| **Automatic release** | Release immediately after approval |
| **Manual release** | You control the moment (up to 30 days post-approval) |
| **Phased release** | Roll out to 1%→2%→5%→10%→20%→50%→100% over 7 days |

Phased release can be paused if you catch a critical bug post-launch.

### After Submission
- Average review time: **24–48 hours** (check appstoreconnect.apple.com/review for current times)
- You'll receive email on approval or rejection
- On rejection: read the reason carefully; respond via Resolution Center, not a new submission
- You can **reply to the reviewer** in Resolution Center to ask for clarification

### Common Rejection Reasons & Fixes
| Reason | Fix |
|---|---|
| 2.1 — App Completeness | Remove placeholder content, broken links, demo data |
| 4.0 — Design | Fix crashes, improve UI consistency |
| 5.1.1 — Privacy — Data Collection | Update privacy policy, add missing `NS*UsageDescription` |
| 3.1.1 — In-App Purchase | Use IAP for digital goods; remove external payment links |
| 2.3.3 — Accurate Metadata | Screenshots must match actual app |

---

## Reference Files

- `references/screenshot-sizes.md` — Full table of all required/optional screenshot dimensions
- `references/metadata-template.md` — Copy-paste metadata template for each release

---

## Generating Assets with Claude

If the user asks you to **generate metadata text** (description, keywords, What's New):
- Ask for: app name, one-sentence summary, top 3 features, target audience
- Write description leading with the user benefit, not feature list
- Keywords: extract from description but don't repeat; think synonyms and use-case terms

If the user asks you to **generate screenshot compositions**:
- Suggest copy for overlay text on each screenshot
- Recommend a visual hierarchy: headline → sub-headline → device mockup
- Recommend tools: Sketch, Figma, AppLaunchpad, or fastlane frameit
