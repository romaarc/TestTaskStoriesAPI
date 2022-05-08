//
//  PartTypeButton.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 08.05.2022.
//

import Foundation

struct PartTypeButton: Decodable {
    let title: String
    let url: String
    let textColor: String?
    let backgroundColor: String?
    
    private enum CodingKeys: String, CodingKey {
        case title, url
        case textColor = "text_color"
        case backgroundColor = "background_color"
    }
}
