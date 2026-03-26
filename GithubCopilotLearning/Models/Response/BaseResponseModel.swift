//
//  BaseResponseModel.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation
#warning("Replace it with your BaseResponse model")
struct BaseResponseModel<T: Codable>: Codable {
    let result: T?
    let status: Bool
    let message: String
    let statusCode: Int
}