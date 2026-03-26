//
//  ThirdView.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
struct ThirdView {
    @EnvironmentObject var routerPath: ItemDetailRouterPath
}
extension ThirdView: View {
    var body: some View {
        Button(action: {
            routerPath.navigate(to: .fourthView)
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
    ThirdView()
}