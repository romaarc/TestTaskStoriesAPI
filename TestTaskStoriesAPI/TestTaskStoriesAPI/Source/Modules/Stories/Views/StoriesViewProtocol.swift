//
//  StoriesViewProtocol.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 09.05.2022.
//
import UIKit

protocol StoriesViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func updateCollectionViewData(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource)
}
