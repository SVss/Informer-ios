//
//  WeatherModel.swift
//  Informer
//
//  Created by Admin on 2/21/17.
//  Copyright © 2017 BSUIR. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherModelItem {
    private var _cityName: String
    private var _temperature: String
    private var _location: CLLocation
    
    public var cityName: String {
        get {
            return _cityName
        }
    }
    public var temperature: String {
        get {
            return String(_temperature) + " \u{00B0}C"
        }
    }
    public var location: CLLocation {
        get{
            return self._location
        }
    }
    
    init(_ cityName: String, temperature: String, location: CLLocation) {
        self._cityName = cityName
        self._temperature = temperature
        self._location = location
    }
}

class WeatherModel {
    private var delegates: [WeatherReloadAsyncDelegate] = [WeatherReloadAsyncDelegate]();
    private var _weather: [WeatherModelItem] = []
    private var _refreshing: Bool = false
    
    public var getWeather: [WeatherModelItem] {
        get {
            return _weather
        }
    }
    
    public var count: Int {
        get {
            return _weather.count
        }
    }
    
    let YQUERY = "https://query.yahooapis.com/v1/public/yql?q=select%20item.condition.temp%2C%20wind.direction%2C%20wind.speed%2C%20item.lat%2C%20item.long%2C%20location.city%20from%20weather.forecast%20where%20woeid%20in(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22Minsk%2C%20BY%22%20or%20text%3D%22Dubrovno%2C%20BY%22%20or%20text%3D%22Orsha%2C%20BY%22%20or%20text%3D%22Baran'%2C%20BY%22%20or%20text%3D%22Mahilyow%2C%20BY%22%20or%20text%3D%22Bobruysk%2C%20BY%22%20or%20text%3D%22Osipovichi%2C%20BY%22%20or%20text%3D%22Kopyl'%2C%20BY%22%20or%20text%3D%22Nesvizh%2C%20BY%22%20or%20text%3D%22Mir%2C%20BY%22%20or%20text%3D%22Navahrudak%2C%20BY%22%20or%20text%3D%22Slonim%2C%20BY%22%20or%20text%3D%22Pruzhany%2C%20BY%22%20or%20text%3D%22Brest%2C%20BY%22%20or%20text%3D%22Vileyka%2C%20BY%22%20or%20text%3D%22Pinsk%2C%20BY%22%20or%20text%3D%22Baranavichy%2C%20BY%22%20or%20text%3D%22Navapolatsk%2C%20BY%22%20or%20text%3D%22Vitsyebsk%2C%20BY%22%20or%20text%3D%22Homyel'%2C%20BY%22%20or%20text%3D%22Barysaw%2C%20BY%22)%20and%20u%3D'c'&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
    
    public func subscribe(_ delegate: WeatherReloadAsyncDelegate) {
        self.delegates.append(delegate)
    }
    
    public func refresh() {
        if _refreshing {
            return
        }
        _refreshing = true
        print("*** Start refreshing weather")
        URLCache.shared.removeAllCachedResponses()
        Alamofire.request(YQUERY, encoding: URLEncoding.queryString).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
//                print(value)
                self._weather = [WeatherModelItem]()
                self.invokeReloadWeather()
                let json = JSON(value)
                let cities = json["query"]["results"]["channel"]
                for (_,subJson):(String, JSON) in cities {
                    if let city = subJson["location"]["city"].string,
                        let temperature = subJson["item"]["condition"]["temp"].string,
                        let lat = Double(subJson["item"]["lat"].string!),
                        let long = Double(subJson["item"]["long"].string!)
                    {
                        let location = CLLocation(latitude: lat, longitude: long)
                        let newWeatherItem = WeatherModelItem(city, temperature: temperature, location: location)
                        self._weather.append(newWeatherItem)
                        self.invokeReloadWeather()
                        print(city, temperature, location.coordinate.latitude, location.coordinate.longitude)
                    } else {
                        print("Invalid response format")
                        self.invokeOnError()
                        break
                    }
                }
            case .failure:
                print("Can't load weather info")
                self.invokeOnError()
            }
            self._refreshing = false
        }
    }
    
    private func invokeReloadWeather() {
        for delegate in delegates {
            delegate.reloadWeather()
        }
    }
    
    private func invokeOnError() {
        for delegate in delegates {
            delegate.onError()
        }
    }
}


protocol WeatherReloadAsyncDelegate {
    func reloadWeather()
    func onError()
}
