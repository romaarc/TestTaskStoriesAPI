//
//  Meta.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 08.05.2022.
//

import Foundation

struct Meta: Decodable {
    let page: Int
    let hasNext: Bool
    let hasPrevious: Bool
    
    private enum CodingKeys: String, CodingKey {
        case page
        case hasNext = "has_next"
        case hasPrevious = "has_previous"
    }
}
