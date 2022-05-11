//
//  CGSize+Extension.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 11.05.2022.
//

import UIKit

extension CGSize {
    func sizeByDelta(dw: CGFloat, dh: CGFloat) -> CGSize {
        CGSize(width: self.width + dw, height: self.height + dh)
    }
}
