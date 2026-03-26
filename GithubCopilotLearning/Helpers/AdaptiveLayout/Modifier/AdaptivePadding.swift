//
//  AdaptivePadding.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
struct AdaptivePadding: ViewModifier {
    var edge: Edge.Set = .all
    var length: CGFloat?
    func body(content: Content) -> some View {
        content
            .padding(edge, length)
    }
}
extension View {
    func adaptiveLeadingPadding(_ length: CGFloat? = nil) -> some View {
        modifier(AdaptivePadding(edge: .leading, length: length?.adaptedFrame(.width)))
    }
    func adaptiveTrailingPadding(_ length: CGFloat? = nil) -> some View {
        modifier(AdaptivePadding(edge: .trailing, length: length?.adaptedFrame(.width)))
    }
    func adaptiveTopPadding(_ length: CGFloat? = nil) -> some View {
        modifier(AdaptivePadding(edge: .top, length: length?.adaptedFrame(.height)))
    }
    func adaptiveBottomPadding(_ length: CGFloat? = nil) -> some View {
        modifier(AdaptivePadding(edge: .bottom, length: length?.adaptedFrame(.height)))
    }
    func adaptiveHorizontalPadding(length: CGFloat? = nil) -> some View {
        modifier(AdaptivePadding(edge: .horizontal, length: length?.adaptedFrame(.width)))
    }
    func adaptiveVerticalPadding(length: CGFloat? = nil) -> some View {
        modifier(AdaptivePadding(edge: .vertical, length: length?.adaptedFrame(.height)))
    }
}