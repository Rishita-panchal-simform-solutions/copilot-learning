//
//  PostSignupNotificationsView.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 08/04/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
import UserNotifications

// MARK: - PostSignupNotificationsView

struct PostSignupNotificationsView {
    @EnvironmentObject private var routerPath: SignupRouterPath
    @State private var isLoading: Bool = false
}

// MARK: - View

extension PostSignupNotificationsView: View {
    var body: some View {
        ZStack {
            Color("SignupBackground")
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer()
                successBanner
                    .adaptiveBottomPadding(40)
                promptSection
                    .adaptiveBottomPadding(48)
                Spacer()
                actionButtons
                    .adaptiveBottomPadding(48)
            }
            .padding(.horizontal, 24)
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Subviews

extension PostSignupNotificationsView {
    private var successBanner: some View {
        Text(SignupStrings.notificationsTitle)
            .font(.systemBold(size: 22, adaptive: true))
            .foregroundStyle(Color("SignupAccent"))
            .multilineTextAlignment(.center)
            .accessibilityIdentifier("signup_notifications_successBanner")
    }

    private var promptSection: some View {
        Text(SignupStrings.notificationsPrompt)
            .font(.systemRegular(size: 18, adaptive: true))
            .foregroundStyle(Color("SignupPrimaryText"))
            .multilineTextAlignment(.center)
            .accessibilityIdentifier("signup_notifications_promptLabel")
    }

    private var actionButtons: some View {
        VStack(spacing: 16) {
            Button {
                requestNotificationsPermission()
            } label: {
                Text(SignupStrings.notificationsAgreeButton)
                    .font(.systemBold(size: 18, adaptive: true))
                    .foregroundStyle(Color("SignupBackground"))
                    .frame(maxWidth: .infinity)
                    .adaptiveFrame(height: 56)
                    .background(Color("SignupAccent"))
                    .cornerRadius(12, corners: .allCorners)
            }
            .accessibilityIdentifier("signup_notifications_agreeButton")

            Button {
                routerPath.session.notificationsEnabled = false
                routerPath.navigate(to: .postSignupBiometric)
            } label: {
                Text(SignupStrings.notificationsSkipButton)
                    .font(.systemRegular(size: 16, adaptive: true))
                    .foregroundStyle(Color("SignupPrimaryText").opacity(0.8))
                    .underline()
            }
            .accessibilityIdentifier("signup_notifications_skipButton")
        }
    }

    // MARK: - Private helpers

    private func requestNotificationsPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]
        ) { granted, _ in
            DispatchQueue.main.async {
                routerPath.session.notificationsEnabled = granted
                routerPath.navigate(to: .postSignupBiometric)
            }
        }
    }
}

#Preview {
    NavigationStack {
        PostSignupNotificationsView()
            .environmentObject(SignupRouterPath())
    }
}
