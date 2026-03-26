//
//  NotificationsHelper.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation
import UIKit
import UserNotifications
/// Notification helper
class NotificationsHelper: NSObject {
    static let shared = NotificationsHelper()
    /// Configure UNUserNotificationCenter Delegate
    func configure() {
        UNUserNotificationCenter.current().delegate = self
    }
    /// Register For Remote Notifications
    func registerForRemoteNotifications() {
        let application = UIApplication.shared
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) {_, _ in
            // do nothing for now
        }
        application.registerForRemoteNotifications()
    }
}
// MARK: UNUserNotificationCenterDelegate
extension NotificationsHelper: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Uncomment if needed
//        let userData = notification.request.content.userInfo
//        self.handleRemoteNotification(with: userData)
        completionHandler([.list, .banner, .sound])
    }
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // Uncomment if needed
//        let userData = response.notification.request.content.userInfo
//        self.handleRemoteNotification(with: userData)
        completionHandler()
    }
}