//
//  UIDevice.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import UIKit
extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
}
extension UIDevice {
    static var screenType: DeviceType {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        switch identifier {
        // MARK: - iPhone
        case "i386", "x86_64", "arm64": return .iPhoneSimulator
        case "iPhone9,1", "iPhone9,3": return .iPhone7
        case "iPhone9,2", "iPhone9,4": return .iPhone7Plus
        case "iPhone10,1", "iPhone10,4": return .iPhone8
        case "iPhone10,2": return .iPhone8Plus
        case "iPhone10,3", "iPhone10,6", "iPhone11,2": return .iPhoneX
        case "iPhone10,5": return .iPhone8Plus
        case "iPhone11,4", "iPhone11,6": return .iPhoneXSMax
        case "iPhone11,8": return .iPhoneXR
        case "iPhone12,1": return .iPhone11
        case "iPhone12,3": return .iPhone11Pro
        case "iPhone12,5": return .iPhone11ProMax
        case "iPhone12,8": return .iPhoneSE2ndGen
        case "iPhone13,1": return .iPhone12Mini
        case "iPhone13,2": return .iPhone12
        case "iPhone13,3": return .iPhone12Pro
        case "iPhone13,4": return .iPhone12ProMax
        case "iPhone14,2": return .iPhone13Pro
        case "iPhone14,3": return .iPhone13ProMax
        case "iPhone14,4": return .iPhone13Mini
        case "iPhone14,5": return .iPhone13
        case "iPhone14,6": return .iPhoneSE3rdGen
        case "iPhone14,7": return .iPhone14
        case "iPhone14,8": return .iPhone14Plus
        case "iPhone15,2": return .iPhone14Pro
        case "iPhone15,3": return .iPhone14ProMax
        case "iPhone15,4": return .iPhone15
        case "iPhone15,5": return .iPhone15Plus
        case "iPhone16,1": return .iPhone15Pro
        case "iPhone16,2": return .iPhone15ProMax
        default:
            return .unknown
        }
    }
    enum DeviceType {
        // MARK: - iPhone
        case iPhoneSimulator
        case iPhone7
        case iPhone7Plus
        case iPhone8
        case iPhone8Plus
        case iPhoneXGlobal
        case iPhoneXGSM
        case iPhoneX
        case iPhoneXSMax
        case iPhoneXSMaxGlobal
        case iPhoneXR
        case iPhone11
        case iPhone11Pro
        case iPhone11ProMax
        case iPhoneSE2ndGen
        case iPhone12Mini
        case iPhone12
        case iPhone12Pro
        case iPhone12ProMax
        case iPhone13Pro
        case iPhone13ProMax
        case iPhone13Mini
        case iPhone13
        case iPhoneSE3rdGen
        case iPhone14
        case iPhone14Plus
        case iPhone14Pro
        case iPhone14ProMax
        case iPhone15
        case iPhone15Plus
        case iPhone15Pro
        case iPhone15ProMax
        case unknown
    }
}