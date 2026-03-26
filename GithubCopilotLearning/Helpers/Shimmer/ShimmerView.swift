//
//  ShimmerView.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
struct ShimmerView {
    @State private var isShowed = false
    var cornerRadius: CGFloat = 10
    var delayAfter: CGFloat = 0.1
    var color = Color(.shimmerBG)
}
// MARK: - Body
extension ShimmerView: View {
    var body: some View {
        color
            .overlay(LoadingShimmerView(isShowed: isShowed, color: color))
            .onAppear {
                onAppearHandler()
            }
            .cornerRadius(cornerRadius)
            .allowsHitTesting(false)
    }
}
// MARK: - Functions
extension ShimmerView {
    private func onAppearHandler() {
        DispatchQueue.main.asyncAfter(deadline: .now() + delayAfter) {
            withAnimation(Animation.default.speed(0.15).delay(0).repeatForever(autoreverses: false)) {
                isShowed.toggle()
            }
        }
    }
}
struct LoadingShimmerView: View {
    var isShowed: Bool
    var color = Color(.shimmerWave)
    var cornerRadius: CGFloat = 17
    private let originX = UIScreen.main.bounds.height - 80
    var body: some View {
        color
            .frame(
                width: UIScreen.main.bounds.height * 1.5,
                height: UIScreen.main.bounds.height
            )
            .cornerRadius(cornerRadius)
            .mask(
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: .init(colors: [.white.opacity(0.6).opacity(0.1), .white.opacity(0.6), .white.opacity(0.6).opacity(0.1)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .rotationEffect(.init(degrees: 110))
                    .offset(x: self.isShowed ? originX : -originX)
            )
    }
}