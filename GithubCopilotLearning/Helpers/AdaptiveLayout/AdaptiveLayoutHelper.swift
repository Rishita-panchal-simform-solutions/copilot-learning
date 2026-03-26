//
//  AdaptiveLayoutHelper.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import UIKit
var dimension: Dimension {
    UIDevice.current.orientation.isPortrait ? .width : .height
}
func adapted(dimensionSize: CGFloat, to dimension: Dimension) -> CGFloat {
    let screenWidth = Constants.CurrentScreen.screenWidth
    let screenHeight = Constants.CurrentScreen.screenHeight
    var ratio: CGFloat = 0.0
    var resultDimensionSize: CGFloat = 0.0
    switch dimension {
    case .width:
        ratio = dimensionSize / Device.baseScreenSize.rawValue.width
        resultDimensionSize = screenWidth * ratio
    case .height:
        ratio = dimensionSize / Device.baseScreenSize.rawValue.height
        resultDimensionSize = screenHeight * ratio
    }
    return resultDimensionSize
}