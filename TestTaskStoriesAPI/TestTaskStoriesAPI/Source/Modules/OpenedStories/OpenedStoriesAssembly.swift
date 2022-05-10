//
//  OpenedStoriesAssembly.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 10.05.2022.
//

import UIKit

final class OpenedStoriesAssembly: Assembly {
    
    private let startPosition: Int
    private let stories: [StoriesViewModel]
    private let storyOpenSource: StoryOpenSource

    init(
        startPosition: Int,
        stories: [StoriesViewModel],
        storyOpenSource: StoryOpenSource
    ) {
        self.stories = stories
        self.startPosition = startPosition
        self.storyOpenSource = storyOpenSource
    }

    func makeModule(with context: ModuleContext?) -> UIViewController {
        let viewController = OpenedStoriesPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        let presenter = OpenedStoriesPresenter(
            view: viewController,
            stories: self.stories,
            startPosition: self.startPosition,
            storyOpenSource: self.storyOpenSource
        )

        viewController.presenter = presenter

        return viewController
    }
}
