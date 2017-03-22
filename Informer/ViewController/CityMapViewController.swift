//
//  FullMapViewController.swift
//  Informer
//
//  Created by Admin on 3/21/17.
//  Copyright © 2017 BSUIR. All rights reserved.
//

import UIKit
import MapKit

class CityMapViewController: UIViewController {
    
    @IBOutlet weak var CityMapOutlet: MKMapView!
    
    private var _cityAnnotation: CityAnnotation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if _cityAnnotation != nil {
            let cityPin = _cityAnnotation!
            CityMapOutlet.addAnnotation(cityPin)
            CityMapOutlet.selectAnnotation(cityPin, animated: true)
            let region = MKCoordinateRegionMake(cityPin.coordinate, MKCoordinateSpanMake(1, 1))
            CityMapOutlet.setRegion(region, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    public func selectCity(_ cityAnnotation: CityAnnotation) {
        self._cityAnnotation = cityAnnotation
    }
    
}
