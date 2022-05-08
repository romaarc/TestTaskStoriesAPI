import Foundation
import PromiseKit

protocol StoriesProviderProtocol {
    func fetch(params: StoryURLParameters) -> Promise<[Story]>
}

final class StoriesProvider: StoriesProviderProtocol {
    private let stepikNetworkService: NetworkServiceProtocol
    
    init(stepikNetworkService: NetworkServiceProtocol) {
        self.stepikNetworkService = stepikNetworkService
    }
    
    func fetch(params: StoryURLParameters) -> Promise<[Story]> {
        Promise { seal in
            self.stepikNetworkService.fetch(with: params).done { stories in
                seal.fulfill(stories.results)
            }.catch() { _ in
                seal.reject(Error.storiesFetchFailed)
            }
        }
        
    }
    
    enum Error: Swift.Error {
        case storiesFetchFailed
    }
}
