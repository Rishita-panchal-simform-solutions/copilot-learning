//
//  AdaptiveOffset.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
// swiftlint:disable identifier_name
struct AdaptiveOffset: ViewModifier {
    var x: CGFloat = 0
    var y: CGFloat = 0
    func body(content: Content) -> some View {
        content
            .offset(x: x, y: y)
    }
}
extension View {
    func adaptiveOffset(x: CGFloat = 0, y: CGFloat = 0) -> some View {
        modifier(AdaptiveOffset(x: x.adaptedFrame(.width), y: y.adaptedFrame(.height)))
    }
}
// swiftlint:enable identifier_name