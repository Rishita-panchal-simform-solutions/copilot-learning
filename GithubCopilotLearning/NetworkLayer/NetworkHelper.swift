//
//  NetworkHelper.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
class NetworkHelper {
    static var httpPreTokenHeader: [String: String] {
        return [Constants.HeaderKeys.contentType: "application/json"]
    }
    static var httpPreAuthTokenHeader: [String: String] {
        return [Constants.HeaderKeys.contentType: "application/json", "Authorization": "Bearer \(KeychainStorageContainer.apiToken ?? "")"]
    }
    static var multipartFormRequestHeaders: [String: String] {
        return [Constants.HeaderKeys.contentType: "multipart/form-data", "Authorization": "Bearer \(KeychainStorageContainer.apiToken ?? "")"]
    }
}