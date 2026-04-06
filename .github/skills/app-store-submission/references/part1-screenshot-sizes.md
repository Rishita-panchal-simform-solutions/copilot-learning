# Part 1 — Screenshot Sizes & Requirements

## Required Screenshot Sizes (as of 2025)

### iPhone

| Display | Device Example | Size (px) | Required? |
|---------|---------------|-----------|-----------|
| 6.9" Super Retina XDR | iPhone 16 Pro Max | 1320 × 2868 | ✅ Required (since 2024) |
| 6.7" Super Retina XDR | iPhone 15 Plus / 14 Pro Max | 1290 × 2796 | Optional (covered by 6.9") |
| 6.5" Super Retina XDR | iPhone 14 Plus / 13 Pro Max | 1284 × 2778 | Optional (covered by 6.9") |
| 6.1" Super Retina XDR | iPhone 15 / 14 | 1170 × 2532 | Optional |
| 5.5" Retina HD | iPhone 8 Plus | 1242 × 2208 | Optional |
| 4.7" Retina HD | iPhone SE (3rd gen) / 8 | 750 × 1334 | Optional |
| 4" Retina | iPhone SE (1st gen) | 640 × 1136 | Optional |

> **Minimum requirement**: Submit 6.9" screenshots. Apple uses them to auto-scale for smaller sizes.

### iPad

| Display | Device Example | Size (px) | Required? |
|---------|---------------|-----------|-----------|
| 13" iPad Pro (M4) | iPad Pro 13-inch | 2064 × 2752 | ✅ Required if iPad supported |
| 12.9" iPad Pro | iPad Pro 12.9" (5th/6th gen) | 2048 × 2732 | Accepted (covers 12.9") |
| 11" iPad Pro | iPad Pro 11-inch | 1668 × 2388 | Optional |
| 10.9" iPad Air | iPad Air (5th gen) | 1640 × 2360 | Optional |
| 9.7" iPad | iPad (9th gen and earlier) | 1536 × 2048 | Optional |

> **Minimum requirement if iPad supported**: Submit 12.9" or 13" screenshots.

---

## Screenshot Rules

### Format
- **File type**: PNG or JPEG
- **Color space**: RGB (not CMYK)
- **Alpha channel**: Not allowed (no transparency)
- **Resolution**: Exact pixel dimensions listed above (not approximate)

### Content Rules
- Must show actual in-app UI — marketing-only graphics without UI are rejected (Guideline 2.3.3)
- No device frames required, but allowed
- No manually applied rounded corners — App Store applies them automatically
- No letterboxing or pillarboxing
- Status bar must show: 9:41 AM, full signal, full WiFi, full battery (100%, not charging)
- No carrier name visible
- First screenshot is the most important — it shows in search results without the user tapping

### Localization
- Localize screenshots for each language you support
- Different languages may have different UI text lengths that affect layout

### Count
- Minimum: 1 screenshot per required device size
- Maximum: 10 screenshots per device size

### App Previews (Videos)
- Optional video preview: up to 30 seconds, 15–30 fps
- Must begin and end with a still frame matching screenshot dimensions
- Auto-plays silently in App Store; first frame is the poster image
- Video must show actual in-app functionality (no fabricated UI)

---

## Common Screenshot Rejection Causes

| Issue | Guideline | Fix |
|-------|-----------|-----|
| Screenshots don't match current app UI | 2.3.3 | Retake screenshots after latest UI changes |
| Real carrier name visible in status bar | 2.3 | Use Simulator Edit → Set Status Bar |
| Wrong dimensions submitted | 2.3 | Match exact pixel sizes in table above |
| Missing required device size | 2.3 | Add 6.9" iPhone and 12.9" iPad (if iPad supported) |
| Pure marketing graphic, no UI shown | 2.3.3 | Include actual app UI in every screenshot |
| Alpha channel present | Upload error | Re-export as RGB with no alpha |

---

## Tools for Screenshots

| Tool | Use |
|------|-----|
| Xcode Simulator | Capture at exact dimensions; use Edit → Set Status Bar |
| fastlane snapshot | Automated screenshot generation via UI tests |
| AppLaunchpad | Online screenshot framing/composition tool |
| fastlane frameit | Adds device frames to simulator screenshots |
| Sketch / Figma | Design screenshot compositions with marketing overlays |

---

## Quick Checklist Before Upload

- [ ] 6.9" iPhone screenshots captured (required)
- [ ] 12.9" or 13" iPad screenshots captured (if iPad supported)
- [ ] Status bar shows 9:41 AM, full bars, full battery, no carrier
- [ ] PNG/JPEG, RGB, no alpha
- [ ] First screenshot is your strongest hook
- [ ] Screenshots match current version of the app
- [ ] Screenshots localized for each supported language
