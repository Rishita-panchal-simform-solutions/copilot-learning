//
//  PostSignupBiometricView.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 08/04/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
import LocalAuthentication

// MARK: - PostSignupBiometricView

struct PostSignupBiometricView {
    @EnvironmentObject private var routerPath: SignupRouterPath
    @State private var biometryType: LABiometryType = .none
    @Environment(\.dismiss) private var dismiss
}

// MARK: - View

extension PostSignupBiometricView: View {
    var body: some View {
        ZStack {
            Color("SignupBackground")
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer()
                promptSection
                    .adaptiveBottomPadding(48)
                Spacer()
                actionButtons
                    .adaptiveBottomPadding(48)
            }
            .padding(.horizontal, 24)
        }
        .navigationBarHidden(true)
        .onAppear { detectBiometryType() }
    }
}

// MARK: - Subviews

extension PostSignupBiometricView {
    private var promptSection: some View {
        Text(biometricPrompt)
            .font(.systemRegular(size: 18, adaptive: true))
            .foregroundStyle(Color("SignupPrimaryText"))
            .multilineTextAlignment(.center)
            .accessibilityIdentifier("signup_biometric_promptLabel")
    }

    private var actionButtons: some View {
        VStack(spacing: 16) {
            if biometryType != .none {
                Button {
                    setupBiometrics()
                } label: {
                    Text(setupButtonLabel)
                        .font(.systemBold(size: 18, adaptive: true))
                        .foregroundStyle(Color("SignupBackground"))
                        .frame(maxWidth: .infinity)
                        .adaptiveFrame(height: 56)
                        .background(Color("SignupAccent"))
                        .cornerRadius(12, corners: .allCorners)
                }
                .accessibilityIdentifier("signup_biometric_setupButton")
            }

            Button {
                completeSignup(biometricSetup: false)
            } label: {
                Text(SignupStrings.biometricSkipButton)
                    .font(.systemRegular(size: 16, adaptive: true))
                    .foregroundStyle(Color("SignupPrimaryText").opacity(0.8))
                    .underline()
            }
            .accessibilityIdentifier("signup_biometric_skipButton")
        }
    }

    // MARK: - Computed

    private var biometricPrompt: String {
        switch biometryType {
        case .faceID:
            return SignupStrings.biometricPromptFaceID
        case .touchID:
            return SignupStrings.biometricPromptTouchID
        default:
            return SignupStrings.biometricPromptFaceID
        }
    }

    private var setupButtonLabel: String {
        switch biometryType {
        case .faceID:
            return SignupStrings.biometricSetupFaceIDButton
        case .touchID:
            return SignupStrings.biometricSetupTouchIDButton
        default:
            return SignupStrings.biometricSetupFaceIDButton
        }
    }

    // MARK: - Private helpers

    private func detectBiometryType() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            biometryType = context.biometryType
        }
    }

    private func setupBiometrics() {
        let context = LAContext()
        let reason = "Set up biometric login for InComm Benefits"
        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: reason
        ) { success, _ in
            DispatchQueue.main.async {
                completeSignup(biometricSetup: success)
            }
        }
    }

    private func completeSignup(biometricSetup: Bool) {
        routerPath.session.biometricSetup = biometricSetup
        // Pop the entire signup stack to return to the main app experience.
        dismiss()
    }
}

#Preview {
    NavigationStack {
        PostSignupBiometricView()
            .environmentObject(SignupRouterPath())
    }
}
