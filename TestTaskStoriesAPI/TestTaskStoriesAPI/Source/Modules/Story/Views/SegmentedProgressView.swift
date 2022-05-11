//
//  SegmentedProgressView.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 10.05.2022.
//

import SnapKit
import UIKit

extension SegmentedProgressView {
    struct Appearance {
        let spacing: CGFloat = 5
        let barColor = UIColor.white.withAlphaComponent(0.5)
        let progressColor = UIColor.white.withAlphaComponent(1)
    }
}

final class SegmentedProgressView: UIView {
    var appearance = Appearance()
    
    private lazy var progressesStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [])
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = self.appearance.spacing
        return stack
    }()
    
    private var progressViews: [SegmentAnimatedProgressView] = []
    private var didLayout = false
    
    var isAutoPlayEnabled = false
    var completion: (() -> Void)?
    
    var segmentsCount = 0 {
        didSet {
            addProgresses()
        }
    }
    
    init(
        frame: CGRect = .zero,
        appearance: Appearance = Appearance()
    ) {
        self.appearance = appearance
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        progressesStackView.layoutIfNeeded()
        progressViews.forEach { $0.layoutIfNeeded() }
    }

    private func setupView() {
        addSubview(progressesStackView)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear

        progressesStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().priority(.required)
        }
    }

    private func addProgresses() {
        progressViews.forEach { progressesStackView.removeArrangedSubview($0) }
        progressViews = []

        for _ in 0..<segmentsCount {
            let progressView = SegmentAnimatedProgressView(
                barColor: self.appearance.barColor,
                progressColor: self.appearance.progressColor
            )

            progressesStackView.addArrangedSubview(progressView)
            progressViews += [progressView]
        }

        progressesStackView.setNeedsLayout()
        progressesStackView.layoutIfNeeded()
    }

    private func isInBounds(index: Int) -> Bool { index >= 0 && index < segmentsCount }

    func animate(duration: TimeInterval, segment: Int) {
        guard isInBounds(index: segment) else {
            completion?()
            return
        }

        for id in 0..<segmentsCount {
            set(segment: id, completed: id < segment)
        }

        progressViews[segment].animate(duration: duration, completion: completion)
    }

    func set(segment: Int, completed: Bool) {
        guard isInBounds(index: segment) else { return }
        progressViews[segment].set(progress: completed ? 1 : 0)
    }

    func pause(segment: Int) {
        guard isInBounds(index: segment) else { return }
        progressViews[segment].isPaused = true
    }

    func resume(segment: Int) {
        guard isInBounds(index: segment) else { return }
        progressViews[segment].isPaused = false
    }
}

private final class SegmentAnimatedProgressView: UIView {
    let bottomSegmentView = UIView()
    let topSegmentView = UIView()
    
    private weak var progressTimer: Timer?
   
    private var topWidthConstraint: Constraint?
    private var didLayout = false
    private var didFinishAnimations: Bool?
    private var duration: TimeInterval?
    private var progress: Double?
    private var completion: (() -> Void)?
    private var progressTimerRunCount: Double = 0
    
    private let progressTimerTimeInterval: TimeInterval = 0.1

    var isPaused = false {
        didSet {
            guard isPaused != oldValue else {
                return
            }

            if isPaused {
                let pausedTime = topSegmentView.layer.convertTime(CACurrentMediaTime(), from: nil)
                topSegmentView.layer.speed = 0.0
                topSegmentView.layer.timeOffset = pausedTime

                progressTimer?.invalidate()
            } else {
                let pausedTime = topSegmentView.layer.timeOffset
                topSegmentView.layer.speed = 1.0
                topSegmentView.layer.timeOffset = 0.0
                topSegmentView.layer.beginTime = 0.0
                let timeSincePause = topSegmentView.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
                topSegmentView.layer.beginTime = timeSincePause

                let shouldRestoreAnimation = didFinishAnimations == false
                    && (progress != nil && progress! < 1)
                    && (topSegmentView.layer.animationKeys()?.isEmpty ?? true)

                if shouldRestoreAnimation {
                    restoreAnimationFromCurrentPosition()
                } else if let duration = duration {
                    scheduleTimer(duration: duration)
                }
            }
        }
    }

