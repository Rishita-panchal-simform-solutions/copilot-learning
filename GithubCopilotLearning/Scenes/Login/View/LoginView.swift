//
//  LoginView.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
import SFSafeSymbols
// MARK: - variables
struct LoginView {
    @StateObject private var routerPath = OnboardingRouterPath()
    @State private var isSignupPresented = false
}
// MARK: - view
extension LoginView: View {
    var body: some View {
        NavigationStack(path: $routerPath.path) {
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                    .adaptiveFrame(height: 80)
                thumbView
                    .adaptiveBottomPadding(30)
                title
                    .adaptiveBottomPadding(30)
                descriptionView
                    .adaptiveBottomPadding(40)
                letsGo
                Spacer(minLength: 0)
                registerNow
                Spacer(minLength: 0)
            }
            .ignoresSafeArea(.all)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color.black)
            .onboardingWithAppRouter(routerPath)
        }
        .onboardingWithSheetDestinations($routerPath.presentedSheet)
        .fullScreenCover(isPresented: $isSignupPresented) {
            SignupFlowView()
        }
    }
}

// MARK: - Subviews
extension LoginView {
    private var thumbView: some View {
        Image(systemSymbol: .theatermasks)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(Color.white)
            .adaptiveFrame(width: 280, height: 280)
    }
    private var title: some View {
        Text(AppStrings.ourBestServices())
            .foregroundStyle(Color.white)
            .font(.systemBold(size: 23, adaptive: true))
    }
    private var descriptionView: some View {
        Text(AppStrings.loremIpsumDesc())
            .foregroundStyle(Color.white)
            .font(.systemRegular(size: 18, adaptive: true))
            .multilineTextAlignment(.center)
    }
    private var letsGo: some View {
        Button(action: {
            SwiftMessagesHelper.shared.showSnackBar(.message(text: AppStrings.testSnackBar()))
            routerPath.navigate(to: .dashboard(didUpatedata: HashableVoidCompletion(completion: {
                debugPrint("Hello Call Back from Dashboard")
            })))
        }, label: {
            Text(AppStrings.letsGo())
                .font(.systemBold(size: 20, adaptive: true))
                .foregroundStyle(.black)
        })
        .adaptiveFrame(width: 250, height: 60)
        .background(Color.white)
        .cornerRadius(12, corners: .allCorners)
    }
    private var registerNow: some View {
        Button {
            isSignupPresented = true
        } label: {
            HStack {
                Text(AppStrings.dontHaveAccount())
                    .font(.systemRegular(size: 15, adaptive: true))
                    .foregroundStyle(.white)
                Text(AppStrings.signup())
                    .font(.systemBold(size: 18, adaptive: true))
                    .foregroundStyle(.white)
            }
        }
        .accessibilityIdentifier("login_registerNow_button")
    }
}
#Preview {
    LoginView()
}
