//
//  AdaptiveFrame.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
struct AdaptiveFrame: ViewModifier {
    var width: CGFloat?
    var height: CGFloat?
    var alignment: Alignment = .center
    func body(content: Content) -> some View {
        content
            .frame(width: width, height: height, alignment: alignment)
    }
}
extension View {
    func adaptiveFrame(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        alignment: Alignment = .center) -> some View {
            modifier(AdaptiveFrame(
                width: width?.adaptedFrame(.width),
                height: height?.adaptedFrame(.height),
                alignment: alignment))
    }
}