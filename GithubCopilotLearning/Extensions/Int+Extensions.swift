//
//  Int+Extensions.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
//
//  Int+Extensions.swift
//  BopilerplateExample
//
//  Created by Purva Rupareliya on 24/04/24.
//
import Foundation
extension Int {
     func delay() async {
        await withUnsafeContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(self)) {
                continuation.resume()
            }
        }
    }
}