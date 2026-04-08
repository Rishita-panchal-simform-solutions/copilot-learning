//
//  VerifyIdentityViewModel.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 08/04/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation
import Combine

// MARK: - VerifyIdentityViewModel

@MainActor
class VerifyIdentityViewModel: ObservableObject {

    // MARK: - Published properties

    @Published var otpCode: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var resendCooldownSeconds: Int = 0

    // MARK: - State

    var session: SignupSession

    var isResendEnabled: Bool {
        resendCooldownSeconds == 0
    }

    // MARK: - Private

    private var countdownCancellable: AnyCancellable?

    // MARK: - Init

    init(session: SignupSession) {
        self.session = session
    }

    // MARK: - API

    /// Verifies the 6-digit code the user entered.
    func verify(onSuccess: @escaping (SignupSession) -> Void) {
        guard ReachabilityManager.shared.isNetworkReachable else {
            errorMessage = CustomError.noInternet.localizedDescription
            return
        }
        let request = OTPVerificationRequest(workEmail: session.workEmail, code: otpCode)
        isLoading = true
        errorMessage = nil

        APITarget.signupVerifyOTP(request: request)
            .request(type: BaseResponseModel<OTPVerificationResponse>.self) { [weak self] result in
                guard let self else { return }
                self.isLoading = false
                switch result {
                case .success(let response):
                    if response.status, response.result?.verified == true {
                        self.session.otpValidated = true
                        onSuccess(self.session)
                    } else {
                        self.errorMessage = SignupStrings.verifyIdentityErrorInvalidCode
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
    }

    /// Requests a new OTP code and starts the 60-second client-side cooldown.
    func resend() {
        guard ReachabilityManager.shared.isNetworkReachable else {
            errorMessage = CustomError.noInternet.localizedDescription
            return
        }
        let request = ResendOTPRequest(workEmail: session.workEmail)
        isLoading = true
        errorMessage = nil

        APITarget.signupResendOTP(request: request)
            .request(type: BaseResponseModel<OTPVerificationResponse>.self) { [weak self] result in
                guard let self else { return }
                self.isLoading = false
                switch result {
                case .success(let response) where response.status:
                    self.startResendCooldown()
                case .success(let response):
                    self.errorMessage = response.message
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
    }

    // MARK: - Private helpers

    private func startResendCooldown() {
        resendCooldownSeconds = Constants.Signup.otpResendCooldownSeconds
        countdownCancellable?.cancel()
        countdownCancellable = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                if self.resendCooldownSeconds > 0 {
                    self.resendCooldownSeconds -= 1
                } else {
                    self.countdownCancellable?.cancel()
                }
            }
    }
}
