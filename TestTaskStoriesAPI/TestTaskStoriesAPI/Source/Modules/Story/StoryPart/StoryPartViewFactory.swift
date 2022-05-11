//
//  StoryPartViewFactory.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 10.05.2022.
//

import UIKit

final class StoryPartViewFactory {
    
    static func makeView(storyPart: StoryPartViewModel) -> (UIView & UIStoryPartViewProtocol)? {
        switch storyPart.type {
        case .text:
            let textStoryView: TextStoryView = TextStoryView(frame: UIScreen.main.bounds)
            textStoryView.configure(storyPart: storyPart)
            return textStoryView
        case .feedback:
            return nil
            //guard let feedbackStoryPart = storyPart as? FeedbackStoryPart else {
            ////                return nil
            ////            }
            ////
            ////            let feedbackStoryView = FeedbackStoryView()
            ////            feedbackStoryView.configure(storyPart: feedbackStoryPart)
            ////
            ////            return feedbackStoryView
        }
   }
}

