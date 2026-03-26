//
//  NetworkRepo.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import NetworkEngine
/// Defines the available network calls with their input types
protocol NetworkRepo: TargetType & NetworkRequestable {
    static func refreshToken(request: RefreshTokenRequest) -> Self
    static func randomUser(request: UserListRequest) -> Self
}