import UIKit

protocol StoriesViewControllerProtocol: AnyObject {
    func displayStories(viewModel: Stories.StoriesLoad.ViewModel)
}

final class StoriesViewController: UIViewController {
    private let interactor: StoriesInteractorProtocol
    private var currentItemFrame: CGRect?
    
    var storiesView: StoriesView? { self.view as? StoriesView }

    private var collectionViewAdapter = StoriesCollectionViewAdapter()

    init(interactor: StoriesInteractorProtocol) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let view = StoriesView(frame: UIScreen.main.bounds)
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = self
        self.modalPresentationStyle = .custom
        collectionViewAdapter.delegate = self
        fetch()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
}

extension StoriesViewController: StoriesViewControllerProtocol {
    func fetch() {
        interactor.doStoriesLoad(request: .init())
    }
    
    func displayStories(viewModel: Stories.StoriesLoad.ViewModel) {
        collectionViewAdapter.components = viewModel.model
        storiesView?.updateCollectionViewData(
            delegate: collectionViewAdapter,
            dataSource: collectionViewAdapter
        )
    }
    
    func showStory(at index: Int) {
        let moduleToPresent = OpenedStoriesAssembly(
            startPosition: index,
            stories: collectionViewAdapter.components,
            storyOpenSource: .catalog)
            .makeModule(with: nil)
        moduleToPresent.modalPresentationStyle = .custom
        moduleToPresent.transitioningDelegate = self
        self.present(moduleToPresent, animated: true, completion: nil)
    }
}

    // MARK: - StoriesViewController: StoriesCollectionViewAdapterDelegate -
extension StoriesViewController: StoriesCollectionViewAdapterDelegate {
    func storiesCollectionViewAdapter(_ adapter: StoriesCollectionViewAdapter, currentItemFrame: CGRect?, didSelectComponentAt indexPath: IndexPath) {
        self.currentItemFrame = currentItemFrame
        showStory(at: indexPath.item)
    }
}

    // MARK: - StoriesViewController: UIViewControllerTransitioningDelegate -
extension StoriesViewController: UIViewControllerTransitioningDelegate {
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        guard let currentItemFrame = self.currentItemFrame else { return nil }
        return GrowPresentAnimationController(originFrame: currentItemFrame)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let revealVC = dismissed as? OpenedStoriesPageViewController,
              let currentItemFrame = self.currentItemFrame else {
            return nil
        }

        return ShrinkDismissAnimationController(
            destinationFrame: currentItemFrame,
            interactionController: revealVC.swipeInteractionController
        )
    }

    func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        guard let animator = animator as? ShrinkDismissAnimationController,
              let interactionController = animator.interactionController,
              interactionController.interactionInProgress else {
            return nil
        }
        return interactionController
    }
}
