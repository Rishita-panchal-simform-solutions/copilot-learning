//
//  LoadingOverlayView.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 08/04/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI

// MARK: - LoadingOverlayView

/// Full-screen semi-transparent overlay with a centred activity indicator.
/// Blocks all user interaction while visible.
struct LoadingOverlayView: View {
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.45)
                .ignoresSafeArea()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.6)
        }
        .allowsHitTesting(true)
    }
}

#Preview {
    LoadingOverlayView()
}
