//
//  PartTypeText.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 08.05.2022.
//

import Foundation

struct PartTypeText: Decodable {
    let title: String?
    let text: String?
    let textColor: String?
    let backgroundStyle: String?
    
    private enum CodingKeys: String, CodingKey {
        case title, text
        case textColor = "text_color"
        case backgroundStyle = "background_style"
    }
}
