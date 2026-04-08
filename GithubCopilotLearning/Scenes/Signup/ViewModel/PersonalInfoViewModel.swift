//
//  PersonalInfoViewModel.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 08/04/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation
import UIKit

// MARK: - PersonalInfoViewModel

@MainActor
class PersonalInfoViewModel: ObservableObject {

    // MARK: - Published properties

    @Published var ssnLast4: String = ""
    @Published var dateOfBirth: Date = Date()
    @Published var workEmail: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var ctaLabel: String?
    @Published var ctaAction: (() -> Void)?
    @Published var lookupResult: SignupLookupResponse?

    // MARK: - Session (shared across signup flow)

    var session: SignupSession = SignupSession()

    // MARK: - Computed

    var isFormValid: Bool {
        ssnLast4.count == 4 &&
        ssnLast4.allSatisfy(\.isNumber) &&
        workEmail.contains("@") &&
        workEmail.contains(".")
    }

    // MARK: - API

    /// Submits personal info for account lookup.
    /// Populates `session` on success; sets `errorMessage` on known failures.
    func submitPersonalInfo(
        onSuccess: @escaping (SignupSession) -> Void,
        onDuplicate: @escaping () -> Void
    ) {
        guard ReachabilityManager.shared.isNetworkReachable else {
            errorMessage = CustomError.noInternet.localizedDescription
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let request = SignupLookupRequest(
            ssnLast4: ssnLast4,
            dateOfBirth: formatter.string(from: dateOfBirth),
            workEmail: workEmail
        )
        isLoading = true
        errorMessage = nil
        ctaLabel = nil
        ctaAction = nil

        APITarget.signupLookup(request: request)
            .request(type: BaseResponseModel<SignupLookupResponse>.self) { [weak self] result in
                guard let self else { return }
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.handleLookupResponse(response, onSuccess: onSuccess, onDuplicate: onDuplicate)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
    }

    // MARK: - Private helpers

    private func handleLookupResponse(
        _ response: BaseResponseModel<SignupLookupResponse>,
        onSuccess: @escaping (SignupSession) -> Void,
        onDuplicate: @escaping () -> Void
    ) {
        guard response.status, let data = response.result else {
            errorMessage = response.message
            return
        }
        switch data.accountStatus {
        case .found:
            session.ssnLast4 = ssnLast4
            session.dateOfBirth = dateOfBirth
            session.workEmail = workEmail
            session.employerName = data.employerName
            session.maskedEmail = data.maskedEmail
            session.benefitAccountType = data.benefitAccountType
            lookupResult = data
            onSuccess(session)
        case .notReady:
            let startDate = data.accountStartDate ?? ""
            errorMessage = String(format: SignupStrings.personalInfoErrorNotReady, startDate)
        case .duplicate:
            errorMessage = SignupStrings.personalInfoErrorDuplicate
            ctaLabel = SignupStrings.personalInfoGoToLogin
            ctaAction = onDuplicate
        case .hsaNotFound:
            errorMessage = SignupStrings.personalInfoErrorHsaNotFound
            ctaLabel = SignupStrings.personalInfoContactUs
            ctaAction = { [weak self] in
                self?.openContactUs()
            }
        }
    }

    func openContactUs() {
        let email = Constants.Signup.supportEmail
        guard let url = URL(string: "mailto:\(email)") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
