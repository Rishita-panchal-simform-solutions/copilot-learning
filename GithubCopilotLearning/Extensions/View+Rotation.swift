//
//  View+Rotation.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
extension View {
    @ViewBuilder
    func forceRotation(orientation: UIInterfaceOrientationMask) -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.onAppear {
                AppDelegate.orientationLock = orientation
            }
            // Reset orientation to previous setting
            let currentOrientation = AppDelegate.orientationLock
            self.onDisappear {
                AppDelegate.orientationLock = currentOrientation
            }
        } else {
            self
        }
    }
}