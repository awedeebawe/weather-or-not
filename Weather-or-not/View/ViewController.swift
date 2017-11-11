//
//  ViewController.swift
//  Weather-or-not
//
//  Created by Lyubomir Marinov on 9.11.17.
//  Copyright © 2017 Lyubomir Marinov. All rights reserved.
//

import UIKit

private let mapScreen = "mapScreen"

class ViewController: UIViewController, MapDelegate {
    
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
    
    // MARK: ViewModel methods
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
    
    fileprivate func useRemote() {
        viewModel.updateRemote()
        
        mapBarButton.isEnabled = true
    }
    
    fileprivate func useLocal() {
        viewModel.updateLocal()
        
        mapBarButton.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let mapNavigationController = segue.destination as? UINavigationController,
            let mapViewController = mapNavigationController.viewControllers.first as? MapViewController else {
            return
        }
        
        mapViewController.delegate = self
        mapViewController.viewModel = self.viewModel
    }
    
    // MARK: MapDelegate method
    func hideMap(viewController vc: MapViewController) {
        vc.dismiss(animated: true, completion: nil)
    }
    
    // MARK: IBActions
    @IBAction func changeDataSource(_ sender: UISegmentedControl) {
        sender.selectedSegmentIndex == 0 ? useRemote() : useLocal()
    }
}

