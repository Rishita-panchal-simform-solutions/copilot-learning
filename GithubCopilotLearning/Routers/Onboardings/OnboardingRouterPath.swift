//
//  OnboardingRouterPath.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
#warning("Create your own routers.")
enum OnboardingRouterDestination: Hashable {
    case dashboard(didUpatedata: HashableVoidCompletion)
}
enum OnboardingSheetDestination: Identifiable {
    case secondView
    var id: String {
        switch self {
        case .secondView:
            "secondView"
        }
    }
}
class OnboardingRouterPath: ObservableObject {
    @Published var path: [OnboardingRouterDestination] = []
    @Published var presentedSheet: OnboardingSheetDestination?
    init() {}
    func navigate(to: OnboardingRouterDestination) {
        path.append(to)
    }
    /// Remove the last 'k' routes from the navigation path.
    func removeLast(_ count: Int = 1) {
        if path.count >= count {
            path.removeLast(count)
        }
    }
    func popToRootView() {
        while path.count > 0 {
            path.removeLast()
        }
    }
    func popToView(_ view: OnboardingRouterDestination) {
        if let index = path.firstIndex(where: {$0 == view}) {
            if path.count == 1 {
                self.removeLast()
            } else {
                self.removeLast((path.count - 1) - index)
            }
        }
    }
}