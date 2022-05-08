//
//  URLFactory.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 08.05.2022.
//

import Foundation

enum URLFactory {
    
    private static var baseURL: URL {
        return baseURLComponents.url!
    }
    
    private static let baseURLComponents: URLComponents = {
        let url = URL(string: API.main)!
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = []
        return urlComponents
    }()
    
    static func get(params: StoryURLParameters) -> URLRequest {
        var urlComponents = baseURLComponents
        if !params.page.isEmpty, !params.pageSize.isEmpty {
            let paramsQueryItem = [
                URLQueryItem(name: "page", value: params.page),
                URLQueryItem(name: "page_size", value: params.pageSize)
            ]
            urlComponents.queryItems?.append(contentsOf: paramsQueryItem)
        }
    
        var request = URLRequest(url: urlComponents.url!.appendingPathComponent(API.TypeOf.stories))
        request.httpMethod = HTTPMethod.get.rawValue
        request.timeoutInterval = 30
        return request
    }
}

enum HTTPMethod: String {
    case get = "GET"
}
