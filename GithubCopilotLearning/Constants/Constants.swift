//
//  Constants.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import UIKit
/// Constants of the project
/// All the hardcoded literals should be places here with proper naming and proper namespace
enum Constants {
    enum CurrentScreen {
        static var screenHeight: CGFloat {
            return UIScreen.main.bounds.height
        }
        static var screenWidth: CGFloat {
            return UIScreen.main.bounds.width
        }
    }
    enum APIManager {
        static let networkRequestRetryDelay = 0.3 // seconds
        static let networkRequestRetryLimit = 1
        static let timeOutInterval = 60.0 // seconds
    }
    enum HeaderKeys {
        static let contentType = "Content-Type"
        static let authorization = "Authorization"
    }
}