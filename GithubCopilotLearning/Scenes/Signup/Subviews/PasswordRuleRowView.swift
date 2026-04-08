//
//  PasswordRuleRowView.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 08/04/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI

// MARK: - PasswordRuleRowView

/// Reusable row showing a coloured circle indicator + rule label.
/// Green fill = rule satisfied; red fill = rule not yet satisfied.
struct PasswordRuleRowView: View {
    let label: String
    let isSatisfied: Bool

    var body: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(isSatisfied ? Color("SignupAccent") : Color("SignupError"))
                .frame(width: 12, height: 12)
                .accessibilityHidden(true)
            Text(label)
                .font(.systemRegular(size: 14, adaptive: true))
                .foregroundStyle(Color("SignupPrimaryText"))
            Spacer()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(isSatisfied ? "satisfied" : "not satisfied")")
    }
}

#Preview {
    VStack(spacing: 8) {
        PasswordRuleRowView(label: "At least one capital letter", isSatisfied: true)
        PasswordRuleRowView(label: "At least one number", isSatisfied: false)
    }
    .padding()
    .background(Color("SignupBackground"))
}
