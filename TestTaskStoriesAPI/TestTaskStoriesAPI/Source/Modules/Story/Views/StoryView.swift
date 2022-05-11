import SnapKit
import UIKit

protocol StoryViewDelegate: AnyObject {
    func onCloseButtonClick()
}

extension StoryView {
    struct Appearance { }
}

final class StoryView: UIView {
    private weak var delegate: StoryViewDelegate?
    
    let appearance: Appearance

    lazy var progressView: SegmentedProgressView = {
        let view = SegmentedProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var partsContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "stories-close-button-icon.pdf"), for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.addTarget(self, action: #selector(onCloseAction), for: .touchUpInside)
        button.setTitleColor(UIColor.white, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var visialEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let effect = UIVisualEffectView(effect: blurEffect)
        effect.translatesAutoresizingMaskIntoConstraints = true
        effect.clipsToBounds = true
        effect.layer.masksToBounds = true
        effect.layer.cornerRadius = 16
        return effect
    }()
    
    lazy var closeButtonTapProxyView: TapProxyView = {
        let view = TapProxyView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
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
    
    init(
        frame: CGRect,
        appearance: Appearance = Appearance(),
        delegate: StoryViewDelegate
    ) {
        self.appearance = appearance
        super.init(frame: frame)
        self.delegate = delegate
        self.setupView()
        self.addSubviews()
        self.makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions on buttons
    @objc
    private func onCloseAction() {
        delegate?.onCloseButtonClick()
    }
}

extension StoryView: ProgrammaticallyInitializableViewProtocol {
    func setupView() {
        backgroundColor = .stepikSystemGray
        progressView.backgroundColor = .white
    }

    func addSubviews() {
        [partsContainerView, progressView, visialEffectView, closeButton, closeButtonTapProxyView].forEach { addSubview($0) }
    }

    func makeConstraints() {
        partsContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(closeButton.snp.top).offset(-16)
            make.height.equalTo(4)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(16)
            make.trailing.equalTo(partsContainerView).offset(-16)
            make.height.width.equalTo(32)
        }
        
        visialEffectView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(closeButton)
            make.height.width.equalTo(closeButton)
        }
        
        closeButtonTapProxyView.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(closeButton)
            make.height.width.equalTo(52)
        }
    }
    
    func add(partView: UIView) {
        partsContainerView.addSubview(partView)
        partView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
