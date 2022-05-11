//
//  UIView+Extension.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 10.05.2022.
//

import UIKit

final class TapProxyView: UIView {
    var targetView: UIView?

    convenience init(targetView: UIView) {
        self.init()
        self.targetView = targetView
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        self.bounds.contains(point) ? targetView : nil
    }
}
