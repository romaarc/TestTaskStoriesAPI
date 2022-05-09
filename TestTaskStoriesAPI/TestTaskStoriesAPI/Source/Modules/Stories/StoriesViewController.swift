import UIKit

protocol StoriesViewControllerProtocol: AnyObject {
    func displayStories(viewModel: Stories.StoriesLoad.ViewModel)
}

final class StoriesViewController: UIViewController {
    private let interactor: StoriesInteractorProtocol
    
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
        collectionViewAdapter.delegate = self
        interactor.doStoriesLoad(request: .init())
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
}

extension StoriesViewController: StoriesViewControllerProtocol {
    func displayStories(viewModel: Stories.StoriesLoad.ViewModel) {
        collectionViewAdapter.components = viewModel.model
        storiesView?.updateCollectionViewData(
            delegate: collectionViewAdapter,
            dataSource: collectionViewAdapter
        )
    }
}

extension StoriesViewController: StoriesCollectionViewAdapterDelegate {
    func storiesCollectionViewAdapter(_ adapter: StoriesCollectionViewAdapter, didSelectComponentAt indexPath: IndexPath) {}
}
