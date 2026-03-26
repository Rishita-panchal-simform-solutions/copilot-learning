//
//  FourthView.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
struct FourthView {
    @EnvironmentObject var routerPath: ItemDetailRouterPath
}
extension FourthView: View {
    var body: some View {
        tapBtn
        popToRootView
    }
}
extension FourthView {
    private var tapBtn: some View {
        Button(action: {
            routerPath.popToView(.thirdView)
        }, label: {
            Text("popToSpecificView")
                .font(.systemBold(size: 20))
                .foregroundStyle(.black)
        })
        .background(Color.white)
        .cornerRadius(12, corners: .allCorners)
    }
    private var popToRootView: some View {
        Button(action: {
            routerPath.popToRootView()
        }, label: {
            Text("popToRootView")
                .font(.systemBold(size: 20))
                .foregroundStyle(.black)
        })
        .background(Color.white)
        .cornerRadius(12, corners: .allCorners)
    }
}
#Preview {
    FourthView()
}