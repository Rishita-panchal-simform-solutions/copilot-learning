//
//  DashboardView.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
// MARK: - variables
struct DashboardView {
    @StateObject private var viewModel = DashboardViewModel(networkRepo: APITarget.self)
    @EnvironmentObject var routerPath: OnboardingRouterPath
    var didUpdate: HashableVoidCompletion?
}
// MARK: - view
extension DashboardView: View {
    var body: some View {
        VStack(spacing: 0) {
            switch viewModel.state {
            case .fetching, .initial:
                placeholderView
            case .success:
                userListView
            case .failure(error: let error):
                VStack {
                    Text(error.title)
                    Text(error.body)
                }
            }
        }
        .animation(.default, value: viewModel.userList.count)
        .onLoad {
            viewModel.state = .fetching
        }
    }
}
// MARK: - subviews
extension DashboardView {
    private var userListView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.userList, id: \.self) { user in
                    UserListView(user: user)
                        .onTapGesture {
                            didUpdate?.completion()
                            routerPath.presentedSheet = .secondView
                        }
                }
            }
        }
    }
    private var placeholderView: some View {
        ScrollView([], showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach((1...6), id: \.self) {_ in
                    HStack(spacing: 12) {
                        ShimmerView()
                            .frame(width: 100, height: 100)
                        VStack(spacing: 4) {
                            Group {
                                ShimmerView()
                                    .frame(width: 100, height: 14)
                                ShimmerView()
                                    .frame(width: 160, height: 14)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.bottom, 10)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
        }
    }
}
#Preview {
    DashboardView()
}