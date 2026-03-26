//
//  Bundle+Version.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation
// MARK: - Bundle Version
extension Bundle {
    var appVersionShort: String { getInfo("CFBundleShortVersionString") }
    var bundleVersion: String { getInfo("CFBundleVersion") }
    var bundleName: String { getInfo(kCFBundleNameKey as String) }
    var bundleId: String { getInfo("CFBundleIdentifier") }
    private func getInfo(_ str: String) -> String { infoDictionary?[str] as? String ?? "" }
    var buildInfo: String {
        return "\(appVersionShort)-\(bundleVersion)"
    }
    func checkForForceUpgrade(minVersion: String) -> Bool {
        let versionCompare = self.appVersionShort.compare(minVersion, options: .numeric)
        return versionCompare == .orderedAscending
    }
}