//
//  TermsAgreementView.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 08/04/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI

// MARK: - TermsAgreementView

struct TermsAgreementView {
    @EnvironmentObject private var routerPath: SignupRouterPath
    @StateObject private var viewModel: TermsAgreementViewModel

    init() {
        _viewModel = StateObject(wrappedValue: TermsAgreementViewModel(session: SignupSession()))
    }
}

// MARK: - View

extension TermsAgreementView: View {
    var body: some View {
        ZStack {
            Color("SignupBackground")
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    termsSection
                    if let message = viewModel.errorMessage {
                        ErrorCalloutView(message: message)
                    }
                    createLoginButton
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
            if let accountType = routerPath.session.benefitAccountType {
                viewModel.terms = TermsItem.items(for: accountType)
            }
        }
    }
}

// MARK: - Subviews

extension TermsAgreementView {
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                routerPath.removeLast()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(Color("SignupPrimaryText"))
                    .font(.system(size: 18, weight: .semibold))
            }
            .accessibilityIdentifier("signup_terms_backButton")
            .adaptiveBottomPadding(8)

            Text(SignupStrings.termsTitle)
                .font(.systemBold(size: 24, adaptive: true))
                .foregroundStyle(Color("SignupPrimaryText"))

            Text(SignupStrings.termsSubtitle)
                .font(.systemRegular(size: 15, adaptive: true))
                .foregroundStyle(Color("SignupPrimaryText").opacity(0.8))
        }
    }

    private var termsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(viewModel.terms) { item in
                HStack(alignment: .top, spacing: 12) {
                    Button {
                        viewModel.toggle(item: item)
                    } label: {
                        Image(systemName: viewModel.checkedIds.contains(item.id)
                              ? "checkmark.square.fill"
                              : "square")
                            .foregroundStyle(viewModel.checkedIds.contains(item.id)
                                             ? Color("SignupAccent")
                                             : Color("SignupPrimaryText").opacity(0.6))
                            .font(.system(size: 22))
                    }
                    .accessibilityIdentifier("signup_terms_checkbox_\(item.id)")

                    Text(item.displayText)
                        .font(.systemRegular(size: 14, adaptive: true))
                        .foregroundStyle(Color("SignupPrimaryText"))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    private var createLoginButton: some View {
        Button {
            viewModel.acceptTerms { session in
                routerPath.session = session
                routerPath.navigate(to: .postSignupNotifications)
            }
        } label: {
            Text(SignupStrings.termsCreateLoginButton)
                .font(.systemBold(size: 18, adaptive: true))
                .foregroundStyle(Color("SignupBackground"))
                .frame(maxWidth: .infinity)
                .adaptiveFrame(height: 56)
                .background(viewModel.allChecked ? Color("SignupAccent") : Color.gray)
                .cornerRadius(12, corners: .allCorners)
        }
        .disabled(!viewModel.allChecked || viewModel.isLoading)
        .accessibilityIdentifier("signup_terms_createLoginButton")
    }
}

#Preview {
    NavigationStack {
        TermsAgreementView()
            .environmentObject(SignupRouterPath())
    }
}
