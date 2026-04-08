//
//  PersonalInfoView.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 08/04/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI

// MARK: - PersonalInfoView

struct PersonalInfoView {
    @StateObject private var viewModel = PersonalInfoViewModel()
    @EnvironmentObject private var routerPath: SignupRouterPath
}

// MARK: - View

extension PersonalInfoView: View {
    var body: some View {
        ZStack {
            Color("SignupBackground")
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    formSection
                    if let message = viewModel.errorMessage {
                        ErrorCalloutView(
                            message: message,
                            ctaLabel: viewModel.ctaLabel,
                            ctaAction: viewModel.ctaAction
                        )
                    }
                    submitButton
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
    }
}

// MARK: - Subviews

extension PersonalInfoView {
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                routerPath.removeLast()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(Color("SignupPrimaryText"))
                    .font(.system(size: 18, weight: .semibold))
            }
            .accessibilityIdentifier("signup_personalInfo_backButton")
            .adaptiveBottomPadding(8)

            Text(SignupStrings.personalInfoTitle)
                .font(.systemBold(size: 24, adaptive: true))
                .foregroundStyle(Color("SignupPrimaryText"))

            HStack {
                Spacer()
                Button(SignupStrings.personalInfoContactUs) {
                    viewModel.openContactUs()
                }
                .font(.systemRegular(size: 14, adaptive: true))
                .foregroundStyle(Color("SignupAccent"))
                .accessibilityIdentifier("signup_personalInfo_contactUsButton")
            }
        }
    }

    private var formSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            ssnField
            dobField
            emailField
        }
    }

    private var ssnField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(SignupStrings.personalInfoSsnLabel)
                .font(.systemRegular(size: 14, adaptive: true))
                .foregroundStyle(Color("SignupPrimaryText"))
            TextField("", text: $viewModel.ssnLast4)
                .keyboardType(.numberPad)
                .onChange(of: viewModel.ssnLast4) { _, newValue in
                    if newValue.count > 4 {
                        viewModel.ssnLast4 = String(newValue.prefix(4))
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(8, corners: .allCorners)
                .foregroundStyle(Color("SignupPrimaryText"))
                .accessibilityIdentifier("signup_personalInfo_ssnField")
        }
    }

    private var dobField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(SignupStrings.personalInfoDobLabel)
                .font(.systemRegular(size: 14, adaptive: true))
                .foregroundStyle(Color("SignupPrimaryText"))
            DatePicker(
                "",
                selection: $viewModel.dateOfBirth,
                in: ...Date(),
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .labelsHidden()
            .colorScheme(.dark)
            .accessibilityIdentifier("signup_personalInfo_dobPicker")
        }
    }

    private var emailField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(SignupStrings.personalInfoEmailLabel)
                .font(.systemRegular(size: 14, adaptive: true))
                .foregroundStyle(Color("SignupPrimaryText"))
            TextField("", text: $viewModel.workEmail)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(8, corners: .allCorners)
                .foregroundStyle(Color("SignupPrimaryText"))
                .accessibilityIdentifier("signup_personalInfo_emailField")
        }
    }

    private var submitButton: some View {
        Button {
//            viewModel.submitPersonalInfo { [self] session in
//                routerPath.session = session
//                routerPath.navigate(to: .verifyIdentity)
//            } onDuplicate: {
//                routerPath.popToRoot()
//            }
            routerPath.navigate(to: .verifyIdentity)
        } label: {
            Text(SignupStrings.personalInfoSubmitButton)
                .font(.systemBold(size: 18, adaptive: true))
                .foregroundStyle(Color("SignupBackground"))
                .frame(maxWidth: .infinity)
                .adaptiveFrame(height: 56)
                .background(viewModel.isFormValid ? Color("SignupAccent") : Color.gray)
                .cornerRadius(12, corners: .allCorners)
        }
        .disabled(!viewModel.isFormValid || viewModel.isLoading)
        .accessibilityIdentifier("signup_personalInfo_submitButton")
    }
}

#Preview {
    NavigationStack {
        PersonalInfoView()
            .environmentObject(SignupRouterPath())
    }
}
