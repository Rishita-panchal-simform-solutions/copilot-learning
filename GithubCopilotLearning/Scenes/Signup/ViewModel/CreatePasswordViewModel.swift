//
//  CreatePasswordViewModel.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 08/04/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation

// MARK: - PasswordValidationState

struct PasswordValidationState {
    var hasUppercase: Bool
    var hasLowercase: Bool
    var hasNumber: Bool
    var hasMinLength: Bool

    var allSatisfied: Bool {
        hasUppercase && hasLowercase && hasNumber && hasMinLength
    }

    static let empty = PasswordValidationState(
        hasUppercase: false,
        hasLowercase: false,
        hasNumber: false,
        hasMinLength: false
    )

    static func evaluate(_ password: String) -> PasswordValidationState {
        PasswordValidationState(
            hasUppercase: password.contains(where: \.isUppercase),
            hasLowercase: password.contains(where: \.isLowercase),
            hasNumber: password.contains(where: \.isNumber),
            hasMinLength: password.count >= 8
        )
    }
}

// MARK: - CreatePasswordViewModel

@MainActor
class CreatePasswordViewModel: ObservableObject {

    // MARK: - Published properties

    @Published var password: String = "" {
        didSet { validationState = PasswordValidationState.evaluate(password) }
    }
    @Published var isPasswordVisible: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var validationState: PasswordValidationState = .empty

    // MARK: - Session

    var session: SignupSession

    // MARK: - Init

    init(session: SignupSession) {
        self.session = session
    }

    // MARK: - API

    /// Submits the new password to the server.
    func createPassword(onSuccess: @escaping (SignupSession) -> Void) {
        guard validationState.allSatisfied else { return }
        guard ReachabilityManager.shared.isNetworkReachable else {
            errorMessage = CustomError.noInternet.localizedDescription
            return
        }
        let request = CreatePasswordRequest(workEmail: session.workEmail, password: password)
        isLoading = true
        errorMessage = nil

        APITarget.signupCreatePassword(request: request)
            .request(type: BaseResponseModel<CreatePasswordResponse>.self) { [weak self] result in
                guard let self else { return }
                self.isLoading = false
                switch result {
                case .success(let response):
                    if response.status, let data = response.result {
                        self.session.password = self.password
                        self.session.userId = data.userId
                        onSuccess(self.session)
                    } else {
                        self.errorMessage = response.message
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
    }
}
