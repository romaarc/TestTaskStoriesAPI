import UIKit

final class StoriesAssembly: Assembly {
    var moduleInput: StoriesInputProtocol?

    private weak var moduleOutput: StoriesOutputProtocol?

    init(output: StoriesOutputProtocol? = nil) {
        self.moduleOutput = output
    }

    func makeModule(with context: ModuleContext?) -> UIViewController {
        guard let context = context else { return UIViewController() }
        let provider = StoriesProvider(stepikNetworkService: context.moduleDependencies.stepikNetworkService)
        let presenter = StoriesPresenter()
        let interactor = StoriesInteractor(presenter: presenter, provider: provider)
        let viewController = StoriesViewController(interactor: interactor)

        presenter.viewController = viewController
        self.moduleInput = interactor
        interactor.moduleOutput = self.moduleOutput
        
        return viewController
    }
}
