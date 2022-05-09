import UIKit

protocol StoriesPresenterProtocol {
    func presentStoriesResult(response: Stories.StoriesLoad.Response)
}

final class StoriesPresenter: StoriesPresenterProtocol {
    weak var viewController: StoriesViewControllerProtocol?
    
    func presentStoriesResult(response: Stories.StoriesLoad.Response) {
        switch response.result {
        case .success(let result):
            var dictStoryPartViewModels: [Int: [StoryPartViewModel]] = [:]
            var storyPartViewModels: [StoryPartViewModel] = []
            var viewModels: [StoriesViewModel] = []
            for story in result {
                for part in story.parts {
                    let textStoryPart = TextStoryPart(partTypeText: part.text,
                                                      partTypeButton: part.button)
                    let partModel = StoryPartViewModel(id: story.id, position: part.position,
                                                            type: part.type,
                                                            duration: part.duration,
                                                            image: URL(string: part.image),
                                                            textStoryPart: textStoryPart)
                    storyPartViewModels.append(partModel)
                }
                dictStoryPartViewModels[story.id] = storyPartViewModels
                storyPartViewModels.removeAll()
            }
            
            viewModels = result.map { story in
                StoriesViewModel(id: story.id,
                                 title: story.title,
                                 cover: story.cover,
                                 parts: dictStoryPartViewModels[story.id],
                                 isPublished: story.isPublished,
                                 position: story.position,
                                 isViewed: CachedValue(key: story.cover, defaultValue: false))

            }
            viewController?.displayStories(viewModel: .init(model: viewModels))
        case .failure(_):
            break
        }
    }
}
