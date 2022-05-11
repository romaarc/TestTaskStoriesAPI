//
//  StoryPartTitleLabel.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 11.05.2022.
//

import SnapKit
import UIKit

extension StoryPartTitleLabel {
    struct Appearance {
        var textColor = UIColor.white
        let font = Font.sber(ofSize: Font.Size.twentyEight, weight: .bold)
        let textAlignment = NSTextAlignment.left
        let numberOfLines = 0
    }
}

final class StoryPartTitleLabel: UILabel {
    let appearance: Appearance

    init(
        frame: CGRect = .zero,
        appearance: Appearance = Appearance()
    ) {
        self.appearance = appearance
        super.init(frame: frame)
        self.setupView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StoryPartTitleLabel: ProgrammaticallyInitializableViewProtocol {
    func setupView() {
        textColor = appearance.textColor
        font = appearance.font
        textAlignment = appearance.textAlignment
        numberOfLines = appearance.numberOfLines
    }
}
