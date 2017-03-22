//
//  FullMapViewController.swift
//  Informer
//
//  Created by Admin on 3/21/17.
//  Copyright © 2017 BSUIR. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FullMapViewController: UIViewController, WeatherReloadAsyncDelegate {
    let alertController = UIAlertController(title: "Error", message: "Can't load weather info", preferredStyle: .alert)
    
    let weatherModel = WeatherModel.getInstance()
    var cityAnnotations = [CityAnnotation]()
    
    internal func reloadWeather() {
        cityAnnotations = [CityAnnotation]()
        for city in weatherModel.getWeather {
            let cityAnnotation = CityAnnotation(city: city)
            cityAnnotations.append(cityAnnotation)
            FullMapView.addAnnotation(cityAnnotation)
        }
    }
    
    internal func onError() {
        present(alertController, animated: true, completion: nil)
    }

    private func setDefaultAlertAction() {
        let defaultAlertAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        )
        alertController.addAction(defaultAlertAction)
    }
    
    @IBOutlet weak var FullMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultAlertAction()
        weatherModel.subscribe(self)
        reloadWeather()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func longPressOnMap(_ sender: UILongPressGestureRecognizer) {
        if (sender.state == .began) {
            print("long press began!")
            
            let locationPoint = sender.location(in: FullMapView)
            let location = FullMapView.convert(locationPoint, toCoordinateFrom: FullMapView)
            let currentLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
            
            var minDist = CLLocationDistance(Int.max)
            var nearestCity: CityAnnotation? = nil
            for city in cityAnnotations {
                let dist = currentLocation.distance(from: city.location)
                if (dist < minDist) {
                    print("next min: ")
                    print(city.latitude, city.longitude)
                    minDist = dist
                    nearestCity = city
                }
            }
            
            if (nearestCity != nil) {
                FullMapView.addAnnotation(nearestCity!)
                showCityOnMap(nearestCity!)
            }
        }
    }
    
    
    func showCityOnMap(_ city: CityAnnotation) {
        FullMapView.selectAnnotation(city, animated: true)
        let region = MKCoordinateRegionMake(city.coordinate, MKCoordinateSpanMake(1, 1))
        FullMapView.setRegion(region, animated: true)
    }
    
}
