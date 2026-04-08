//
//  TermsItem.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 08/04/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation

// MARK: - Agreement document identifiers

enum TermsItemID {
    static let eSIGN        = "ESIGN"
    static let privacyPolicy = "PRIVACY_POLICY"
    static let hsaAgreement  = "HSA_AGREEMENT"
    static let ccbCardholder = "CCB_CARDHOLDER"
    static let ccbPrivacy    = "CCB_PRIVACY"
    static let fsaCertification = "FSA_CERTIFICATION"
}

// MARK: - TermsItem

struct TermsItem: Identifiable {
    let id: String
    let displayText: String
    let documentURL: URL?

    // MARK: - Factory

    /// Returns the correct agreement set for a given benefit account type.
    static func items(for accountType: BenefitAccountType) -> [TermsItem] {
        switch accountType {
        case .hsaOnly:
            return [eSIGN, privacyPolicy, hsaAgreement]
        case .fsaOnly:
            return [privacyPolicy, ccbCardholder, fsaCertification]
        case .dcfsaOnly:
            return [privacyPolicy, ccbPrivacy]
        case .hsaAndFsa:
            return [eSIGN, privacyPolicy, hsaAgreement, fsaCertification]
        }
    }

    // MARK: - Static instances

    static let eSIGN = TermsItem(
        id: TermsItemID.eSIGN,
        displayText: SignupStrings.termsESIGN,
        documentURL: nil
    )
    static let privacyPolicy = TermsItem(
        id: TermsItemID.privacyPolicy,
        displayText: SignupStrings.termsPrivacyPolicy,
        documentURL: nil
    )
    static let hsaAgreement = TermsItem(
        id: TermsItemID.hsaAgreement,
        displayText: SignupStrings.termsCCBHSA,
        documentURL: nil
    )
    static let ccbCardholder = TermsItem(
        id: TermsItemID.ccbCardholder,
        displayText: SignupStrings.termsCCBCardholder,
        documentURL: nil
    )
    static let ccbPrivacy = TermsItem(
        id: TermsItemID.ccbPrivacy,
        displayText: SignupStrings.termsCCBPrivacy,
        documentURL: nil
    )
    static let fsaCertification = TermsItem(
        id: TermsItemID.fsaCertification,
        displayText: SignupStrings.termsFSACertification,
        documentURL: nil
    )
}
