//
//  ShowAlertModifier.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
struct ShowAlertModifier: ViewModifier {
    
    // MARK: - Variables
    var title: String
    var message: String?
    var dismissButtonTitle: String?
    @Binding var isPresented: Bool
    
}
// MARK: - Body
extension ShowAlertModifier {
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: $isPresented) {
                Alert(title: Text(title),
                      message: message.map({ Text($0) }),
                      dismissButton: dismissButtonTitle.map({ .cancel(Text($0))})
                )
            }
    }
    
}
// MARK: - showAlert modifier
extension View {
    
    /// To show alert with dismiss button
    ///
    /// - Parameters:
    ///   - title: Title of alert like "My Alert"
    ///   - message: what the purpose of alert
    ///   - dismissButtonTitle: Dismiss button title
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the alert that you create in the modifier's `content` closure.
    /// - Returns: Return View
    func showAlert(title: String,
                   message: String? = nil,
                   dismissButtonTitle: String? = nil,
                   @Binding isPresented: Bool ) -> some View {
        self.modifier(ShowAlertModifier(title: title,
                                        message: message,
                                        dismissButtonTitle: dismissButtonTitle,
                                        isPresented: $isPresented))
    }
    
}