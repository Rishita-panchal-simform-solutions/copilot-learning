//
//  TermsAcceptanceRequest.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 08/04/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation

public struct TermsAcceptanceRequest: Codable {
    let userId: String
    let acceptedTerms: [String]
}
