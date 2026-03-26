//
//  KCSettings.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation
#warning("Add your keychain keys and default values here.")
struct ASSettingItem<Type> {
    var key: String
    var defaultValue: Type
}
enum KCSettings {
    enum Device {
        #warning("This is codable declaration for reference")
     //   static var seeds = ASSettingItem<[SeedsModel]?>(key: "device-seeds", defaultValue: nil)
        static var apiToken = ASSettingItem(key: "device-apitoken", defaultValue: "")
    }
}
// Temporary: Model to show the usage
/* struct SeedsModel: Codable {
    var seeds = Data()
}*/