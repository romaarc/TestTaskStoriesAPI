import UIKit

protocol StoriesPresenterProtocol {
    func presentStoriesResult(response: Stories.StoriesLoad.Response)
}

final class StoriesPresenter: StoriesPresenterProtocol {
    weak var viewController: StoriesViewControllerProtocol?
    
    func presentStoriesResult(response: Stories.StoriesLoad.Response) {
        switch response.result {
        case .success(_):
            //viewController?.displayStories(viewModel: .init(model: <#T##StoriesViewModel#>))
            print("")
            break
        case .failure(_):
            break
        }
    }
}
