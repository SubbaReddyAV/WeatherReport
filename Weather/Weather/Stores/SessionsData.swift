//
//  SessionsData.swift
//  Weather
//
//  Created by SubbaReddy on 12/3/2564 BE.
//

import Foundation
import CoreLocation
class SessionsDataManager {
    var savedLocationa: [LocationDetails] = []
    var tempratureType: WeatherValueType = .celsius
    
    private init() {}
    
    static let shared = SessionsDataManager()
}

struct LocationDetails {
    let cityName: String
    let countryName: String
    let lat: CLLocationDegrees
    let lon: CLLocationDegrees
    
    public init(cityName: String,
                countryName: String,
                lat: CLLocationDegrees,
                lon: CLLocationDegrees) {
        self.cityName = cityName
        self.countryName = countryName
        self.lat = lat
        self.lon = lon
    }
}

enum WeatherValueType {
    case celsius
    case fahrenheit
}
