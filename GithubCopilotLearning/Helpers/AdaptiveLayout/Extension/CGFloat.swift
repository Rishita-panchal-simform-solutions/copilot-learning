//
//  CGFloat.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import UIKit
extension CGFloat {
    var adaptedFontSize: CGFloat {
        adapted(dimensionSize: self, to: dimension)
    }
    func adaptedFrame(_ dimension: Dimension) -> CGFloat {
        return adapted(dimensionSize: self, to: dimension)
    }
}