//
//  OpenedStoriesPageViewController.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 10.05.2022.
//

import UIKit

protocol OpenedStoriesViewProtocol: AnyObject {
    func set(module: UIViewController, direction: UIPageViewController.NavigationDirection, animated: Bool)
    func close()
}

final class OpenedStoriesPageViewController: UIPageViewController, OpenedStoriesViewProtocol {
    private weak var currentStoryController: UIViewController?

    private var isDragging = false
    
    var presenter: OpenedStoriesPresenterProtocol?
    var swipeInteractionController: SwipeInteractionController?
    
    var startOffset: CGFloat = 0

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    override var shouldAutorotate: Bool { false }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        presenter?.refresh()
        
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }

        let scrollView = view.subviews.filter { $0 is UIScrollView }.first as? UIScrollView
        scrollView?.delegate = self

        swipeInteractionController = SwipeInteractionController(viewController: self, onFinish: { [weak self] in
            self?.presenter?.onSwipeDismiss()
        })

        view.backgroundColor = UIColor.white.withAlphaComponent(0.75)
    }

    func set(module: UIViewController, direction: UIPageViewController.NavigationDirection, animated: Bool) {
        currentStoryController?.removeFromParent()
        currentStoryController = module

        self.addChild(module)
        self.setViewControllers([module], direction: direction, animated: animated, completion: nil)
    }
    
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
}

    // MARK: - OpenedStoriesPageViewController: UIPageViewControllerDataSource -
extension OpenedStoriesPageViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        presenter?.prevModule
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        presenter?.nextModule
    }
}

    // MARK: - OpenedStoriesPageViewController: UIScrollViewDelegate -
extension OpenedStoriesPageViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffset = scrollView.contentOffset.x
        isDragging = true
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isDragging else { return }

        var hasNextModule = true

        if startOffset < scrollView.contentOffset.x {
            hasNextModule = presenter?.nextModule != nil
        } else if startOffset > scrollView.contentOffset.x {
            hasNextModule = presenter?.prevModule != nil
        }

        let positionFromStartOfCurrentPage = abs(startOffset - scrollView.contentOffset.x)
        let percent = positionFromStartOfCurrentPage / view.frame.width

        let dismissThreshold: CGFloat = 0.2
        if percent > dismissThreshold && !hasNextModule {
            close()
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isDragging = false
    }
}
