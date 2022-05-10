//
//  Assembly.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 10.05.2022.
//

import UIKit

struct ModuleContext {
    let moduleDependencies: ModuleDependencies
}

protocol Assembly {
    func makeModule(with context: ModuleContext?) -> UIViewController
}
