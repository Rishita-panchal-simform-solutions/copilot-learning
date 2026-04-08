//
//  SignupLookupResponse.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 08/04/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation

struct SignupLookupResponse: Codable {
    let accountStatus: AccountStatus
    let employerName: String?
    let maskedEmail: String?
    let accountStartDate: String?
    let benefitAccountType: BenefitAccountType?
}
