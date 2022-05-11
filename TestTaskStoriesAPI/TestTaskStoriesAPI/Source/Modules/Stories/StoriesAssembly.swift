import UIKit

final class StoriesAssembly: Assembly {
    func makeModule(with context: ModuleContext?) -> UIViewController {
        guard let context = context else { return UIViewController() }
        let provider = StoriesProvider(stepikNetworkService: context.moduleDependencies.stepikNetworkService)
        let presenter = StoriesPresenter()
        let interactor = StoriesInteractor(presenter: presenter, provider: provider)
        let viewController = StoriesViewController(interactor: interactor)

        presenter.viewController = viewController
                
        return viewController
    }
}