    init(barColor: UIColor, progressColor: UIColor) {
        bottomSegmentView.backgroundColor = barColor
        topSegmentView.backgroundColor = progressColor
        super.init(frame: CGRect.zero)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public API
    func set(progress: CGFloat) {
        isPaused = false
        didFinishAnimations = nil
        duration = nil
        self.progress = nil
        completion = nil
        progressTimerRunCount = 0
        progressTimer?.invalidate()

        topSegmentView.layer.removeAllAnimations()
        topWidthConstraint?.deactivate()
        topSegmentView.snp.makeConstraints { make in
            self.topWidthConstraint = make.width
                .equalTo(self.snp.width)
                .multipliedBy(progress == 0 ? CGFloat.leastNormalMagnitude : progress)
                .constraint
        }
        topWidthConstraint?.activate()

        updateConstraints()
        setNeedsLayout()
        layoutIfNeeded()
    }

    func animate(duration: TimeInterval, completion: (() -> Void)?) {
        self.duration = duration
        self.completion = completion

        startAnimation(duration: duration, beginFromCurrentPosition: false, completion: completion)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        bottomSegmentView.layer.cornerRadius = frame.height / 2
        topSegmentView.layer.cornerRadius = frame.height / 2

        isPaused = false
        topSegmentView.layoutIfNeeded()
        bottomSegmentView.layoutIfNeeded()
    }

    // MARK: Private API
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        [bottomSegmentView, topSegmentView].forEach { addSubview($0) }

        alignToSelf(view: topSegmentView)
        topSegmentView.snp.makeConstraints { make in
            self.topWidthConstraint = make.width
                .equalTo(self.snp.width)
                .multipliedBy(CGFloat.leastNormalMagnitude)
                .constraint
        }
        topWidthConstraint?.activate()

        alignToSelf(view: bottomSegmentView)
        bottomSegmentView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
    }

    private func alignToSelf(view: UIView) {
        view.snp.makeConstraints { make in
            make.bottom.leading.top.equalToSuperview()
        }
    }

    private func startAnimation(
        duration: TimeInterval,
        beginFromCurrentPosition: Bool = false,
        completion: (() -> Void)? = nil
    ) {
        isPaused = false
        didFinishAnimations = nil

        var animationDuration = duration

        if beginFromCurrentPosition,
           let progress = progress {
            animationDuration = duration - (duration * progress)
            let currentWidth = bounds.width * CGFloat(progress)

            topWidthConstraint?.deactivate()
            topSegmentView.snp.makeConstraints { make in
                self.topWidthConstraint = make.width.equalTo(currentWidth).constraint
            }
            topWidthConstraint?.activate()

            updateConstraints()
            setNeedsLayout()
            layoutIfNeeded()
        }

        topWidthConstraint?.deactivate()
        topSegmentView.snp.makeConstraints { make in
            self.topWidthConstraint = make.width.equalTo(self.snp.width).multipliedBy(1).constraint
        }
        topWidthConstraint?.activate()

        setNeedsLayout()

        UIView.animate(
            withDuration: animationDuration,
            delay: 0.0,
            options: .curveLinear,
            animations: {
                self.layoutIfNeeded()
            },
            completion: { [weak self] finished in
                guard let self = self else { return }

                if !finished {
                    self.didFinishAnimations = false
                    return
                }

                self.didFinishAnimations = true
                self.isPaused = true

                completion?()
            }
        )

        scheduleTimer(duration: duration)
    }

    private func restoreAnimationFromCurrentPosition() {
        guard let duration = self.duration, let completion = self.completion else { return }
        startAnimation(duration: duration, beginFromCurrentPosition: true, completion: completion)
    }

    private func scheduleTimer(duration: Double) {
        progressTimer?.invalidate()

        let newTimer = Timer(
            timeInterval: self.progressTimerTimeInterval,
            repeats: true,
            block: { [weak self] timer in
                guard let self = self else {
                    timer.invalidate()
                    return
                }

                self.progressTimerRunCount += 1
                let progress = min(
                    1.0,
                    (self.progressTimerTimeInterval * self.progressTimerRunCount) / duration
                )

                if progress >= 1.0 {
                    self.progressTimer?.invalidate()
                }
                self.progress = progress
            }
        )
        self.progressTimer = newTimer
        RunLoop.current.add(newTimer, forMode: .common)
    }
}
