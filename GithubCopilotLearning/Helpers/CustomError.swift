//
//  CustomError.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation
struct CustomError: Error, Equatable {
    let title: String
    let body: String
    // No internet error
    static let noInternet = CustomError(title: AppStrings.internetConnectionError(),
                                          body: AppStrings.connectToInternet())
    /// Generic error object
    static let genericError = CustomError(title: AppStrings.error(),
                                          body: AppStrings.somethingWentWrong())
}