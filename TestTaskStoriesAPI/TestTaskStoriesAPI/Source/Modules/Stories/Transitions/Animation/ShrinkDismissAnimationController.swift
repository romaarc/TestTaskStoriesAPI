//
//  ShrinkDismissAnimationController.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 10.05.2022.
//

import UIKit

final class ShrinkDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    let interactionController: SwipeInteractionController?

    private let destinationFrame: CGRect

    init(destinationFrame: CGRect, interactionController: SwipeInteractionController?) {
        self.destinationFrame = destinationFrame
        self.interactionController = interactionController
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { 0.2 }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let _ = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from),
              let snapshotView = fromViewController.view.snapshotView(afterScreenUpdates: true) else {
            return
        }

        let containerView = transitionContext.containerView

        snapshotView.frame = fromViewController.view.frame
        snapshotView.layer.masksToBounds = true
        snapshotView.layer.cornerRadius = 0
        
        fromViewController.view.isHidden = true

        containerView.addSubview(snapshotView)

        let duration = self.transitionDuration(using: transitionContext)

        UIView.animate(withDuration: duration, animations: {
            snapshotView.frame = self.destinationFrame
            snapshotView.alpha = 0
            snapshotView.layer.cornerRadius = 16
        }, completion: { _ in
            fromViewController.view.isHidden = false
            snapshotView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
