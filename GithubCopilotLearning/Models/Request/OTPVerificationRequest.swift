//
//  OTPVerificationRequest.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 08/04/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation

public struct OTPVerificationRequest: Codable {
    let workEmail: String
    let code: String
}
