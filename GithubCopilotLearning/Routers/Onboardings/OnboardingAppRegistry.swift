//
//  OnboardingAppRegistry.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
#warning("Create your own routers.")
@MainActor
extension View {
    func onboardingWithAppRouter<T>(_ router: T) -> some View where T: AnyObject, T: ObservableObject {
        navigationDestination(for: OnboardingRouterDestination.self) { destination in
            Group {
                switch destination {
                case .dashboard(let didUpdateData):
                    DashboardView(didUpdate: didUpdateData)
                }
            }
            .environmentObject(router)
        }
    }
    func onboardingWithSheetDestinations(_ sheetDestinations: Binding<OnboardingSheetDestination?>) -> some View {
        sheet(item: sheetDestinations) { destination in
            Group {
                switch destination {
                case .secondView:
                    SecondView()
                }
            }
//            .withEnvironments()
        }
    }
//    func withEnvironments() -> some View {
//        environmentObject(Theme.shared)
//    }
}
// class Theme: ObservableObject {
//    static let shared = Theme()
// }