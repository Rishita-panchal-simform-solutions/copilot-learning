# Part 5 — Encryption Export Compliance

## Overview

The U.S. Export Administration Regulations (EAR) require disclosure of encryption use when distributing apps internationally. Apple surfaces this as a question during App Store submission. Getting it wrong can result in legal risk — not just App Store rejection.

---

## Decision Tree

### Step 1: Does your app use ANY encryption?

```
Does your app use encryption?
├── No encryption at all
│   └── → Answer: NO to "Does your app use encryption?"
│         Set ITSAppUsesNonExemptEncryption = false in Info.plist
│         Done — no further action required
│
└── Yes, encryption is used → continue to Step 2
```

### Step 2: What type of encryption?

```
What encryption does your app use?
│
├── ONLY Apple's built-in encryption (HTTPS/TLS via URLSession,
│   WKWebView, NSURLConnection, or Apple frameworks)
│   └── → EXEMPT. Answer: NO to "Does your app use encryption?"
│         Set ITSAppUsesNonExemptEncryption = false
│         Done — Apple's frameworks are covered by their own ERN
│
├── Encryption solely for authentication (login, password storage)
│   and NOT for confidentiality of data at rest/transit beyond auth
│   └── → Likely EXEMPT under EAR §740.17(b)(3)(i)
│         Consult legal counsel if uncertain
│         Set ITSAppUsesNonExemptEncryption = false if exempt
│
├── Custom cryptography or crypto libraries (OpenSSL, libsodium,
│   CryptoSwift, custom AES/RSA implementation, etc.)
│   └── → NON-EXEMPT → continue to Step 3
│
└── End-to-end encryption, VPN, or key management systems
    └── → NON-EXEMPT → continue to Step 3
```

### Step 3: Eligible for mass-market exemption?

```
Is your app a mass-market product with encryption ≤ 64-bit key?
├── Yes → May qualify for EAR §740.17(b)(3) mass market
│         File annual self-classification report with BIS
│         Set ITSAppUsesNonExemptEncryption = true
│         Obtain ERN (Encryption Registration Number)
│
└── No (strong encryption: AES-256, RSA-2048+, etc.)
    └── → ERN required before shipping internationally
          Contact BIS or legal counsel for classification
          Set ITSAppUsesNonExemptEncryption = true after ERN
```

---

## Most Common Case (>90% of apps)

**You use HTTPS and Apple frameworks only.**

```xml
<!-- Add to Info.plist -->
<key>ITSAppUsesNonExemptEncryption</key>
<false/>
```

This suppresses the encryption question in App Store Connect and declares you use only exempt encryption. If you use `URLSession`, `WKWebView`, `SwiftUI.AsyncImage`, Firebase, or any SDK that communicates over HTTPS — this is your answer.

---

## Info.plist Setting

```xml
<!-- In your app's Info.plist -->

<!-- If exempt (most apps): -->
<key>ITSAppUsesNonExemptEncryption</key>
<false/>

<!-- If non-exempt (you use custom crypto + have ERN): -->
<key>ITSAppUsesNonExemptEncryption</key>
<true/>
<key>ITSEncryptionExportComplianceCode</key>
<string>YOUR-ERN-CODE-HERE</string>
```

Setting `ITSAppUsesNonExemptEncryption = false` in `Info.plist` means App Store Connect won't ask you this question at submission time — it's already answered in the build.

---

## ERN (Encryption Registration Number)

If you need an ERN:

1. Go to [bis.doc.gov](https://www.bis.doc.gov) → SNAP-R system
2. File an Encryption Registration (ENC) or self-classification report
3. Receive your ERN
4. Add it to `Info.plist` under `ITSEncryptionExportComplianceCode`
5. Answer YES to the encryption question in App Store Connect

ERNs are tied to your legal entity, not individual apps. One ERN can cover multiple apps using the same encryption technology.

---

## Common Mistakes

| Mistake | Risk | Fix |
|---------|------|-----|
| Saying "No" when using custom crypto | Legal exposure (EAR violation) | Use the decision tree honestly |
| Saying "Yes" when only using HTTPS | Unnecessary friction, may flag for review | Set `ITSAppUsesNonExemptEncryption = false` |
| Not setting Info.plist key | Prompted at every submission | Set it once in Info.plist |
| Assuming an SDK is exempt | SDKs using custom crypto make YOUR app non-exempt | Check each SDK's encryption disclosure |

---

## SDK Examples

| SDK | Encryption type | Exempt? |
|-----|----------------|---------|
| Firebase (Firestore, Auth) | HTTPS/TLS only | ✅ Exempt |
| AWS Amplify | HTTPS/TLS only | ✅ Exempt |
| Signal Protocol SDK | End-to-end encryption | ❌ Non-exempt |
| OpenSSL / libsodium | Custom crypto | ❌ Non-exempt |
| CryptoKit (Apple) | Apple framework | ✅ Exempt |
| CommonCrypto (Apple) | Apple framework | ✅ Exempt |

---

## Legal Disclaimer

This reference provides general guidance only. Encryption export regulations are legal matters. When in doubt — especially for apps with custom cryptography, VPN functionality, or strong key management — consult qualified legal counsel before submitting internationally.
