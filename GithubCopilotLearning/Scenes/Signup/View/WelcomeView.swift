//
//  WelcomeView.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 08/04/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI

// MARK: - WelcomeView

struct WelcomeView {
    @EnvironmentObject private var routerPath: SignupRouterPath
}

// MARK: - View

extension WelcomeView: View {
    var body: some View {
        ZStack {
            Color("SignupBackground")
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer()
                titleSection
                    .adaptiveBottomPadding(48)
                signUpButton
                    .adaptiveBottomPadding(24)
                Spacer()
                logInLink
                    .adaptiveBottomPadding(32)
            }
            .padding(.horizontal, 24)
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Subviews

extension WelcomeView {
    private var titleSection: some View {
        VStack(spacing: 12) {
            Text(SignupStrings.welcomeTitle)
                .font(.systemBold(size: 28, adaptive: true))
                .foregroundStyle(Color("SignupPrimaryText"))
                .multilineTextAlignment(.center)
        }
    }

    private var signUpButton: some View {
        Button {
            routerPath.navigate(to: .personalInfo)
        } label: {
            Text(SignupStrings.welcomeSignUpButton)
                .font(.systemBold(size: 18, adaptive: true))
                .foregroundStyle(Color("SignupBackground"))
                .frame(maxWidth: .infinity)
                .adaptiveFrame(height: 56)
                .background(Color("SignupAccent"))
                .cornerRadius(12, corners: .allCorners)
        }
        .accessibilityIdentifier("signup_welcome_signUpButton")
    }

    private var logInLink: some View {
        Button {
            routerPath.popToRoot()
        } label: {
            Text(SignupStrings.welcomeLogInPrompt)
                .font(.systemRegular(size: 16, adaptive: true))
                .foregroundStyle(Color("SignupPrimaryText"))
                .underline()
        }
        .accessibilityIdentifier("signup_welcome_logInLink")
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
            .environmentObject(SignupRouterPath())
    }
}
