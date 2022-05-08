//
//  Response.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 08.05.2022.
//

import Foundation

struct Response<T: Decodable>: Decodable {
    let meta: Meta
    let results: [T]
    
    private enum CodingKeys: String, CodingKey {
        case meta
        case results = "story-templates"
    }
}
