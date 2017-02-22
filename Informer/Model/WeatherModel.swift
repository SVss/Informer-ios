//
//  WeatherModel.swift
//  Informer
//
//  Created by Admin on 2/21/17.
//  Copyright © 2017 BSUIR. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherModelItem {
    private var _cityName: String
    private var _temperature: String
    
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
    
    init(_ cityName: String, temperature: String) {
        self._cityName = cityName
        self._temperature = temperature
    }
}

let YQUERY = "https://query.yahooapis.com/v1/public/yql?q=select%20item.condition.temp%2C%20location.city%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22Minsk%2Cby%22%20or%20text%3D%22Dubrowna%2Cby%22%20or%20text%3D%22Orsha%2Cby%22%20or%20text%3D%22Baran%2Cby%22%20or%20text%3D%22Shklow%2Cby%22%20or%20text%3D%22Mahilyow%2Cby%22%20or%20text%3D%22Buynichy%2Cby%22%20or%20text%3D%22Kirawsk%2Cby%22%20or%20text%3D%22Babruysk%2Cby%22%20or%20text%3D%22Asipovichy%2Cby%22%20or%20text%3D%22Kapyl%2Cby%22%20or%20text%3D%22Nyasvizh%2Cby%22%20or%20text%3D%22Haradzyeya%2Cby%22%20or%20text%3D%22Mir%2Cby%22%20or%20text%3D%22Karelichy%2Cby%22%20or%20text%3D%22Navahrudak%2Cby%22%20or%20text%3D%22Slonim%2Cby%22%20or%20text%3D%22Pruzhany%2Cby%22%20or%20text%3D%22Brest%2Cby%22%20or%20text%3D%22Haradzishcha%2Cby%22%20or%20text%3D%22Vilyeyka%2Cby%22%20or%20text%3D%22Pinsk%2Cby%22%20or%20text%3D%22Baranavichy%2Cby%22%20or%20text%3D%22Navapolatsk%2Cby%22%20or%20text%3D%22Vitsyebsk%2Cby%22%20or%20text%3D%22Homyel%2Cby%22)%20and%20u%3D%27c%27&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="

class WeatherModel {
    private let delegate: WeatherTableReloadAsyncDelegate
    private var _weather: [WeatherModelItem] = []
    
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
    
    init(delegate: WeatherTableReloadAsyncDelegate) {
        self.delegate = delegate
    }
    
    public func refresh() {
        print("*** Start refreshing weather")
        URLCache.shared.removeAllCachedResponses()
        Alamofire.request(YQUERY, encoding: URLEncoding.queryString).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                self._weather = [WeatherModelItem]()
                DispatchQueue.main.async {
                    self.delegate.reloadWeather()
                }
                let json = JSON(value)
                let cities = json["query"]["results"]["channel"]
                for (_,subJson):(String, JSON) in cities {
                    if let city = subJson["location"]["city"].string, let temperature = subJson["item"]["condition"]["temp"].string {
                        let newWeatherItem = WeatherModelItem(city, temperature: temperature)
                        self._weather.append(newWeatherItem)
                        DispatchQueue.main.async {
                            self.delegate.reloadWeather()
                        }
                        print(city, temperature)
                    } else {
                        print("Invalid response format")
                        DispatchQueue.main.async {
                            self.delegate.onError()
                        }
                    }
                }
            case .failure:
                print("Can't load weather info")
                DispatchQueue.main.async {
                    self.delegate.onError()
                }
            }
        }
    }
}
