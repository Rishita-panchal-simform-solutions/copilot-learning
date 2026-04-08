//
//  SignupSession.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 08/04/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation

// MARK: - BenefitAccountType

enum BenefitAccountType: String, Codable {
    case hsaOnly   = "HSA"
    case fsaOnly   = "FSA"
    case dcfsaOnly = "DCFSA"
    case hsaAndFsa = "HSA_FSA"
}

// MARK: - AccountStatus

enum AccountStatus: String, Codable {
    case found       = "FOUND"
    case notReady    = "NOT_READY"
    case duplicate   = "DUPLICATE"
    case hsaNotFound = "HSA_NOT_FOUND"
}

// MARK: - SignupSession

/// Holds all transient state collected across the multi-step signup flow.
/// This struct is in-memory only and is never written to disk, Keychain, or
/// UserDefaults. Force-quitting the app discards all state.
struct SignupSession {
    // Personal Info step
    var ssnLast4: String = ""
    var dateOfBirth: Date = Date()
    var workEmail: String = ""

    // Returned from account-lookup
    var employerName: String?
    var maskedEmail: String?
    var benefitAccountType: BenefitAccountType?

    // OTP step
    var otpValidated: Bool = false

    // Password step
    var password: String = ""
    var userId: String?

    // Terms step
    var acceptedTerms: [String] = []

    // Post-signup optional steps
    var notificationsEnabled: Bool?
    var biometricSetup: Bool?
}
