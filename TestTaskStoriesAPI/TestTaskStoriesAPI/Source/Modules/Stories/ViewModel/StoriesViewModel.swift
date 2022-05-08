//
//  StoriesViewModel.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 08.05.2022.
//

import Foundation
import UIKit

struct StoriesViewModel {
    let id: Int
    let title: String
    let cover: String
    let parts: [StoryPartViewModel]
    let isPublished: Bool
    let position: Int
    var isViewed: CachedValue<Bool>
}

struct StoryPartViewModel {
    let position: Int
    let type: String
    let duration: Int
    let image: URL?
    //let text: PartTypeText?
    //let button: PartTypeButton?
}



