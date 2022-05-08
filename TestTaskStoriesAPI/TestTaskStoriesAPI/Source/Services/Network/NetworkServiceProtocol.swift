//
//  NetworkServiceProtocol.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 08.05.2022.
//

import Foundation
import PromiseKit

protocol NetworkServiceProtocol {
    func fetch(with params: StoryURLParameters) -> Promise<Response<Story>>
}
