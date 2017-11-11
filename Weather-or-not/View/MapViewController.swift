//
//  MapViewController.swift
//  Weather-or-not
//
//  Created by Lyubomir Marinov on 11/11/17.
//  Copyright © 2017 Lyubomir Marinov. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

protocol MapDelegate: class {
    func hideMap(viewController vc: MapViewController)
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    weak var delegate: MapDelegate?
    
    var viewModel: ViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let viewModel = viewModel else {
            return
        }
        
        mapView.delegate = self
        mapView.centerCoordinate = viewModel.currentLocation
    }

    // MARK: IBActions
    @IBAction func hideMap() {
        delegate?.hideMap(viewController: self)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(mapView.centerCoordinate)
    }
}
