//
//  ErrorCalloutView.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 08/04/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI

// MARK: - ErrorCalloutView

/// Inline banner that surfaces a server or validation error message.
/// Accepts an optional CTA button (label + action) for actionable errors
/// such as "Go to Login" on the duplicate-account callout.
struct ErrorCalloutView: View {
    let message: String
    var ctaLabel: String?
    var ctaAction: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(message)
                .font(.systemRegular(size: 14, adaptive: true))
                .foregroundStyle(Color("SignupPrimaryText"))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let label = ctaLabel, let action = ctaAction {
                Button(action: action) {
                    Text(label)
                        .font(.systemBold(size: 14, adaptive: true))
                        .foregroundStyle(Color("SignupPrimaryText"))
                        .underline()
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color("SignupError").opacity(0.85))
        .cornerRadius(8, corners: .allCorners)
    }
}

#Preview {
    VStack(spacing: 16) {
        ErrorCalloutView(message: "The code you entered is invalid. Please try again.")
        ErrorCalloutView(
            message: "It looks like you already have an account.",
            ctaLabel: "Go to Login",
            ctaAction: {}
        )
    }
    .padding()
    .background(Color("SignupBackground"))
}
