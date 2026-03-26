//
//  ItemDetailAppRegistry.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
@MainActor
extension View {
    func itemDetailWithAppRouter<T>(_ router: T) -> some View where T: AnyObject, T: ObservableObject {
        navigationDestination(for: ItemDetailRouterDestination.self) { destination in
            Group {
                switch destination {
                case .thirdView:
                    ThirdView()
                case .fourthView:
                    FourthView()
                }
            }
            .environmentObject(router)
        }
    }
}