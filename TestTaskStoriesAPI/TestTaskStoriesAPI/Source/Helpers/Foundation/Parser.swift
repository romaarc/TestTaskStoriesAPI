//
//  Parser.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 09.05.2022.
//

import UIKit

enum Parser {
    static func colorFromHex6StringJSON(_ hexStringValue: String) -> UIColor? {
        guard let hexStringValue = UInt32(hexStringValue, radix: 16) else { return nil }
        return UIColor(hex6: hexStringValue)
    }
}
