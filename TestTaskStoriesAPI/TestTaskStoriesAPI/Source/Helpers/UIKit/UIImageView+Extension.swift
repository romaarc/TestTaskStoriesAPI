//
//  UIImageView+Extension.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 09.05.2022.
//

import UIKit.UIImageView
import Kingfisher

extension UIImageView {
    func setImage(with url: URL?) {
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url)
    }
    
    func setImageOffline(with url: URL?) {
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, options: [.onlyFromCache])
    }
}
