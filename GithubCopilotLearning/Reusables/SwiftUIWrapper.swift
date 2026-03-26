//
//  SwiftUIWrapper.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import UIKit
import SwiftUI
extension UIView {
    var swiftUI: some View {
        ViewWrapper(view: self)
    }
}
private struct ViewWrapper: UIViewRepresentable {
    let view: UIView
    func makeUIView(context: Context) -> UIView {
        view
    }
    func updateUIView(_ uiView: UIView, context: Context) { }
}