//
//  SnackBarIconTextView.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
import SFSafeSymbols
struct SnackBarIconTextView {
    // MARK: - Input parameters
    var snackBarIcon: Image
    var snackBarTitle: String
    var background = Color(.snackBarBackground)
    var iconColor: Color?
    var textColor = Color.white
    var showCheckMark = false
    var hideIcon = false
    var didTap: (() -> Void)?
    var customFrame: CGSize = .init(width: 16, height: 16)
}
// MARK: - Body view
extension SnackBarIconTextView: View {
    var body: some View {
        HStack(spacing: 0) {
            if !hideIcon {
                VStack(spacing: 0) {
                    Spacer(minLength: 0)
                    snackBarIcon
                        .resizable()
                        .frame(width: customFrame.width, height: customFrame.height)
                        .scaledToFit()
                        .padding(.horizontal, 10)
                        .foregroundColor(iconColor)
                        .opacity(showCheckMark ? 0 : 1)
                    Spacer(minLength: 0)
                }
            }
            HStack(spacing: 0) {
                if showCheckMark {
                    Text("\(Image(systemSymbol: .checkmarkCircleFill)) \(snackBarTitle)")
                        .tracking(0.6)
                        .fixedSize(horizontal: false, vertical: false)
                        .foregroundColor(textColor)
                        .font(.system(size: 15))
                        .lineLimit(3)
                        .truncationMode(.tail)
                        .padding(.vertical, 4)
                } else {
                    Text(snackBarTitle)
                        .tracking(0.6)
                        .fixedSize(horizontal: false, vertical: false)
                        .foregroundColor(textColor)
                        .font(.system(size: 15))
                        .lineLimit(3)
                        .truncationMode(.tail)
                        .padding(.vertical, 4)
                }
            }
            .padding(.leading, hideIcon ? 16 : 0)
            Spacer(minLength: 0)
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                Button(action: {
                    SwiftMessagesHelper.shared.hideSnackBar()
                }, label: {
                    Image(systemSymbol: .xmarkCircleFill)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color.white)
                        .padding(.top, 5)
                        .padding(.bottom, 6)
                        .padding(.trailing, 5)
                        .padding(.leading, 5)
                })
                Spacer(minLength: 0)
            }
            .padding(.trailing, 10)
            .padding(.leading, 10)
        }
        .padding(.leading, 7.5)
        .padding(.vertical, 5)
        .background {
            TransparentBlurView(removeAllFilter: false)
                .background(Color(.snackBarBackground).opacity(0.5))
        }
        .cornerRadius(25)
        .padding(.horizontal, 20)
        .onTapGesture {
            if didTap != nil {
                didTap?()
                SwiftMessagesHelper.shared.hideSnackBar()
            }
        }
    }
}