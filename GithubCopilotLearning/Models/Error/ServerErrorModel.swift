//
//  ServerErrorModel.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation
/// Server error model
/// This model is used when server sends custom error in response from server side
class ServerErrorModel: Codable {
    let error: String
    let code: Int?
}