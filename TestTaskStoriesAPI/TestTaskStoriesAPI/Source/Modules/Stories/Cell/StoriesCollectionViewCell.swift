//
//  StoriesCollectionViewCell.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 09.05.2022.
//

import SnapKit
import UIKit

final class StoryCollectionViewCell: UICollectionViewCell {
    
    private let gradientImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "stories-gradient-light.pdf"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let backgroundContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 13
        view.clipsToBounds = true
        view.contentMode = .scaleToFill
        view.layer.masksToBounds = true
        return view
    }()
    
    private let contentContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.stepikBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 13
        view.clipsToBounds = true
        view.contentMode = .scaleToFill
        view.layer.masksToBounds = true
        return view
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.stepikAccentFixed.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.textAlignment = .natural
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.shadowOffset = CGSize(width: 0, height: -1)
        label.contentMode = .left
        label.font = Font.sber(ofSize: Font.Size.eleven, weight: .regular)
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        
        label.attributedText = NSMutableAttributedString(string: "", attributes: [.kern: -0.41, .paragraphStyle: paragraphStyle])
        return label
    }()

    var isWatched = true {
        didSet {
            gradientImageView.isHidden = isWatched
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .center
        self.addSubviews()
        self.makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StoryCollectionViewCell: ProgrammaticallyInitializableViewProtocol {
    func addSubviews() {
        [gradientImageView, backgroundContentView].forEach { contentView.addSubview($0) }
        backgroundContentView.addSubview(contentContainerView)
        [imageView, overlayView, titleLabel].forEach { contentContainerView.addSubview($0) }
    }

    func makeConstraints() {
        gradientImageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        backgroundContentView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(2)
            make.bottom.trailing.equalToSuperview().offset(-2)
        }
        
        contentContainerView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(2)
            make.bottom.trailing.equalToSuperview().offset(-2)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        overlayView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.bottom.equalToSuperview().offset(-8)
        }
    }
    
    func update(imagePath: String, title: String, isWatched: Bool) {
        imageView.setImage(with: URL(string: imagePath))
        titleLabel.text = title
        self.isWatched = isWatched
    }
}
