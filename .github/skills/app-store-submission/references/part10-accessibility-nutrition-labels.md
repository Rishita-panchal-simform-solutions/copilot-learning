# Part 10 — Accessibility Nutrition Labels (2025)

## Overview

Accessibility Nutrition Labels are Apple's new framework for apps to self-declare their accessibility support — similar in concept to Privacy Nutrition Labels, but for accessibility features. As of 2025, these are becoming required for new App Store submissions.

**Key principle**: Declarations must be accurate. Apple verifies labels against actual app behavior during App Review. False declarations trigger Guideline 2.3 (Inaccurate Metadata) rejections.

---

## Label Categories

### Category 1 — Vision

| Label | What it means | Requirement to declare |
|-------|---------------|----------------------|
| VoiceOver | App is fully navigable with VoiceOver | All interactive elements have accessibility labels; reading order is logical; no traps |
| Dynamic Type | Text scales with user's preferred text size | Uses `UIFont.preferredFont(forTextStyle:)` or SwiftUI equivalents; layout adapts without clipping |
| Display & Text Size | Respects Bold Text, Larger Accessibility Sizes, Increase Contrast | Tested with all Display & Text Size settings enabled |
| Reduce Motion | App respects Reduce Motion setting | Animations suppressed or replaced when `UIAccessibility.isReduceMotionEnabled` |
| Color Filters | Usable under color blindness filters | No information conveyed by color alone |
| Differentiate Without Color | Alternative to color-only indicators | Icons, patterns, or labels supplement color coding |

### Category 2 — Hearing

| Label | What it means | Requirement to declare |
|-------|---------------|----------------------|
| Captions | Video/audio content has captions | All audio/video has accurate closed captions or subtitles |
| Audio Descriptions | Video has audio descriptions for visual content | Descriptive narration track available for video content |
| Mono Audio | Audio works correctly in mono | No critical audio information is stereo-only |

### Category 3 — Motor

| Label | What it means | Requirement to declare |
|-------|---------------|----------------------|
| Switch Control | App is fully navigable with Switch Control | Correct scan order; no unreachable interactive elements |
| Full Keyboard Access | App is fully navigable with a keyboard | All actions reachable via keyboard; no keyboard traps |
| Voice Control | App supports Voice Control navigation | All interactive elements have unique, descriptive labels |
| Pointer Control | Supports pointer devices (trackpad, mouse) | Interactive targets meet minimum size; hover states work |

### Category 4 — Cognitive

| Label | What it means | Requirement to declare |
|-------|---------------|----------------------|
| Guided Access | App works correctly under Guided Access | No critical functionality breaks when Guided Access restricts areas |

---

## How to Declare in App Store Connect

```
App Store Connect → Your App → App Information
→ Accessibility → Accessibility Nutrition Labels
→ Toggle on each category that applies
→ For each enabled category, confirm sub-features
```

Each label shows a brief description of what Apple expects. Read it before toggling.

---

## Verification Before Declaring

Run these checks for each label you intend to declare:

### VoiceOver Check
```
Settings → Accessibility → VoiceOver → On
Navigate through your entire app:
- Every button has a spoken label (not "button" or silent)
- Every image has a description or is marked decorative
- Every form field has a label
- No screens are unreachable
- Reading order is logical top-to-bottom, left-to-right
```

### Dynamic Type Check
```
Settings → Accessibility → Display & Text Size → Larger Text
Move slider to maximum (including accessibility sizes)
Check every screen:
- Text is not clipped or truncated
- Layout adapts (scrolls, wraps, or resizes)
- No text overlaps other elements
```

### Reduce Motion Check
```swift
// In your code — verify this is implemented:
if UIAccessibility.isReduceMotionEnabled {
    // Use instant transitions instead of animations
}

// Or in SwiftUI:
@Environment(\.accessibilityReduceMotion) var reduceMotion
```

### Full Keyboard Access Check
```
Settings → Accessibility → Keyboards → Full Keyboard Access → On
Navigate using Tab, arrow keys, Space/Return:
- Every interactive element is reachable
- Focus indicator is visible
- No keyboard focus traps
- Escape key dismisses modals
```

---

## Common Declaration Mistakes

| Mistake | Consequence | Fix |
|---------|-------------|-----|
| Declaring VoiceOver without testing all screens | Guideline 2.3 rejection if App Review finds issues | Test every screen with VoiceOver on a device |
| Declaring Dynamic Type but using fixed font sizes | Rejection; layout breaks at large sizes | Use `preferredFont(forTextStyle:)` throughout |
| Declaring Captions without actual caption tracks | Rejection | Add `.vtt` or `.srt` caption files to video assets |
| Declaring Color Filters but conveying status by color only | Rejection | Add icons or labels alongside color coding |
| Toggling all labels on to "look accessible" | Rejection after App Review testing | Only declare features you've verified |

---

## Minimum Viable Accessibility (if not ready for full labels)

If your app isn't ready to declare comprehensive accessibility support, the minimum Apple expects for any app (regardless of labels) is:

1. **No VoiceOver crashes** — app must not crash when VoiceOver is enabled
2. **Basic label coverage** — primary interactive elements have accessibility labels
3. **Dynamic Type partial support** — at minimum, text doesn't overflow containers at larger sizes
4. **Color contrast minimum** — 3:1 for large text, 4.5:1 for body text (WCAG AA)

---

## Integration with axiom-accessibility-diag

Run `axiom-accessibility-diag` to get a per-screen accessibility audit before declaring labels. The diagnostic identifies:

- Missing accessibility labels on interactive elements
- Elements with incorrect accessibility traits
- Dynamic Type failures at each size class
- Color contrast failures
- VoiceOver reading order issues

Use the diagnostic report to determine which labels your app legitimately supports, and to prioritize fixes before submission.

---

## Resources

- [Apple: Accessibility Nutrition Labels](https://developer.apple.com/accessibility/)
- WWDC 2025-241: Accessibility Nutrition Labels
- WWDC 2025-224: What's new in accessibility
- HIG: Accessibility — developer.apple.com/design/human-interface-guidelines/accessibility
