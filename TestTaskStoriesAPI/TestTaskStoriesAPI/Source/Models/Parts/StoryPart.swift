//
//  StoryPart.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 08.05.2022.
//

import Foundation

struct StoryPart: Decodable {
    let position: Int
    let type: String
    let duration: Int
    let image: String
    let text: PartTypeText?
    let button: PartTypeButton?
}
