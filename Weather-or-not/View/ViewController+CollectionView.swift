//
//  ViewController+CollectionView.swift
//  Weather-or-not
//
//  Created by Lyubomir Marinov on 11.11.17.
//  Copyright © 2017 Lyubomir Marinov. All rights reserved.
//

import UIKit

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {        
        return viewModel.getNumberOfHours(atRow: collectionView.tag)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ForecastCell else {
            return ForecastCell()
        }
        
        // Because we need the item from the UICollectionView and it's tag (representing the row from the UITableView)
        // an independent IndexPath object is required
        let indexPathFromTable = IndexPath(item: indexPath.item, section: collectionView.tag)
        
        viewModel.updateCell(cell, atIndexPath: indexPathFromTable)
        
        return cell
    }

}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80.0, height: 120.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
    
}
