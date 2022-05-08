//
//  Story.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 08.05.2022.
//

import Foundation

struct Story: Decodable {
    let id: Int
    let title: String
    let cover: String
    let parts: [StoryPart]
    let isPublished: Bool
    let position: Int
    
    private enum CodingKeys: String, CodingKey {
        case id, title, cover, parts, position
        case isPublished = "is_published"
    }
}

struct StoryURLParameters {
    var page: String
    var pageSize: String
}
