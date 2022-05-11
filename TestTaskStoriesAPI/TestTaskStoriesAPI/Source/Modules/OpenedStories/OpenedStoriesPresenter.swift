//
//  OpenedStoriesPresenter.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 10.05.2022.
//

import UIKit

protocol StoryNavigationDelegate: AnyObject {
    func didFinishForward()
    func didFinishBack()
}

protocol OpenedStoriesPresenterProtocol: AnyObject {
    var currentModule: UIViewController { get }
    var nextModule: UIViewController? { get }
    var prevModule: UIViewController? { get }

    func onSwipeDismiss()
    func refresh()
}

class OpenedStoriesPresenter: OpenedStoriesPresenterProtocol {
    weak var view: OpenedStoriesViewProtocol?
    
    private let storyOpenSource: StoryOpenSource
   
    var stories: [StoriesViewModel]
    var currentPosition: Int
    var moduleForStoryID: [Int: UIViewController] = [:]
    
    var currentModule: UIViewController {
        let story = stories[self.currentPosition]
        return getModule(story: story)
    }
    
    var nextModule: UIViewController? {
        if let story = stories[safe: currentPosition + 1] {
            return getModule(story: story)
        }
        return nil
    }

    var prevModule: UIViewController? {
        if let story = stories[safe: currentPosition - 1] {
            return getModule(story: story)
        }
        return nil
    }

    init(
        view: OpenedStoriesViewProtocol,
        stories: [StoriesViewModel],
        startPosition: Int,
        storyOpenSource: StoryOpenSource
    ) {
        self.view = view
        self.stories = stories
        self.currentPosition = startPosition
        self.storyOpenSource = storyOpenSource

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(OpenedStoriesPresenter.storyDidAppear(_:)),
            name: .storyDidAppear,
            object: nil
        )
    }

    func refresh() {
        self.view?.set(module: self.currentModule, direction: .forward, animated: false)
    }

    func onSwipeDismiss() {}

    private func getModule(story: StoriesViewModel) -> UIViewController {
        if let module = self.moduleForStoryID[story.id] {
            return module
        } else {
            let module = self.makeModule(for: story)
            self.moduleForStoryID[story.id] = module
            return module
        }
    }

    private func makeModule(for story: StoriesViewModel) -> UIViewController {
        let assembly = StoryAssembly(
            story: story,
            storyOpenSource: storyOpenSource,
            navigationDelegate: self)
        return assembly.makeModule()
    }

    @objc
    func storyDidAppear(_ notification: Foundation.Notification) {
        guard let storyID = (notification as NSNotification).userInfo?["id"] as? Int,
              let position = self.stories.firstIndex(where: { $0.id == storyID }) else {
            return
        }
        self.currentPosition = position
        stories[position].isViewed.value = true
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension OpenedStoriesPresenter: StoryNavigationDelegate {
    func didFinishForward() {
        if let nextModule = self.nextModule {
            self.view?.set(module: nextModule, direction: .forward, animated: true)
        } else {
            self.view?.close()
        }
    }

    func didFinishBack() {
        if let prevModule = self.prevModule {
            self.view?.set(module: prevModule, direction: .reverse, animated: true)
        } else {
            self.view?.close()
        }
    }
}
