//
//  Font+Custom.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
#warning("This is the font declaration with adaptive size. Please replace it with your fonts.")
extension Font {
    enum Name {
//        static let orbRegular = "Orbitron-Regular"
    }
}
extension Font {
    static func systemBold(size: CGFloat, adaptive: Bool = false) -> Font {
        if adaptive {
            return .system(size: size.adaptedFontSize, weight: .bold, design: .default)
        } else {
            return .system(size: size, weight: .bold, design: .default)
        }
    }
    static func systemRegular(size: CGFloat, adaptive: Bool = false) -> Font {
        if adaptive {
            return .system(size: size.adaptedFontSize, weight: .regular, design: .default)
        } else {
            return .system(size: size, weight: .regular, design: .default)
        }
    }
//    static func orbRegular(size: CGFloat, adaptive: Bool = false) -> Font {
//        if adaptive {
//            return Font.custom(Name.orbRegular, size: size.adaptedFontSize)
//        } else {
//            return Font.custom(Name.orbRegular, size: size)
//        }
//    }
}