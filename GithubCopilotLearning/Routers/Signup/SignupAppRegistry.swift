//
//  SignupAppRegistry.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 08/04/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI

// MARK: - Signup navigation destinations

@MainActor
extension View {
    func signupWithAppRouter<T>(_ router: T) -> some View where T: AnyObject, T: ObservableObject {
        navigationDestination(for: SignupRouterDestination.self) { destination in
            Group {
                switch destination {
                case .welcome:
                    WelcomeView()
                case .personalInfo:
                    PersonalInfoView()
                case .verifyIdentity:
                    VerifyIdentityView()
                case .createPassword:
                    CreatePasswordView()
                case .termsAgreement:
                    TermsAgreementView()
                case .postSignupNotifications:
                    PostSignupNotificationsView()
                case .postSignupBiometric:
                    PostSignupBiometricView()
                }
            }
            .environmentObject(router)
        }
    }
}
