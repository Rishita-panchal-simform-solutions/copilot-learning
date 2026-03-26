//
//  MoveContentAboveKeyboard.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
extension View {
    func moveContentAboveKeyboard(offset: CGFloat = 0.0) -> some View {
        self.modifier(MoveContentAboveKeyboard(offset: offset))
    }
}
struct MoveContentAboveKeyboard: ViewModifier {
    var offset: CGFloat
    @State var keyboardOffset: CGFloat = 0
    @State var keyboardAnimationDuration: Double = 0
    
    func body(content: Content) -> some View {
        content
            .offset(y: keyboardOffset)
            .animation(.easeOut(duration: keyboardAnimationDuration), value: keyboardOffset)
            .onReceive(
                NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
                    .receive(on: RunLoop.main),
                perform: updateKeyboardHeight
            )
    }
    
    func updateKeyboardHeight(_ notification: Notification) {
        guard let info = notification.userInfo,
              let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        // If the top of the frame is at the bottom of the screen, set the height to 0.
        if keyboardFrame.origin.y == UIScreen.main.bounds.height {
            keyboardOffset = 0
        } else {
            keyboardOffset = -(keyboardFrame.height * (UIScreen.main.bounds.height <= 667 ? 1.1 : 0.9)) + offset
        }
    }
}