//
//  Color.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import SwiftUI
extension Color {
    init(hexString: String, alpha: Double = 1, darker percentage: Double = 0) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        self.init(hex: Int(int), alpha: alpha, darker: percentage)
    }
    init(hex: Int, alpha: Double = 1, darker percentage: Double = 0.0) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        let multiplier = percentage / 100.0
        let newRed = min(max(components.R + multiplier * components.R, 0.0), 1.0)
        let newGreen = min(max(components.G + multiplier * components.G, 0.0), 1.0)
        let newBlue = min(max(components.B + multiplier * components.B, 0.0), 1.0)
        self.init(
            .sRGB,
            red: newRed,
            green: newGreen,
            blue: newBlue,
            opacity: alpha
        )
    }
}