//
//  ViewController.swift
//  Weather-or-not
//
//  Created by Lyubomir Marinov on 9.11.17.
//  Copyright © 2017 Lyubomir Marinov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLoader: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var mapBarButton: UIBarButtonItem!
    
    var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.updateStarted = didStart
        viewModel.updateEnded = didEnd
        viewModel.updateFailed = didFail
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.updateRemote()
    }
    
    func didStart() {
        updateTitle(nil)
    }
    
    func didEnd() {
        updateTitle(viewModel.getCurrentCityName())
        
        if let today = viewModel.getForecastForUniqueDays().first {
            let todayHours = viewModel.getForecastForSpecificDay(today.getDateWithoutTime())
        }
        
    }
    func didFail() {
        updateTitle("--")
    }

    @IBAction func changeDataSource(_ sender: UISegmentedControl) {
        sender.selectedSegmentIndex == 0 ? useRemote() : useLocal()
    }
    
    fileprivate func useRemote() {
        viewModel.updateRemote()
        
        mapBarButton.isEnabled = true
    }
    
    fileprivate func useLocal() {
        viewModel.updateLocal()
        
        mapBarButton.isEnabled = false
    }
    
    fileprivate func updateTitle(_ title: String?) {
        DispatchQueue.main.async {
            guard let title = title else {
                self.titleLabel.isHidden = true
                self.titleLoader.isHidden = false
                
                return
            }
            
            self.titleLabel.isHidden = false
            self.titleLabel.text = title
            self.titleLoader.isHidden = true
        }
    }
}

