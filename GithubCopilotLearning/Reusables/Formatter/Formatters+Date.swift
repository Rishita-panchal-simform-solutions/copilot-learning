//
//  Formatters+Date.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation
extension Formatters {
    enum Date {
        private static let dateFormatterQueue = DispatchQueue(label: "date-formatter-helper-queue")
        private static var dateFormatters = [String: DateFormatter]()
        private static func getDateFormatter(function: String = #function) -> DateFormatter {
            return dateFormatterQueue.sync {
                var formatter: DateFormatter
                if let fmt = dateFormatters[function] {
                    formatter = fmt
                } else {
                    formatter = DateFormatter()
                    dateFormatters[function] = formatter
                }
                // Setting timeZone is not expensive if the time zone doesn't change,
                // so it's fine to repeat this everytime we need to get the DateFormatter instance
                formatter.timeZone = .current
                return formatter
            }
        }
        static var MMMdHHMM: DateFormatter {
            let formatter = getDateFormatter()
            formatter.dateFormat = "MMM d, HH:mm"
            return formatter
        }
    }
}