//
//  SecondView.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
struct SecondView {
    @StateObject private var routerPath = ItemDetailRouterPath()
}
extension SecondView: View {
    var body: some View {
        NavigationStack(path: $routerPath.path) {
            tapToPushBtn
                .itemDetailWithAppRouter(routerPath)
        }
    }
}
// MARK: - subviews
extension SecondView {
    private var tapToPushBtn: some View {
        Button(action: {
            routerPath.navigate(to: .thirdView)
        }, label: {
            Text("Tap to push view")
                .font(.systemBold(size: 20))
                .foregroundStyle(.black)
        })
        .background(Color.white)
        .cornerRadius(12, corners: .allCorners)
    }
}
#Preview {
    SecondView()
}