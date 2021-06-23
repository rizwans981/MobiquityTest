//
//  CityModel.swift
//  WeatherApp
//  Created by Abdul Rizwan Abdul Basheer Shaikh on 20/06/21.
//  Copyright © 2021 Abdul Rizwan. All rights reserved.
//

import Foundation


//temperature, humidity, rain chances and wind information


struct CityModel: Codable {
    let weather: [Weather]?
    let main: Main?
    let wind: Wind?
    let name: String?
    let cod: Int?
}


// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}


//// MARK: - Weather
struct Weather: Codable {
    let weatherDescription: String?

    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
}
