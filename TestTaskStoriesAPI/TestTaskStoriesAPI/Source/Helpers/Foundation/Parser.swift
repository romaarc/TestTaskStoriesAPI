//
//  Parser.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 09.05.2022.
//

import UIKit

enum Parser {
//    static func dateFromTimedateJSON(_ json: JSON) -> Date? {
//        if let date = json.string,
//           let timeInterval = TimeInterval(timeString: date) {
//            return Date(timeIntervalSince1970: timeInterval)
//        } else {
//            return nil
//        }
//    }

//    static func dateFromTimedateString(_ timeString: String) -> Date? {
//        if let timeInterval = TimeInterval(timeString: timeString) {
//            return Date(timeIntervalSince1970: timeInterval)
//        }
//        return nil
//    }

    static func colorFromHex6StringJSON(_ hexStringValue: String) -> UIColor? {
        guard let hexStringValue = UInt32(hexStringValue, radix: 16) else { return nil }
        return UIColor(hex6: hexStringValue)
    }

//    static func timedateStringFromDate(dateOrNil: Date?) -> String? {
//        if let date = dateOrNil {
//            return self.timedateStringFromDate(date: date)
//        }
//        return nil
//    }

//    static func timedateStringFromDate(date: Date) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        return dateFormatter.string(from: date)
//    }

//    static func codeFromURL(_ url: URL) -> String? {
//        url.getKeyVals()?["code"]
//    }
}
