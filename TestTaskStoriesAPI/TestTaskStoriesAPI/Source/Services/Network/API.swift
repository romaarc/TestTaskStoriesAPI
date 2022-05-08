//
//  API.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 08.05.2022.
//
//https://stepik.org:443/api/story-templates?page=1&page_size=10

import Foundation

enum API {
    static let main = "https://stepik.org:443/api"
    
    enum TypeOf {
        static let stories = "/story-templates"
    }
}
