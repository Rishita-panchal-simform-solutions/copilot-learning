//
//  CreatePasswordView.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 08/04/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI

// MARK: - CreatePasswordView

struct CreatePasswordView {
    @EnvironmentObject private var routerPath: SignupRouterPath
    @StateObject private var viewModel: CreatePasswordViewModel

    init() {
        _viewModel = StateObject(wrappedValue: CreatePasswordViewModel(session: SignupSession()))
    }
}

// MARK: - View

extension CreatePasswordView: View {
    var body: some View {
        ZStack {
            Color("SignupBackground")
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    emailField
                    passwordField
                    validationRules
                    if let message = viewModel.errorMessage {
                        ErrorCalloutView(message: message)
                    }
                    nextButton
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 24)
                .padding(.top, 32)
            }
            if viewModel.isLoading {
                LoadingOverlayView()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.session = routerPath.session
        }
    }
}

// MARK: - Subviews

extension CreatePasswordView {
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                routerPath.removeLast()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(Color("SignupPrimaryText"))
                    .font(.system(size: 18, weight: .semibold))
            }
            .accessibilityIdentifier("signup_createPassword_backButton")
            .adaptiveBottomPadding(8)

            let firstName = routerPath.session.employerName ?? ""
            Text("Hi \(firstName)! \(SignupStrings.createPasswordTitle)")
                .font(.systemBold(size: 24, adaptive: true))
                .foregroundStyle(Color("SignupPrimaryText"))

            HStack {
                Spacer()
                Button(SignupStrings.personalInfoContactUs) {
                    let email = Constants.Signup.supportEmail
                    guard let url = URL(string: "mailto:\(email)"),
                          UIApplication.shared.canOpenURL(url) else { return }
                    UIApplication.shared.open(url)
                }
                .font(.systemRegular(size: 14, adaptive: true))
                .foregroundStyle(Color("SignupAccent"))
                .accessibilityIdentifier("signup_createPassword_contactUsButton")
            }
        }
    }

    private var emailField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(SignupStrings.createPasswordFieldLabel)
                .font(.systemRegular(size: 14, adaptive: true))
                .foregroundStyle(Color("SignupPrimaryText"))
            Text(routerPath.session.workEmail)
                .font(.systemRegular(size: 16, adaptive: true))
                .foregroundStyle(Color("SignupPrimaryText").opacity(0.7))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.05))
                .cornerRadius(8, corners: .allCorners)
                .accessibilityIdentifier("signup_createPassword_emailDisplay")
        }
    }

    private var passwordField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(SignupStrings.createPasswordInputLabel)
                .font(.systemRegular(size: 14, adaptive: true))
                .foregroundStyle(Color("SignupPrimaryText"))
            HStack {
                if viewModel.isPasswordVisible {
                    TextField("", text: $viewModel.password)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .accessibilityIdentifier("signup_createPassword_passwordField")
                } else {
                    SecureField("", text: $viewModel.password)
                        .accessibilityIdentifier("signup_createPassword_passwordField")
                }
                Button {
                    viewModel.isPasswordVisible.toggle()
                } label: {
                    Image(systemName: viewModel.isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundStyle(Color("SignupPrimaryText").opacity(0.7))
                }
                .accessibilityIdentifier("signup_createPassword_eyeToggle")
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(8, corners: .allCorners)
            .foregroundStyle(Color("SignupPrimaryText"))
        }
    }

    private var validationRules: some View {
        VStack(alignment: .leading, spacing: 8) {
            PasswordRuleRowView(
                label: SignupStrings.createPasswordRuleUppercase,
                isSatisfied: viewModel.validationState.hasUppercase
            )
            PasswordRuleRowView(
                label: SignupStrings.createPasswordRuleLowercase,
                isSatisfied: viewModel.validationState.hasLowercase
            )
            PasswordRuleRowView(
                label: SignupStrings.createPasswordRuleNumber,
                isSatisfied: viewModel.validationState.hasNumber
            )
            PasswordRuleRowView(
                label: SignupStrings.createPasswordRuleLength,
                isSatisfied: viewModel.validationState.hasMinLength
            )
        }
    }

    private var nextButton: some View {
        Button {
//            viewModel.createPassword { session in
//                routerPath.session = session
//                routerPath.navigate(to: .termsAgreement)
//            }
            routerPath.navigate(to: .termsAgreement)
        } label: {
            Text(SignupStrings.createPasswordNextButton)
                .font(.systemBold(size: 18, adaptive: true))
                .foregroundStyle(Color("SignupBackground"))
                .frame(maxWidth: .infinity)
                .adaptiveFrame(height: 56)
                .background(viewModel.validationState.allSatisfied ? Color("SignupAccent") : Color.gray)
                .cornerRadius(12, corners: .allCorners)
        }
        .disabled(!viewModel.validationState.allSatisfied || viewModel.isLoading)
        .accessibilityIdentifier("signup_createPassword_nextButton")
    }
}

#Preview {
    NavigationStack {
        CreatePasswordView()
            .environmentObject(SignupRouterPath())
    }
}
