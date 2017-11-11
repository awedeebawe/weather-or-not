//
//  ForecastRow.swift
//  Weather-or-not
//
//  Created by Lyubomir Marinov on 11.11.17.
//  Copyright © 2017 Lyubomir Marinov. All rights reserved.
//

import UIKit

class ForecastRow: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        collectionView.register(UINib.init(nibName: "ForecastCell", bundle: Bundle.main), forCellWithReuseIdentifier: "forecastCell")
    }

    func setupCollectionView<DnDS: UICollectionViewDelegate & UICollectionViewDataSource>(withDelegateAndDataSource delegateAndDataSource: DnDS, atIndexPath indexPath: IndexPath) {
        
        collectionView.contentInset = UIEdgeInsetsMake(0.0, 4.0, 0.0, 4.0)
        collectionView.delegate = delegateAndDataSource
        collectionView.dataSource = delegateAndDataSource
        collectionView.tag = indexPath.section
        
        collectionView.reloadData()
    }
}
