//
//  Device.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import UIKit
// Add devices as per your design needs
enum Device {
    case iPhoneSE
    case iPhone8
    case iPhone8Plus
    case iPhoneX
    case iPhone11ProMax
    case iPhone14
    case iPhone14Plus
    case iPhone15
    case iPhone15Plus
    static let baseScreenSize: Device = .iPhoneX
}
extension Device: RawRepresentable {
    typealias RawValue = CGSize
    init?(rawValue: CGSize) {
        switch rawValue {
        case CGSize(width: 320, height: 568):
            self = .iPhoneSE
        case CGSize(width: 375, height: 667):
            self = .iPhone8
        case CGSize(width: 414, height: 736):
            self = .iPhone8Plus
        case CGSize(width: 375, height: 812):
            self = .iPhoneX
        case CGSize(width: 414, height: 896):
            self = .iPhone11ProMax
        case CGSize(width: 390, height: 844):
            self = .iPhone14
        case CGSize(width: 428, height: 926):
            self = .iPhone14Plus
        case CGSize(width: 393, height: 852):
            self = .iPhone15
        case CGSize(width: 430, height: 932):
            self = .iPhone15Plus
        default:
            return nil
        }
    }
    var rawValue: CGSize {
        switch self {
        case .iPhoneSE:
            return CGSize(width: 320, height: 568)
        case .iPhone8:
            return CGSize(width: 375, height: 667)
        case .iPhone8Plus:
            return CGSize(width: 414, height: 736)
        case .iPhoneX:
            return CGSize(width: 375, height: 812)
        case .iPhone11ProMax:
            return CGSize(width: 414, height: 896)
        case .iPhone14:
            return CGSize(width: 390, height: 844)
        case .iPhone14Plus:
            return CGSize(width: 428, height: 926)
        case .iPhone15:
            return CGSize(width: 393, height: 852)
        case .iPhone15Plus:
            return CGSize(width: 430, height: 932)
        }
    }
}