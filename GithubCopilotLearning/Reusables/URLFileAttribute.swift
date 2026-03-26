//
//  URLFileAttribute.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation
// MARK: - URLFileAttribute
struct URLFileAttribute {
   private(set) var fileSize: UInt?
   private(set) var creationDate: Date?
   private(set) var modificationDate: Date?
   init(url: URL) {
       let path = url.path
       guard let dictionary: [FileAttributeKey: Any] = try? FileManager.default
               .attributesOfItem(atPath: path) else {
           return
       }
       if dictionary.keys.contains(FileAttributeKey.size),
           let value = dictionary[FileAttributeKey.size] as? UInt {
           self.fileSize = value
       }
       if dictionary.keys.contains(FileAttributeKey.creationDate),
           let value = dictionary[FileAttributeKey.creationDate] as? Date {
           self.creationDate = value
       }
       if dictionary.keys.contains(FileAttributeKey.modificationDate),
           let value = dictionary[FileAttributeKey.modificationDate] as? Date {
           self.modificationDate = value
       }
   }
}