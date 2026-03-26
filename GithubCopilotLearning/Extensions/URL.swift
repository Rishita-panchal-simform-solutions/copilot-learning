//
//  URL.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation
extension URL {
    func appending(_ queryItems: [String: String]) -> URL? {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        let queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
        return urlComponents.url
    }
    var sanitise: URL {
        if var components = URLComponents(url: self, resolvingAgainstBaseURL: false) {
            if components.scheme == nil {
                components.scheme = "https"
            }
            return components.url ?? self
        }
        return self
    }
    func fileSize() -> UInt {
        let attributes = URLFileAttribute(url: self)
        return attributes.fileSize ?? 0
    }
}