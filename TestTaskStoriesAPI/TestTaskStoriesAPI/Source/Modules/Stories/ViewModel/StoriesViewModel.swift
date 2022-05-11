//
//  StoriesViewModel.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 08.05.2022.
//

import Foundation
import UIKit

struct StoriesViewModel {
    let id: Int
    let title: String
    let cover: String
    let parts: [StoryPartViewModel]?
    let isPublished: Bool
    let position: Int
    var isViewed: CachedValue<Bool>
}

struct StoryPartViewModel {
    let id: Int
    let position: Int
    let type: PartType
    let duration: Int
    let image: URL?
    let textStoryPart: TextStoryPart?
}

enum PartType: String {
    case text
    case feedback
}

final class TextStoryPart {
    var text: Text?
    var button: Button?
    
    init(partTypeText: PartTypeText?, partTypeButton: PartTypeButton?) {
        
        if let partTypeText = partTypeText {
            let textColor = Parser.colorFromHex6StringJSON(partTypeText.textColor ?? "") ?? .black
            let backgroundStyle = Text.BackgroundStyle(rawValue: partTypeText.backgroundStyle ?? "") ?? .none
            
            self.text = Text(title: partTypeText.title,
                             text: partTypeText.text,
                             textColor: textColor,
                             backgroundStyle: backgroundStyle)
        }
        
        if let partTypeButton = partTypeButton {
            let titleColor = Parser.colorFromHex6StringJSON(partTypeButton.textColor ?? "") ?? .black
            let backgroundColor = Parser.colorFromHex6StringJSON(partTypeButton.backgroundColor ?? "") ?? .black
            
            self.button = Button(
                title: partTypeButton.title,
                urlPath: partTypeButton.url,
                backgroundColor: backgroundColor,
                titleColor: titleColor
            )
        }
    }
    
    struct Text {
        var title: String?
        var text: String?
        var textColor: UIColor
        var backgroundStyle: BackgroundStyle

        enum BackgroundStyle: String {
            case light
            case dark
            case none

            var backgroundColor: UIColor {
                switch self {
                case .light:
                    return UIColor.white.withAlphaComponent(0.7)
                case .dark:
                    return UIColor.stepikAccentFixed.withAlphaComponent(0.7)
                default:
                    return .clear
                }
            }
        }
    }
    
    struct Button {
        var title: String
        var urlPath: String
        var backgroundColor: UIColor
        var titleColor: UIColor
    }
}
