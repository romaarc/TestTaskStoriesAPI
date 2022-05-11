import UIKit

protocol StoryPresenterProtocol {
    func presentStoryResult(response: StoryDataFlow.StoryLoad.Response)
    func doFinishedAnimating()
    func resume()
    func rewind()
    func skip()
    func pause()
    func animate()
    func didAppear()
}

protocol UIStoryPartViewProtocol {
    var completion: (() -> Void)? { get set }
    var onDidChangeReaction: ((StoryReaction) -> Void)? { get set }

    func startLoad()
    func setReaction(_ reaction: StoryReaction?)
}

enum StoryReaction: String {
    case like
    case dislike
}

final class StoryPresenter: StoryPresenterProtocol {
    
    weak var viewController: StoryViewControllerProtocol?
    weak var navigationDelegate: StoryNavigationDelegate?
    
    private var partToAnimate: Int = 0
    private var viewForIndex: [Int: UIView & UIStoryPartViewProtocol] = [:]
    private var shouldRestartSegment = false
    private var story: StoriesViewModel? = nil
    //private var storyPartViewFactory: StoryPartViewFactory
    //private var urlNavigator: URLNavigator

    func presentStoryResult(response: StoryDataFlow.StoryLoad.Response) {
        story = response.response
        viewController?.displayStoryResult(viewModel: .init(result: response.response))
    }
    
    func doFinishedAnimating() {
        partToAnimate += 1
        animate()
    }
}

extension StoryPresenter {
    func animate() {
        guard let story = story else { return }
        guard let parts = story.parts else { return }
        
        if partToAnimate < 0 {
            showPreviousStory()
            return
        }
        
        if partToAnimate >= parts.count {
            showNextStory()
            return
        }

        let animatingStoryPart = parts[partToAnimate]

        if let viewToAnimate = viewForIndex[partToAnimate] {
            viewController?.animate(view: viewToAnimate)
            viewController?.animateProgress(segment: partToAnimate, duration: TimeInterval(animatingStoryPart.duration))
        } else {
//            guard var viewToAnimate = storyPartViewFactory.makeView(storyPart: animatingStoryPart) else {
//                return
//            }
        }
//
//            viewToAnimate.completion = { [weak self] in
//                guard let strongSelf = self else {
//                    return
//                }
//
//                if strongSelf.partToAnimate == animatingStoryPart.position {
//                    strongSelf.view?.animateProgress(
//                        segment: strongSelf.partToAnimate,
//                        duration: animatingStoryPart.duration
//                    )
//                }
//            }
//            viewToAnimate.onDidChangeReaction = { [weak self] reaction in
//                guard let strongSelf = self else {
//                    return
//                }
//
//                if strongSelf.partToAnimate == animatingStoryPart.position {
//                    strongSelf.saveStoryPartReaction(reaction: reaction, storyPart: animatingStoryPart).done { _ in }
//                    strongSelf.analytics.send(
//                        .storyReactionPressed(
//                            id: animatingStoryPart.storyID,
//                            position: animatingStoryPart.position,
//                            reaction: reaction
//                        )
//                    )
//                }
//            }
//
//            self.fetchStoryPartReaction(animatingStoryPart).done { [weak viewToAnimate] reaction in
//                viewToAnimate?.setReaction(reaction?.storyReaction)
//            }
//
//            self.view?.animate(view: viewToAnimate)
        //}
    }
    
    private func showPreviousStory() {
        navigationDelegate?.didFinishBack()
        partToAnimate = 0
        shouldRestartSegment = true
    }
    
    private func showNextStory() {
        navigationDelegate?.didFinishForward()
        partToAnimate = (story?.parts?.count ?? 0) - 1
        shouldRestartSegment = true
    }

    func skip() {
        viewController?.set(segment: partToAnimate, completed: true)
        partToAnimate += 1
        animate()
    }

    func rewind() {
        viewController?.set(segment: partToAnimate, completed: false)
        partToAnimate -= 1
        animate()
    }

    func pause() {
        viewController?.pause(segment: partToAnimate)
    }

    func resume() {
        viewController?.resume(segment: partToAnimate)
    }
    
    func didAppear() {
        guard let story = story else { return }
        NotificationCenter.default.post(name: .storyDidAppear, object: nil, userInfo: ["id": story.id])

        if shouldRestartSegment {
            shouldRestartSegment = false
            animate()
        }
    }
}

extension StoryViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let isControllTapped = touch.view is UIControl
        return !isControllTapped
    }
}
