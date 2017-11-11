//
//  ViewController.swift
//  Weather-or-not
//
//  Created by Lyubomir Marinov on 9.11.17.
//  Copyright © 2017 Lyubomir Marinov. All rights reserved.
//

import UIKit


class ViewController: UIViewController, MapDelegate {
    
    let rowIdentifier = "forecastRow"
    let cellIdentifier = "forecastCell"
    let mapScreen = "mapScreen"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dataOriginSwitch: UISegmentedControl!
    @IBOutlet weak var titleLoader: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var mapBarButton: UIBarButtonItem!
    
    var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.updateStarted = didStart
        viewModel.updateEnded = didEnd
        viewModel.updateFailed = didFail
        
        tableView.register(UINib.init(nibName: "ForecastRow", bundle: Bundle.main), forCellReuseIdentifier: rowIdentifier)
        tableView.estimatedRowHeight = 150.0
        tableView.rowHeight = UITableViewAutomaticDimension
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

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func didFail() {
        updateTitle("--")
        
        let retryAlert = UIAlertController(title: "Oops...", message: "\nFetching the remote data failed for some reason.\nWhat should I do?", preferredStyle: .alert)
        retryAlert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { (_) in
            self.viewModel.updateRemote()
        }))
        retryAlert.addAction(UIAlertAction(title: "Show the map", style: .default, handler: { (_) in
            self.performSegue(withIdentifier: "showMapSegue", sender: self)
        }))
        retryAlert.addAction(UIAlertAction(title: "Show the local data", style: .default, handler: { (_) in
            self.useLocal()
            self.dataOriginSwitch.selectedSegmentIndex = 1
        }))
        self.navigationController?.present(retryAlert, animated: true, completion: nil)
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
        mapBarButton.title = "Show map"
    }
    
    fileprivate func useLocal() {
        viewModel.updateLocal()
        
        mapBarButton.isEnabled = false
        mapBarButton.title = "Map unavailable"
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
    
    @IBAction func showAcknowledgments() {
        let credits = "Target icon and Weather icons made by Freepik from www.flaticon.com are licensed by Creative Commons BY 3.0"
        
        let acknowledgmentsAlert = UIAlertController(title: "Acknowledgments", message: credits, preferredStyle: .alert)
        acknowledgmentsAlert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.navigationController?.present(acknowledgmentsAlert, animated: true, completion: nil)
    }
}

