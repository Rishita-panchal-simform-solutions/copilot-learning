//
//  RefreshTokenResponse.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation
#warning("Replace it with your refreshToken response model")
struct RefreshTokenResponse: Codable {
    let apiRefreshToken, token: String
    let userID: Int
    enum CodingKeys: String, CodingKey {
        case apiRefreshToken, token
        case userID = "userId"
    }
}