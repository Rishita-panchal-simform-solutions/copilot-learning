//
//  TermsAgreementViewModel.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 08/04/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation

// MARK: - TermsAgreementViewModel

@MainActor
class TermsAgreementViewModel: ObservableObject {

    // MARK: - Published properties

    @Published var checkedIds: Set<String> = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - State

    var session: SignupSession
    var terms: [TermsItem] = []

    var allChecked: Bool {
        terms.allSatisfy { checkedIds.contains($0.id) }
    }

    // MARK: - Init

    init(session: SignupSession) {
        self.session = session
        if let accountType = session.benefitAccountType {
            self.terms = TermsItem.items(for: accountType)
        }
    }

    // MARK: - Toggle

    func toggle(item: TermsItem) {
        if checkedIds.contains(item.id) {
            checkedIds.remove(item.id)
        } else {
            checkedIds.insert(item.id)
        }
    }

    // MARK: - API

    /// Submits terms acceptance and activates the account.
    func acceptTerms(onSuccess: @escaping (SignupSession) -> Void) {
        guard allChecked else { return }
        guard let userId = session.userId, !userId.isEmpty else {
            errorMessage = "User ID unavailable. Please restart signup."
            return
        }
        guard ReachabilityManager.shared.isNetworkReachable else {
            errorMessage = CustomError.noInternet.localizedDescription
            return
        }
        let request = TermsAcceptanceRequest(
            userId: userId,
            acceptedTerms: Array(checkedIds)
        )
        isLoading = true
        errorMessage = nil

        APITarget.signupAcceptTerms(request: request)
            .request(type: BaseResponseModel<TermsAcceptanceResponse>.self) { [weak self] result in
                guard let self else { return }
                self.isLoading = false
                switch result {
                case .success(let response):
                    if response.status, response.result?.accountCreated == true {
                        self.session.acceptedTerms = Array(self.checkedIds)
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
