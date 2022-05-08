//
//  AppDependency.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 08.05.2022.
//

import Foundation

protocol HasDependencies {
    var stepikNetworkService: NetworkServiceProtocol { get }
}

final class AppDependency {
    let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    static func makeDefault() -> AppDependency {
        let networkService = NetworkService()
        return AppDependency(networkService: networkService)
    }
}

extension AppDependency: HasDependencies {
    var stepikNetworkService: NetworkServiceProtocol {
        return self.networkService
    }
}
