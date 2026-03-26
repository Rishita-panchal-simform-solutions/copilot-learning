//
//  DashboardView+ViewModel.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
import Combine
// MARK: - variable
class DashboardViewModel: ObservableObject {
    @MainActor @Published var userList: UserList = []
    @MainActor @Published var state: ProgressState = .initial
    @Published private var cancellable = Set<AnyCancellable>()
    private let networkRepo: NetworkRepo.Type
    // MARK: - init
    init(networkRepo: NetworkRepo.Type) {
        self.networkRepo = networkRepo
        observeState()
    }
}
// MARK: - enums
extension DashboardViewModel {
    enum ProgressState: Equatable {
        case initial, fetching, success, failure(error: CustomError)
    }
}
// MARK: - functions
extension DashboardViewModel {
    func observeState() {
        $state
            .removeDuplicates()
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .fetching:
                    Task(priority: .userInitiated) {
                        await self.fetchUserList()
                    }
                default:
                    break
                }
            }
            .store(in: &cancellable)
    }
    func fetchUserList() async {
        let userListResult = await networkRepo.randomUser(request: UserListRequest(size: 10))
            .request(type: UserList.self)
        await MainActor.run {
            withAnimation {
                switch userListResult {
                case .success(let list):
                    self.userList = list
                    state = .success
                case .failure(let error):
                    state = .failure(error: error)
                }
            }
        }
    }
}