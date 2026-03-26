//
//  Date.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation
import SwiftDate
/// Refer the SwiftDate for more out of the box functionalities
/// https://github.com/malcommac/SwiftDate/blob/master/Documentation/Index.md
///
/// To format the dates, you can use below code snippet.
/// ```swift
/// Date().toFormat(DateTimeFormat.apiTime.rawValue)
/// ```
/// The above code uses the default region `SwiftDate.defaultRegion`,
/// pass the region to the format method as per the need
///
/// To create data from strings, refer below documentation
/// https://github.com/malcommac/SwiftDate/blob/master/Documentation/1.Introduction.md#initfromstring
///
/// ```swift
/// DateInRegion("2016-01-05", format: "yyyy-MM-dd", region: regionNY)?.date
/// ```
extension Date {
    /// To milliseconds
    /// The interval between the date object and 00:00:00 UTC on 1 January 1970.
    /// This property's value is negative if the date object is earlier than 00:00:00 UTC on 1 January 1970.
    /// - Returns: The milliseconds since January 1st 1970
    func toMilliseconds() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    /// Convert data to string using given format
    /// - Parameter format: The `DateTimeFormat`
    /// - Returns: The string representation of this date using given format
    func toString(format: DateTimeFormat) -> String {
        return toFormat(format.rawValue)
    }
}