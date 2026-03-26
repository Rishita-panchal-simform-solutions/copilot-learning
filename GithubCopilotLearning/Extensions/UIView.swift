//
//  UIView.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
extension UIView {
    static var hasNotch: Bool {
        if let window = UIApplication.shared.keyWindowInConnectedScenes {
            return window.safeAreaInsets.bottom > 0
        }
        return false
    }
    static var safeAreaBottom: CGFloat {
        if let window = UIApplication.shared.keyWindowInConnectedScenes {
            return window.safeAreaInsets.bottom
        }
        return 0
    }
    static var safeAreaTop: CGFloat {
        if let window = UIApplication.shared.keyWindowInConnectedScenes {
            return window.safeAreaInsets.top
        }
        return 0
    }
}