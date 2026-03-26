//
//  DateTimeFormat.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation
#warning("Replace your DateFormatter here.")
/// These are the examples for the date formats, add/remove as per the need
enum DateTimeFormat: String {
    case apiTime = "HH:mm:ss"
    case time = "hh:mm a"
    case date = "dd-MM-yyyy"
    case reverseDate = "yyyy-MM-dd"
    case dateWithSpace = "MMM dd, yyyy"
    case dateAndMonth = "MMM dd"
    case dateAndTime = "MMM dd, yyyy-hh:mm a"
    case dateAndTimeFormat = "yyyy-MM-dd,HH:mm:ss"
    case dateAndTimeAMFormat = "yyyy-MM-dd,hh:mm a"
    case enUSDateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    case apiDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    case dateAndTimeAndSecFormat = "yyyy-MM-dd HH:mm:ss'+'00"
    case dateFormatMMddYYYY = "MM/dd/yyyy"
    case ddMMyyyy = "dd/MM/yyyy"
    case localDateTimeFormat = "yyyy-MM-dd HH:mm:ss '+'0000"
}