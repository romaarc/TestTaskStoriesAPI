//
//  ProgrammaticallyInitializableViewProtocol.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 07.05.2022.
//

import UIKit

protocol ProgrammaticallyInitializableViewProtocol: AnyObject {
    func setupView()
    func addSubviews()
    func makeConstraints()
}

extension ProgrammaticallyInitializableViewProtocol where Self: UIView {
    func setupView() {}

    func addSubviews() {}

    func makeConstraints() {}
}
