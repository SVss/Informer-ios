//
//  CityAnnotation.swift
//  Informer
//
//  Created by Admin on 3/21/17.
//  Copyright © 2017 BSUIR. All rights reserved.
//

import Foundation
import MapKit

class CityAnnotation: NSObject, MKAnnotation {
    var id: Int?
    var title: String?
    var subtitle: String?
    var latitude: Double
    var longitude: Double

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
}
