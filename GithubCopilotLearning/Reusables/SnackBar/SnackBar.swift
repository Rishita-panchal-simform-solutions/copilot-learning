//
//  SnackBar.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftMessages
import SFSafeSymbols
import SwiftUI
/// Usage:
/// ```
/// SwiftMessagesHelper.shared.showSnackBar(.internetConnectionError)
/// ```
class SwiftMessagesHelper: SwiftMessages {
    static let shared = SwiftMessagesHelper()
    private override init() {
        super.init()
    }
    @discardableResult
    func showSnackBar(_ type: SnackBarType) -> Bool {
        let canShow = current() == nil
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            var config = self.defaultConfig
            config.presentationStyle = .top
            config.duration = .seconds(seconds: 3)
            config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
            if let view = UIHostingController(rootView: type.view).view {
                view.backgroundColor = UIColor(Color.clear)
                view.swiftUI.triggerErrorNotificationHapticFeedback()
                self.show(config: config, view: view)
            }
        }
        return canShow
    }
    func hideSnackBar(animated: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.hide(animated: animated)
        }
    }
}
enum SnackBarType {
    case errorMsg(text: String)
    case message(text: String, hideIcon: Bool = false, didTap: (() -> Void)? = nil)
    case internetConnectionError
}
extension SnackBarType {
    @ViewBuilder
    var view: some View {
        switch self {
        case .errorMsg(text: let error):
            SnackBarIconTextView(snackBarIcon: Image(systemSymbol: .exclamationmarkCircleFill),
                                 snackBarTitle: error,
                                 background: Color(.snackBarBackground),
                                 iconColor: Color.white)
        case .internetConnectionError:
            SnackBarIconTextView(snackBarIcon: Image(systemSymbol: .exclamationmarkCircleFill),
                                 snackBarTitle: AppStrings.internetConnectionError(),
                                 background: Color(.snackBarBackground),
                                 iconColor: Color.white)
        case let .message(message, hideIcon, didTap):
            SnackBarIconTextView(snackBarIcon: Image(systemSymbol: .exclamationmarkCircleFill),
                                 snackBarTitle: message,
                                 background: Color(.snackBarBackground),
                                 iconColor: Color.white,
                                 hideIcon: hideIcon,
                                 didTap: didTap)
        }
    }
}