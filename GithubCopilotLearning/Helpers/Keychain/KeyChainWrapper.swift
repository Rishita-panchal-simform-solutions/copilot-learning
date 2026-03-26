//
//  KeyChainWrapper.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation
/// A type safe property wrapper to set and get values from Keychain with support for defaults values.
///
/// Usage:
/// ```
/// @KeyChainWrapper(KCSettings.Device.deviceSignature.key,
/// defaultValue: KCSettings.Device.deviceSignature.defaultValue)
/// var signature: String?
///
/// @KeyChainWrapper(KCSettings.Device.seeds.key,
/// defaultValue: KCSettings.Device.seeds.defaultValue)
/// var seeds: [SeedsModel]?
/// ```
///
/// [Apple documentation on UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults)
@propertyWrapper
public struct KeyChainWrapper {
    let key: String
    let defaultValue: String?
    
    public init (
        key: String,
        defaultValue: String?
    ) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: String? {
        get {
            do {
                if try KeychainOperations.exists(key: key) {
                    let value = try KeychainOperations.retreive(key: key) ?? Data()
                    return String(data: value, encoding: .utf8)
                } else {
                    throw Errors.operationError
                }
            } catch {
                return defaultValue
            }
        }
        set {
            if let newValue = newValue {
                do {
                    // If the value exists `update the value`
                    if try KeychainOperations.exists(key: key) {
                        try KeychainOperations.update(value: newValue.data(using: .utf8) ?? Data(), key: key)
                    } else {
                        // Just insert
                        try KeychainOperations.add(value: newValue.data(using: .utf8) ?? Data(), key: key)
                    }
                } catch {
                    debugPrint(error)
                }
            } else {
                do {
                    if try KeychainOperations.exists(key: key) {
                        return try KeychainOperations.delete(key: key)
                    } else {
                        throw Errors.operationError
                    }
                } catch {
                    debugPrint(error)
                }
            }
        }
    }
}
@propertyWrapper
/// Save sensitive codable data to keychain manager.
public struct KeyChainCodable<Value: Codable> {
    let key: String
    let defaultValue: Value?
    
    public init (
        key: String,
        defaultValue: Value?
    ) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: Value? {
        get {
            do {
                if try KeychainOperations.exists(key: key) {
                    if let tokenData = try KeychainOperations.retreive(key: key) {
                        return try? PropertyListDecoder().decode(Value.self, from: tokenData)
                    }
                } else {
                    throw Errors.operationError
                }
            } catch {
                return defaultValue
            }
            return defaultValue
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                do {
                    if try KeychainOperations.exists(key: key) {
                        return try KeychainOperations.delete(key: key)
                    } else {
                        throw Errors.operationError
                    }
                } catch {
                    debugPrint(error)
                }
            } else {
                if let parsed = try? PropertyListEncoder().encode(newValue) {
                    do {
                        // If the value exists `update the value`
                        if try KeychainOperations.exists(key: key) {
                            try KeychainOperations.update(value: parsed, key: key)
                        } else {
                            // Just insert
                            try KeychainOperations.add(value: parsed, key: key)
                        }
                    } catch {
                        debugPrint(error)
                    }
                }
            }
        }
    }
}
// Since our property wrapper's Value type isn't optional, but
// can still contain nil values, we'll have to introduce this
// protocol to enable us to cast any assigned value into a type
// that we can compare against nil:
private protocol AnyOptional {
    var isNil: Bool { get }
}