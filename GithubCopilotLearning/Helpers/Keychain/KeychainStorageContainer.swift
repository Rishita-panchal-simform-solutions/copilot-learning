//
//  KeychainStorageContainer.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation
#warning("A static variables class for all your Keychain keys.")
class KeychainStorageContainer {
    @KeyChainWrapper(
        key: KCSettings.Device.apiToken.key,
        defaultValue: KCSettings.Device.apiToken.defaultValue)
    static var apiToken: String?
}