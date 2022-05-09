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
        self.components.count
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
    }


// MARK: - StoriesCollectionViewAdapter: UICollectionViewDelegateFlowLayout -

extension StoriesCollectionViewAdapter: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let generator = UISelectionFeedbackGenerator()
//        let viewModel = viewModels[indexPath.row]
//        generator.selectionChanged()
//        output.onCellTap(with: viewModel)
        //self.delegate?.StoriesCollectionViewAdapterDelegate(self, didSelectComponentAt: indexPath)
    }
}
