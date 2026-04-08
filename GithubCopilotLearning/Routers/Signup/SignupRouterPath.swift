//
//  SignupRouterPath.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 08/04/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI

// MARK: - SignupRouterDestination

enum SignupRouterDestination: Hashable {
    case welcome
    case personalInfo
    case verifyIdentity
    case createPassword
    case termsAgreement
    case postSignupNotifications
    case postSignupBiometric
}

// MARK: - SignupRouterPath

@MainActor
class SignupRouterPath: ObservableObject {
    @Published var path: [SignupRouterDestination] = []
    @Published var session: SignupSession = SignupSession()

    init() {}

    func navigate(to destination: SignupRouterDestination) {
        path.append(destination)
    }

    /// Remove the last `count` routes from the navigation path.
    func removeLast(_ count: Int = 1) {
        guard path.count >= count else { return }
        path.removeLast(count)
    }

    func popToRoot() {
        path.removeAll()
    }
}
