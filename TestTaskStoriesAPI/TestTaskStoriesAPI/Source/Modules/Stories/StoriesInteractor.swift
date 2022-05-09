import Foundation
import PromiseKit

protocol StoriesInteractorProtocol {
    func doStoriesLoad(request: Stories.StoriesLoad.Request)
}

final class StoriesInteractor: StoriesInteractorProtocol {
    weak var moduleOutput: StoriesOutputProtocol?

    private let presenter: StoriesPresenterProtocol
    private let provider: StoriesProviderProtocol

    init(
        presenter: StoriesPresenterProtocol,
        provider: StoriesProviderProtocol
    ) {
        self.presenter = presenter
        self.provider = provider
    }

    func doStoriesLoad(request: Stories.StoriesLoad.Request) {
        let params = StoryURLParameters(page: "2", pageSize: "10")
        self.provider.fetch(params: params).done { stories in
            self.presenter.presentStoriesResult(response: .init(result: .success(stories)))
        }.catch { error in
            self.presenter.presentStoriesResult(response: .init(result: .failure(error)))
        }
    }

    enum Error: Swift.Error {
        case unloadable
    }
}

extension StoriesInteractor: StoriesInputProtocol { }
