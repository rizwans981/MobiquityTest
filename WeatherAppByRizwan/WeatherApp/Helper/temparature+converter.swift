//
//  temparature+converter.swift
//  WeatherApp
//  Created by Abdul Rizwan Abdul Basheer Shaikh on 20/06/21.
//  Copyright © 2021 Abdul Rizwan. All rights reserved.
//

import Foundation

import Foundation

struct TemperatureConverter {
    
    // MARK: convert kelvis to Celsius
    static func kelvinToCelsius(_ degrees: Double) -> Int {
        return Int(round(degrees - 273.15))
    }
    
    // MARK: convert kelvis to Fahrenheit
    static func kelvinToFahrenheit(_ degrees: Double) -> Int {
        return Int(round(degrees * 9 / 5 - 459.67))
    }
}
