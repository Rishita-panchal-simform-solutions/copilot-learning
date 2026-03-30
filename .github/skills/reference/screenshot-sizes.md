# App Store Screenshot Sizes — iOS

Last updated for App Store Connect requirements as of 2024/2025.

---

## iPhone

| Display Size | Example Devices | Required? | Portrait (px) | Landscape (px) |
|---|---|---|---|---|
| 6.9" | iPhone 16 Pro Max | ✅ Required (new) | 1320 × 2868 | 2868 × 1320 |
| 6.7" | iPhone 16 Plus, 15 Plus, 14 Plus | Covered by 6.9" | 1290 × 2796 | 2796 × 1290 |
| 6.5" | iPhone 14 Pro Max, 13 Pro Max, 12 Pro Max | ✅ Covers 6.7" too | 1284 × 2778 | 2778 × 1284 |
| 6.3" | iPhone 16 Pro | Optional | 1206 × 2622 | 2622 × 1206 |
| 6.1" | iPhone 16, 15, 14, 13 | Optional | 1179 × 2556 | 2556 × 1179 |
| 5.8" | iPhone X, XS, 11 Pro | Optional | 1125 × 2436 | 2436 × 1125 |
| 5.5" | iPhone 8 Plus, 7 Plus | Optional (legacy) | 1242 × 2208 | 2208 × 1242 |
| 4.7" | iPhone 8, SE (2nd/3rd gen) | Optional (legacy) | 750 × 1334 | 1334 × 750 |
| 4.0" | iPhone SE (1st gen) | Optional (legacy) | 640 × 1136 | 1136 × 640 |

**Minimum required set for iPhone-only app:**
Upload 6.9" screenshots. Apple will use them for all iPhone sizes.

---

## iPad

| Display Size | Example Devices | Required? | Portrait (px) | Landscape (px) |
|---|---|---|---|---|
| 13" iPad Pro (M4) | iPad Pro 13" M4 | ✅ Required if iPad supported | 2064 × 2752 | 2752 × 2064 |
| 12.9" iPad Pro | iPad Pro 12.9" (1st–6th gen) | ✅ Covers most | 2048 × 2732 | 2732 × 2048 |
| 11" iPad Pro | iPad Pro 11" M4 | Optional | 1668 × 2420 | 2420 × 1668 |
| 10.9" iPad | iPad Air (4th/5th gen), iPad 10th gen | Optional | 1640 × 2360 | 2360 × 1640 |
| 10.5" iPad | iPad Air (3rd gen), iPad Pro 10.5" | Optional | 1668 × 2224 | 2224 × 1668 |
| 9.7" iPad | iPad (6th gen and earlier) | Optional (legacy) | 1536 × 2048 | 2048 × 1536 |

**Minimum required set for universal app:**
Upload 6.9" iPhone + 12.9" iPad screenshots.

---

## Notes

- Maximum **10 screenshots** per device slot
- Minimum **1 screenshot** required per slot you're submitting
- Apple uses the **first screenshot** as the search result preview — make it count
- Screenshots can be **portrait or landscape** regardless of app orientation, but must match your app's actual supported orientations if you show content
- **App Previews (video)**: up to 3 videos per slot; 15–30 seconds; must show actual gameplay/UI

---

## Status Bar Normalization (for manual screenshots)

Use Xcode Simulator → **Edit → Set Status Bar** to set:
- Time: **9:41 AM**
- Network: Full bars, WiFi connected
- Battery: 100%, not charging

Or use `SimulatorStatusMagic` / `fastlane snapshot` which handles this automatically.

---

## Tools

| Tool | Use |
|---|---|
| `fastlane snapshot` | Automated UI test-based screenshot capture |
| `fastlane frameit` | Add device frames and marketing copy to screenshots |
| AppLaunchpad | Web-based screenshot designer |
| Figma / Sketch | Manual composition with device mockups |
| Simulator screenshot | `xcrun simctl io booted screenshot screenshot.png` |
