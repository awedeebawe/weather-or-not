//
//  ViewController+TableView.swift
//  Weather-or-not
//
//  Created by Lyubomir Marinov on 11.11.17.
//  Copyright © 2017 Lyubomir Marinov. All rights reserved.
//

import UIKit

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }

}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfDays()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = tableView.dequeueReusableCell(withIdentifier: rowIdentifier, for: indexPath) as? ForecastRow else {
            return ForecastRow()
        }
        
        viewModel.updateRow(row, atIndexPath: indexPath)
        row.setupCollectionView(withDelegateAndDataSource: self, atIndexPath: indexPath)
        
        return row
    }
    
}
