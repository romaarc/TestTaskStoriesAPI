import UIKit

final class StoryAssembly: Assembly {
    private let story: StoriesViewModel
    private let storyOpenSource: StoryOpenSource
    
    init(story: StoriesViewModel, storyOpenSource: StoryOpenSource) {
        self.story = story
        self.storyOpenSource = storyOpenSource
    }
    
    func makeModule(with context: ModuleContext? = nil) -> UIViewController {
        let provider = StoryProvider()
        let presenter = StoryPresenter()
        let interactor = StoryInteractor(
            presenter: presenter,
            provider: provider,
            story: story,
            storyOpenSource: storyOpenSource)
        let viewController = StoryViewController(interactor: interactor)

        presenter.viewController = viewController

        return viewController

    }
}
