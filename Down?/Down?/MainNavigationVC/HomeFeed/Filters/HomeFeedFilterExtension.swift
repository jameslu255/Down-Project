//
//  HomeFeedFilterExtension.swift
//  Down?
//
//  Created by Caleb Bolton on 11/24/19.
//

import Foundation
import UIKit

extension HomeViewController {
    // function to allow us to use nib files as well as xib cells.
    func registerFilterNib() {
        let nib = UINib(nibName: CollectionViewCell.nibName, bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
        if let flowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    // creation of collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttons.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier,
                                                        for: indexPath) as? CollectionViewCell {
            let name = buttons[indexPath.row]
            cell.configureCell(buttonName: name)
            return cell
        }
        return UICollectionViewCell()
    }
}
// creates the button sizes and views.
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell: CollectionViewCell = Bundle.main.loadNibNamed(CollectionViewCell.nibName, owner: self, options: nil)?.first as? CollectionViewCell else { return CGSize.zero }
        cell.configureCell(buttonName: buttons[indexPath.row])
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: size.width, height: 30)
    }
}
