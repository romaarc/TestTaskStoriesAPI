//
//  NetworkService+Strory.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 08.05.2022.
//

import Foundation
import PromiseKit

extension NetworkService: NetworkServiceProtocol {
    func fetch(with params: StoryURLParameters) -> Promise<Response<Story>> {
        baseRequest(request: URLFactory.get(params: params))
    }
}
