import UIKit

protocol StoryViewControllerProtocol: AnyObject {
    func displayStoryResult(viewModel: StoryDataFlow.StoryLoad.ViewModel)
    func animate(view: UIView & UIStoryPartViewProtocol)
    func animateProgress(segment: Int, duration: TimeInterval)
    func pause(segment: Int)
    func resume(segment: Int)
    func set(segment: Int, completed: Bool)
}

final class StoryViewController: UIViewController {
    private let interactor: StoryInteractorProtocol
    
    var storyView: StoryView? { self.view as? StoryView }
    
    private var didAppear = false
    private var didLayout = false
    private var onAppearBlock: (() -> Void)?

    init(interactor: StoryInteractorProtocol) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let view = StoryView(
            frame: UIScreen.main.bounds,
            delegate: self)
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        didAppear = true
       
        if didAppear, didLayout { onAppearBlock?() }
        
        interactor.didAppear()
        interactor.resume()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        didLayout = true
        if didAppear, didLayout { onAppearBlock?() }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor.pause()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        didAppear = false
        didLayout = false
        interactor.pause()
    }
}

extension StoryViewController: StoryViewControllerProtocol {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    override var shouldAutorotate: Bool { false }
    
    func displayStoryResult(viewModel: StoryDataFlow.StoryLoad.ViewModel) {
        
        storyView?.progressView.completion = { [weak self] in
            self?.interactor.finishedAnimating()
        }
        
        storyView?.progressView.segmentsCount = viewModel.result.parts?.count ?? 0
        
        let gestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(StoryViewController.didTap(recognizer:))
        )
        
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.cancelsTouchesInView = false
        storyView?.closeButtonTapProxyView.targetView = storyView?.closeButton
        interactor.animate()
    }
    
    private func load() {
        interactor.doStoryLoad(request: .init())
    }
    
    @objc
    private func didTap(recognizer: UITapGestureRecognizer) {
        guard let storyView = storyView else { return }
        let closeLocation = recognizer.location(in: storyView.closeButtonTapProxyView)
        if storyView.closeButtonTapProxyView.bounds.contains(closeLocation) {
            return
        }

        let location = recognizer.location(in: self.view)
        if location.x < view.frame.width / 3 {
            rewind()
            return
        }

        if location.x > view.frame.width / 3 * 2 {
            skip()
            return
        }
    }
    
    private func rewind() {
        interactor.rewind()
    }

    private func skip() {
        interactor.skip()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        interactor.pause()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        interactor.resume()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        interactor.resume()
    }
    
    func animate(view: UIView & UIStoryPartViewProtocol) {
        guard let storyView = storyView else { return }
        if view.isDescendant(of: storyView.partsContainerView) {
            storyView.partsContainerView.bringSubviewToFront(view)
        } else {
            storyView.add(partView: view)
            view.startLoad()
        }
    }
    
    func animateProgress(segment: Int, duration: TimeInterval) {
        if !didAppear {
            onAppearBlock = { [weak self] in
                guard let self = self else { return }
                self.storyView?.progressView.animate(duration: duration, segment: segment)
                self.interactor.resume()
                self.onAppearBlock = nil
            }
        } else {
            storyView?.progressView.animate(duration: duration, segment: segment)
            interactor.resume()
        }
    }
    
    func pause(segment: Int) {
        storyView?.progressView.pause(segment: segment)
    }
    
    func resume(segment: Int) {
        storyView?.progressView.resume(segment: segment)
    }
    
    func set(segment: Int, completed: Bool) {
        storyView?.progressView.set(segment: segment, completed: completed)
    }
}

extension StoryViewController: StoryViewDelegate {
    func onCloseButtonClick() {
        dismiss(animated: true, completion: nil)
    }
}
