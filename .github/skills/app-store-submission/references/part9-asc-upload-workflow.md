# Part 9 — App Store Connect Upload Workflow & Build Processing

## Overview

This covers the complete workflow from Xcode archive to build appearing as "Ready to Submit" in App Store Connect (ASC).

---

## Pre-Upload Checklist

Before touching Xcode Organizer or Transporter:

- [ ] Build number (CFBundleVersion) is strictly higher than any previously uploaded build
- [ ] Marketing version (CFBundleShortVersionString) is correct for this release
- [ ] Scheme is set to Release configuration (not Debug)
- [ ] Target device is **Any iOS Device (arm64)** — not a Simulator destination
- [ ] All required capabilities are enabled in both Xcode and the Developer Portal
- [ ] Distribution certificate is valid (not expired)
- [ ] App Store Distribution provisioning profile is selected

---

## Step 1: Archive the Build

### Via Xcode (recommended for most developers)

```
Product → Archive
```

Wait for archiving to complete. The Organizer window opens automatically.

### Via Command Line (for CI/CD)

```bash
xcodebuild archive \
  -scheme YourScheme \
  -configuration Release \
  -archivePath ./build/YourApp.xcarchive \
  -destination 'generic/platform=iOS'
```

---

## Step 2: Validate Before Upload

**Always validate before uploading.** Validation runs the same checks Apple's servers run — catching errors locally saves 5–30 minutes of upload + processing time.

### Xcode Organizer Validation

```
Organizer → Select archive → Validate App
→ Distribution method: App Store Connect
→ Enable "Automatically manage signing" OR select your profile manually
→ Click Next → Validate
```

Fix ALL errors before proceeding. Review warnings — most are safe but some indicate real issues.

### Common Validation Errors

| Error | Cause | Fix |
|-------|-------|-----|
| `ITMS-90683: Missing Purpose String` | `NS*UsageDescription` key absent | Add to Info.plist for every permission used |
| `Missing privacy manifest` | No PrivacyInfo.xcprivacy | Add privacy manifest to app target |
| `Invalid binary - missing required reason` | Required Reason API undeclared | Add API reason to PrivacyInfo.xcprivacy |
| `Invalid Info.plist value` | Unsupported key for this platform | Remove the offending key |
| `Binary contains simulator code` | Simulator slices included | Clean build, rebuild for device only |
| `Bitcode is deprecated` | Bitcode enabled in Build Settings | Disable: Build Settings → Enable Bitcode → No |
| `CFBundleVersion must be higher` | Build number not incremented | Increment CFBundleVersion and re-archive |

---

## Step 3: Upload the Build

### Option A — Xcode Organizer (simplest)

```
Organizer → Select archive → Distribute App
→ App Store Connect
→ Upload
→ Follow prompts
```

Progress bar shows upload status. Large apps (100MB+) can take several minutes.

### Option B — Transporter App (Apple's official tool)

1. Download Transporter from the Mac App Store
2. Sign in with your Apple ID
3. Drag the `.ipa` file (export from Organizer first) into Transporter
4. Click Deliver

### Option C — `altool` CLI (legacy, deprecated in Xcode 15+)

```bash
xcrun altool --upload-app \
  -f YourApp.ipa \
  -t ios \
  --apiKey YOUR_KEY_ID \
  --apiIssuer YOUR_ISSUER_ID
```

> Note: `altool` is deprecated. Prefer Xcode Organizer or Transporter for interactive use; use `xcodebuild` + Transporter CLI for CI.

### Option D — `notarytool` / `xcodebuild -exportArchive` for CI

```bash
# Export IPA from archive
xcodebuild -exportArchive \
  -archivePath ./build/YourApp.xcarchive \
  -exportOptionsPlist ExportOptions.plist \
  -exportPath ./build/

# Upload with altool (or via Transporter CLI)
xcrun altool --upload-app -f ./build/YourApp.ipa \
  -t ios --apiKey $KEY_ID --apiIssuer $ISSUER_ID
```

**ExportOptions.plist** (minimum):
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "...">
<plist version="1.0">
<dict>
  <key>method</key>
  <string>app-store-connect</string>
  <key>teamID</key>
  <string>YOUR_TEAM_ID</string>
</dict>
</plist>
```

---

## Step 4: Monitor Build Processing

After upload, Apple processes the build on their servers. This takes **5–30 minutes** (occasionally longer during peak periods).

### Where to Monitor

```
App Store Connect → Your App → TestFlight tab → Builds
```

Or:

```
App Store Connect → Your App → App Store tab → Build section → Activity
```

### Build States

| State | Meaning | Action |
|-------|---------|--------|
| Processing | Apple is processing the build | Wait |
| Missing Compliance | Encryption compliance question pending | Answer in ASC |
| Ready to Submit | Build passed processing, can be attached to a version | Proceed |
| Invalid Binary | Build failed processing | Check email for details, fix and re-upload |
| Expired | Build not submitted within 90 days | Re-upload |

### Email Notifications

Apple sends email to your Apple ID for:
- **Upload accepted** — build started processing
- **Automated rejection** — build failed automated checks (check the email carefully for the reason)
- **Processing complete** — build is ready

---

## Step 5: Attach Build to Version

Once the build shows "Ready to Submit":

```
App Store Connect → Your App → App Store → + Version or Platform (if new version)
→ Select your version
→ Build section → "+" → Select your build
```

---

## Step 6: Complete Version Information

Before submitting for review, ensure all fields are filled:

- [ ] Build attached
- [ ] All screenshots uploaded for required device sizes
- [ ] Description, keywords, What's New completed
- [ ] Support URL is live
- [ ] Privacy Policy URL is live and accurate
- [ ] Age Rating questionnaire completed
- [ ] Review Notes filled in (demo account if needed)
- [ ] Pricing set
- [ ] Availability/territories configured
- [ ] If IAP: all products in "Ready to Submit" state

---

## Step 7: Submit for Review

```
App Store Connect → Your App → App Store tab → Submit for Review
```

Or click **Add for Review** → **Submit to App Review**.

### Release Options

Select your release strategy:

| Option | Behavior |
|--------|----------|
| Automatic release after approval | Goes live immediately when Apple approves |
| Manual release | You control timing (up to 30 days post-approval) |
| Phased release over 7 days | Rolls out to increasing % of users over 7 days |

---

## Post-Submission

- **Review time**: Typically 24–48 hours. Check [appstoreconnect.apple.com/review](https://appstoreconnect.apple.com/review) for current average wait times.
- **Status updates**: Visible in ASC under the version's status
- **Rejection**: If rejected, respond via Resolution Center — do not submit a new build unless the code itself needs changing
- **Metadata-only rejection**: Fix in ASC without a new build → resubmit
- **Binary rejection**: Fix code → new archive → new upload → attach new build → resubmit

---

## Troubleshooting Upload Failures

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| "No accounts with iTunes Connect access" | Wrong Apple ID or no App Manager role | Check team roles in ASC |
| Upload stalls at 100% | Network issue or Apple server delay | Wait 30 min, retry |
| "Invalid Bundle - One or more dynamic libraries..." | Framework not embedded properly | Check Embed & Sign in Build Phases |
| "Asset validation failed" | Icon missing or wrong format | Verify 1024×1024 PNG, no alpha, in asset catalog |
| Transporter shows "Package Summary error" | Build integrity issue | Clean, re-archive, try again |
