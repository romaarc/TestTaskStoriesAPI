import UIKit

final class StoryAssembly: Assembly {
    private let story: StoriesViewModel
    private let storyOpenSource: StoryOpenSource
    private weak var navigationDelegate: StoryNavigationDelegate?
    
    init(
        story: StoriesViewModel,
        storyOpenSource: StoryOpenSource,
        navigationDelegate: StoryNavigationDelegate
    ) {
        self.story = story
        self.storyOpenSource = storyOpenSource
        self.navigationDelegate = navigationDelegate
    }
    
    func makeModule(with context: ModuleContext? = nil) -> UIViewController {
        let provider = StoryProvider()
        let presenter = StoryPresenter()
        presenter.navigationDelegate = self.navigationDelegate
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
