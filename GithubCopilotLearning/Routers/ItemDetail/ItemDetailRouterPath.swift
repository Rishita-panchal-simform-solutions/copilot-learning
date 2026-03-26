//
//  ItemDetailRouterPath.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
enum ItemDetailRouterDestination: Hashable {
    case thirdView
    case fourthView
}
class ItemDetailRouterPath: ObservableObject {
    @Published var path: [ItemDetailRouterDestination] = []
    func navigate(to: ItemDetailRouterDestination) {
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
    func popToView(_ view: ItemDetailRouterDestination) {
        if let index = path.firstIndex(where: {$0 == view}) {
            if path.count == 1 {
                self.removeLast()
            } else {
                self.removeLast((path.count - 1) - index)
            }
        }
    }
}