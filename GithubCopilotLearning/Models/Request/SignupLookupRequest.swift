//
//  SignupLookupRequest.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 08/04/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation

public struct SignupLookupRequest: Codable {
    let ssnLast4: String
    let dateOfBirth: String
    let workEmail: String
}
