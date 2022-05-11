//
//  TextStoryView.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 11.05.2022.
//

import SnapKit
import UIKit
import Kingfisher

extension TextStoryView {
    struct Appearance {
        let textLabelFont = Font.sber(ofSize: Font.Size.twenty, weight: .bold)

        let buttonFont = Font.sber(ofSize: Font.Size.eleven, weight: .bold)
        let buttonHeight: CGFloat = 44

        let reactionsViewHeight: CGFloat = 48
        let reactionsViewInsets = LayoutInsets(bottom: 24)

        let elementsStackViewInsets = LayoutInsets(top: 68, left: 16, bottom: 24, right: 16)
        let elementsStackViewSpacing: CGFloat = 16

        let contentStackViewSpacing: CGFloat = 36
    }
}

final class TextStoryView: UIView, UIStoryPartViewProtocol {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var appearance = Appearance()

    var completion: (() -> Void)?
    var onDidChangeReaction: ((StoryReaction) -> Void)?

    private var imagePath: URL?
    private var storyPart: TextStoryPart?

    private lazy var gradientView = StoryPartGradientView()

    private lazy var elementsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = appearance.elementsStackViewSpacing
        return stackView
    }()

    private lazy var reactionsView: StoryReactionsView = {
        let view = StoryReactionsView()
        view.onLikeClick = { [weak self] in
            self?.onDidChangeReaction?(.like)
        }
        view.onDislikeClick = { [weak self] in
            self?.onDidChangeReaction?(.dislike)
        }
        return view
    }()
    
    init(
        frame: CGRect = .zero,
        appearance: Appearance = Appearance()
    ) {
        self.appearance = appearance
        super.init(frame: frame)

        self.setupView()
        self.addSubviews()
        self.makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(storyPart: StoryPartViewModel) {
        guard let textStoryPart = storyPart.textStoryPart else { return }
        
        imagePath = storyPart.image
       
        setupReactionsView()
        setupElementsStackView()

        let topStackView = makeContentStackView()
        let bottomStackView = makeContentStackView()
        
        if let storyPartText = textStoryPart.text {
            if storyPartText.title != nil {
                let storyTitleView = makeTitleView(textModel: storyPartText)
                topStackView.addArrangedSubview(storyTitleView)
                
                let storyTextView = makeTextView(textModel: storyPartText)
                bottomStackView.addArrangedSubview(storyTextView)
            }
        }
        
        if let storyPartButton = textStoryPart.button {
            let storyButtonView = makeActionButtonView(button: storyPartButton)
            bottomStackView.addArrangedSubview(storyButtonView)
        }
        
        elementsStackView.addArrangedSubview(topStackView)
        elementsStackView.addArrangedSubview(bottomStackView)
        elementsStackView.isHidden = true

        self.storyPart = textStoryPart
    }

    private func setupReactionsView() {
        addSubview(reactionsView)
        reactionsView.translatesAutoresizingMaskIntoConstraints = false
        reactionsView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-appearance.reactionsViewInsets.bottom)
            make.height.equalTo(appearance.reactionsViewHeight)
        }
    }

    private func setupElementsStackView() {
        addSubview(elementsStackView)
        elementsStackView.translatesAutoresizingMaskIntoConstraints = false
        elementsStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(appearance.elementsStackViewInsets.top)
            make.leading.equalToSuperview().offset(appearance.elementsStackViewInsets.left)
            make.bottom.equalTo(reactionsView.snp.top).offset(-appearance.elementsStackViewInsets.bottom)
            make.trailing.equalToSuperview().offset(-appearance.elementsStackViewInsets.right)
        }
    }

    private func makeContentStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = appearance.contentStackViewSpacing
        return stackView
    }

    private func makeTitleView(textModel: TextStoryPart.Text) -> UIView {
        let label = StoryPartTitleLabel(appearance: .init(textColor: textModel.textColor))
        label.text = textModel.title
        return label
    }

    private func makeTextView(textModel: TextStoryPart.Text) -> UIView {
        let label = UILabel()
        label.text = textModel.text
        label.textColor = textModel.textColor
        label.font = appearance.textLabelFont
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }

    private func makeActionButtonView(button buttonModel: TextStoryPart.Button) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .clear

        let storyButton = WiderStepikButton(type: .system)
        storyButton.backgroundColor = buttonModel.backgroundColor
        storyButton.titleLabel?.font = appearance.buttonFont
        storyButton.setTitleColor(buttonModel.titleColor, for: .normal)
        storyButton.setTitle(buttonModel.title, for: .normal)

        let cornerRadius = appearance.buttonHeight / 2.0
        storyButton.setRoundedCorners(cornerRadius: cornerRadius, borderWidth: 1, borderColor: buttonModel.backgroundColor)
        storyButton.widthDelta = cornerRadius * 2

        containerView.addSubview(storyButton)
        storyButton.translatesAutoresizingMaskIntoConstraints = false
        storyButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(appearance.buttonHeight)
        }

        storyButton.addTarget(self, action: #selector(self.actionButtonClicked), for: .touchUpInside)

        return containerView
    }

    func startLoad() {
        elementsStackView.isHidden = true
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: imagePath) { [weak self] _ in
            guard let self = self else { return }
            self.completion?()
            self.elementsStackView.isHidden = false
        }
    }

    func setReaction(_ reaction: StoryReaction?) {
        if let reaction = reaction {
            switch reaction {
            case .like:
                self.reactionsView.state = .liked
            case .dislike:
                self.reactionsView.state = .disliked
            }
        } else {
            self.reactionsView.state = .normal
        }
    }

    @objc
    func actionButtonClicked() {}
}

extension TextStoryView: ProgrammaticallyInitializableViewProtocol {
    func setupView() {}

    func addSubviews() {
        addSubview(imageView)
    }

    func makeConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        insertSubview(gradientView, aboveSubview: imageView)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

private class WiderStepikButton: StepikButton {
    var widthDelta: CGFloat = 8 {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        super.intrinsicContentSize.sizeByDelta(dw: widthDelta, dh: 0)
    }
}
