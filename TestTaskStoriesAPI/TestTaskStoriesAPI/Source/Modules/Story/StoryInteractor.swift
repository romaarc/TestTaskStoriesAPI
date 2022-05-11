import Foundation
import PromiseKit

protocol StoryInteractorProtocol {
    func doStoryLoad(request: StoryDataFlow.StoryLoad.Request)
    func resume()
    func rewind()
    func skip()
    func pause()
    func finishedAnimating()
    func animate()
    func didAppear()
}

final class StoryInteractor: StoryInteractorProtocol {
    
    private let presenter: StoryPresenterProtocol
    private let provider: StoryProviderProtocol
    
    private let story: StoriesViewModel
    private let storyOpenSource: StoryOpenSource
    
    init(
        presenter: StoryPresenterProtocol,
        provider: StoryProviderProtocol,
        story: StoriesViewModel,
        storyOpenSource: StoryOpenSource
    ) {
        self.presenter = presenter
        self.provider = provider
        self.story = story
        self.storyOpenSource = storyOpenSource
    }

    func doStoryLoad(request: StoryDataFlow.StoryLoad.Request) {
        presenter.presentStoryResult(response: .init(response: self.story))
    }
    
    func resume() {
        presenter.resume()
    }
    
    func rewind() {
        presenter.rewind()
    }
    
    func skip() {
        presenter.skip()
    }
    
    func pause() {
        presenter.pause()
    }
    
    func finishedAnimating() {
        presenter.doFinishedAnimating()
    }
    
    func animate() {
        presenter.animate()
    }
    
    func didAppear() {
        presenter.didAppear()
    }

    enum Error: Swift.Error {
        case something
    }
}
