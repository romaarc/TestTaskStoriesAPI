import UIKit

protocol StoriesViewControllerProtocol: AnyObject {
    func displayStories(viewModel: Stories.StoriesLoad.ViewModel)
}

final class StoriesViewController: UIViewController {
    private let interactor: StoriesInteractorProtocol

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
        interactor.doStoriesLoad(request: .init())
    }
}

extension StoriesViewController: StoriesViewControllerProtocol {
    func displayStories(viewModel: Stories.StoriesLoad.ViewModel) {}
}