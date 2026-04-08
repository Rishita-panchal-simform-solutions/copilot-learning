//
//  VerifyIdentityView.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 08/04/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI

// MARK: - VerifyIdentityView

struct VerifyIdentityView {
    @EnvironmentObject private var routerPath: SignupRouterPath
    @StateObject private var viewModel: VerifyIdentityViewModel

    init() {
        // ViewModel is fully initialised in onAppear once routerPath is available.
        // Provide a placeholder session; real session is injected in onAppear.
        _viewModel = StateObject(wrappedValue: VerifyIdentityViewModel(session: SignupSession()))
    }
}

// MARK: - View

extension VerifyIdentityView: View {
    var body: some View {
        ZStack {
            Color("SignupBackground")
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    employerSection
                    otpField
                    if let message = viewModel.errorMessage {
                        ErrorCalloutView(message: message)
                    }
                    verifyButton
                    resendSection
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

extension VerifyIdentityView {
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                routerPath.removeLast()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(Color("SignupPrimaryText"))
                    .font(.system(size: 18, weight: .semibold))
            }
            .accessibilityIdentifier("signup_verifyIdentity_backButton")
            .adaptiveBottomPadding(8)

            Text(SignupStrings.verifyIdentityTitle)
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
                .accessibilityIdentifier("signup_verifyIdentity_contactUsButton")
            }
        }
    }

    private var employerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let employer = routerPath.session.employerName {
                Text(employer)
                    .font(.systemBold(size: 16, adaptive: true))
                    .foregroundStyle(Color("SignupPrimaryText"))
            }
            let masked = routerPath.session.maskedEmail ?? ""
            Text(String(format: SignupStrings.verifyIdentityOtpLabel, masked))
                .font(.systemRegular(size: 14, adaptive: true))
                .foregroundStyle(Color("SignupPrimaryText").opacity(0.8))
                .accessibilityIdentifier("signup_verifyIdentity_maskedEmailLabel")
        }
    }

    private var otpField: some View {
        VStack(alignment: .leading, spacing: 6) {
            TextField("------", text: $viewModel.otpCode)
                .keyboardType(.numberPad)
                .font(.systemBold(size: 24, adaptive: true))
                .multilineTextAlignment(.center)
                .onChange(of: viewModel.otpCode) { _, newValue in
                    viewModel.otpCode = String(newValue.prefix(6).filter(\.isNumber))
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(8, corners: .allCorners)
                .foregroundStyle(Color("SignupPrimaryText"))
                .accessibilityIdentifier("signup_verifyIdentity_otpField")
        }
    }

    private var verifyButton: some View {
        Button {
//            viewModel.verify { session in
//                routerPath.session = session
//                routerPath.navigate(to: .createPassword)
//            }
            routerPath.navigate(to: .createPassword)
        } label: {
            Text(SignupStrings.verifyIdentityVerifyButton)
                .font(.systemBold(size: 18, adaptive: true))
                .foregroundStyle(Color("SignupBackground"))
                .frame(maxWidth: .infinity)
                .adaptiveFrame(height: 56)
                .background(viewModel.otpCode.count == 6 ? Color("SignupAccent") : Color.gray)
                .cornerRadius(12, corners: .allCorners)
        }
        .disabled(viewModel.otpCode.count != 6 || viewModel.isLoading)
        .accessibilityIdentifier("signup_verifyIdentity_verifyButton")
    }

    private var resendSection: some View {
        HStack {
            Spacer()
            if viewModel.isResendEnabled {
                Button(SignupStrings.verifyIdentityResendButton) {
                    viewModel.resend()
                }
                .font(.systemRegular(size: 15, adaptive: true))
                .foregroundStyle(Color("SignupAccent"))
                .accessibilityIdentifier("signup_verifyIdentity_resendButton")
            } else {
                Text(String(format: SignupStrings.verifyIdentityResendCooldown, viewModel.resendCooldownSeconds))
                    .font(.systemRegular(size: 15, adaptive: true))
                    .foregroundStyle(Color("SignupPrimaryText").opacity(0.6))
                    .accessibilityIdentifier("signup_verifyIdentity_resendCountdown")
            }
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        VerifyIdentityView()
            .environmentObject(SignupRouterPath())
    }
}
