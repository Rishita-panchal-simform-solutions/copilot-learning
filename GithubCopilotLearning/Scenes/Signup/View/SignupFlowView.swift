//
//  SignupFlowView.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 08/04/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI

// MARK: - SignupFlowView

/// Root container for the signup navigation stack.
/// Owns the `SignupRouterPath` and injects it into the environment
/// for all child views.
struct SignupFlowView: View {
    @StateObject private var routerPath = SignupRouterPath()

    var body: some View {
        NavigationStack(path: $routerPath.path) {
            WelcomeView()
                .signupWithAppRouter(routerPath)
        }
        .environmentObject(routerPath)
    }
}

#Preview {
    SignupFlowView()
}
