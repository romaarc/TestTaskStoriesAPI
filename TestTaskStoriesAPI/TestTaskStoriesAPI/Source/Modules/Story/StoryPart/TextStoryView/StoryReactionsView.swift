//
//  StoryReactionsView.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 11.05.2022.
//

import SnapKit
import UIKit

extension StoryReactionsView {
    struct Appearance {
        let imageSize = CGSize(width: 24, height: 24)
        let imageNormalTintColor = UIColor.white.withAlphaComponent(0.38)
        let imageSelectedTintColor = UIColor.white

        let tapProxyViewSize = CGSize(width: 48, height: 48)

        let spacing: CGFloat = 48
    }
}

final class StoryReactionsView: UIView {
    let appearance: Appearance

    private lazy var likeButton: ImageButton = {
        let imageButton = ImageButton()
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        imageButton.image = UIImage(named: "stories-reaction-like")?.withRenderingMode(.alwaysTemplate)
        imageButton.imageSize = appearance.imageSize
        imageButton.tintColor = appearance.imageNormalTintColor
        imageButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        return imageButton
    }()
    
    private lazy var likeTapProxyView = TapProxyView(targetView: likeButton)

    private lazy var dislikeButton: ImageButton = {
        let imageButton = ImageButton()
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        imageButton.image = UIImage(named: "stories-reaction-dislike")?.withRenderingMode(.alwaysTemplate)
        imageButton.imageSize = appearance.imageSize
        imageButton.tintColor = appearance.imageNormalTintColor
        imageButton.addTarget(self, action: #selector(dislikeButtonClicked), for: .touchUpInside)
        return imageButton
    }()
    
    private lazy var dislikeTapProxyView = TapProxyView(targetView: dislikeButton)

    var onLikeClick: (() -> Void)?
    var onDislikeClick: (() -> Void)?

    var state: State = .normal {
        didSet {
            switch state {
            case .normal:
                likeButton.tintColor = appearance.imageNormalTintColor
                dislikeButton.tintColor = appearance.imageNormalTintColor
            case .liked:
                likeButton.tintColor = appearance.imageSelectedTintColor
                dislikeButton.tintColor = appearance.imageNormalTintColor
            case .disliked:
                likeButton.tintColor = appearance.imageNormalTintColor
                dislikeButton.tintColor = appearance.imageSelectedTintColor
            }
        }
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: self.appearance.tapProxyViewSize.height)
    }

    init(
        frame: CGRect = .zero,
        appearance: Appearance = Appearance()
    ) {
        self.appearance = appearance
        super.init(frame: frame)

        self.addSubviews()
        self.makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func likeButtonClicked() {
        self.state = .liked
        self.onLikeClick?()
    }

    @objc
    private func dislikeButtonClicked() {
        self.state = .disliked
        self.onDislikeClick?()
    }

    enum State {
        case normal
        case liked
        case disliked
    }
}

extension StoryReactionsView: ProgrammaticallyInitializableViewProtocol {
    func addSubviews() {
        [likeButton, dislikeButton, likeTapProxyView, dislikeTapProxyView].forEach { addSubview($0) }
    }

    func makeConstraints() {
        
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(appearance.imageSize)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(-appearance.spacing)
        }

        dislikeButton.snp.makeConstraints { make in
            make.size.equalTo(appearance.imageSize)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(appearance.spacing)
        }

        likeTapProxyView.translatesAutoresizingMaskIntoConstraints = false
        likeTapProxyView.snp.makeConstraints { make in
            make.size.equalTo(appearance.tapProxyViewSize)
            make.center.equalTo(likeButton.snp.center)
        }

        dislikeTapProxyView.translatesAutoresizingMaskIntoConstraints = false
        dislikeTapProxyView.snp.makeConstraints { make in
            make.size.equalTo(appearance.tapProxyViewSize)
            make.center.equalTo(dislikeButton.snp.center)
        }
    }
}
