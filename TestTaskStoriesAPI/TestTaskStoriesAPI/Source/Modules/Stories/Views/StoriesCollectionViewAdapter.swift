//
//  StoriesCollectionViewAdapter.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 09.05.2022.
//

import Foundation
import UIKit

protocol StoriesCollectionViewAdapterDelegate: AnyObject {
    func storiesCollectionViewAdapter(
        _ adapter: StoriesCollectionViewAdapter,
        currentItemFrame: CGRect?,
        didSelectComponentAt indexPath: IndexPath
    )
}
    
final class StoriesCollectionViewAdapter: NSObject {
    weak var delegate: StoriesCollectionViewAdapterDelegate?
    
    var components: [StoriesViewModel]
    
    init(components: [StoriesViewModel] = []) {
        self.components = components
        super.init()
    }
}

// MARK: - StoriesCollectionViewAdapter: UICollectionViewDataSource -

extension StoriesCollectionViewAdapter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        components.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(cellType: StoryCollectionViewCell.self, for: indexPath)
        let component = components[indexPath.row]
        cell.update(imagePath: component.cover, title: component.title, isWatched: false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 1, delay: .zero, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut) {
                cell.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.7, delay: .zero, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseIn) {
                cell.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
}

// MARK: - StoriesCollectionViewAdapter: UICollectionViewDelegateFlowLayout -

extension StoriesCollectionViewAdapter: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let generator = UISelectionFeedbackGenerator()
        var currentItemFrame: CGRect? = nil
        if let frame = collectionView.cellForItem(at: indexPath)?.frame {
            currentItemFrame = collectionView.convert(frame, to: UIApplication.shared.keyWindow)
        }
        generator.prepare()
        generator.selectionChanged()
        self.delegate?.storiesCollectionViewAdapter(
            self,
            currentItemFrame: currentItemFrame,
            didSelectComponentAt: indexPath)
    }
}
