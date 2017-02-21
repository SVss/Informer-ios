//
//  WeatherModel.swift
//  Informer
//
//  Created by Admin on 2/21/17.
//  Copyright © 2017 BSUIR. All rights reserved.
//

import Foundation

class WeatherModel {
    public var cityName: String
    private var _temperature: Double
    
    public var temperature: String {
        get {
            return String(_temperature) + " \u{00B0}C"
        }
    }
    
    init(_ cityName: String, temperature: Double) {
        self.cityName = cityName
        self._temperature = temperature
    }
}
