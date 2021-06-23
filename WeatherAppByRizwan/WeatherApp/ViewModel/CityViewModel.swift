//
//  CityViewModel.swift
//  WeatherApp
//  Created by Abdul Rizwan Abdul Basheer Shaikh on 20/06/21.
//  Copyright © 2021 Abdul Rizwan. All rights reserved.
//

import Foundation

protocol CityViewModelProtocol {
    func reloadCityScreen(cityScreenData: CityScreenData)
    func sendErrorReport(errorMessage:Error)
}


class CityViewModel {
    var latitude: Double
    var longitude: Double
    var viewModelDelegate:CityViewModelProtocol? = nil

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func fetchWeatherDetail() {
        let weatherURL = "http://api.openweathermap.org/data/2.5/weather?lat=\( latitude.toString())&lon=\(longitude.toString())&appid=fae7190d7e6433ec3a45285ffcf55c86"
        
        HTTPManager.shared.get(urlString: weatherURL , completionBlock: { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .failure(let error):
                self.viewModelDelegate?.sendErrorReport(errorMessage: error)
            case .success(let data) :
                let decoder = JSONDecoder()
                do
                        {
                            let cityData = try decoder.decode(CityModel.self, from: data)
                            var cityScreenData: CityScreenData = CityScreenData()
                            cityScreenData.cityNameValue = cityData.name ?? DEFAULT_VALUE
                            let inCelsius:Double = Double(TemperatureConverter.kelvinToCelsius(cityData.main?.temp ?? 0.0))
                            
                            cityScreenData.temparatureValue = CITY_TEMPARATURE + (inCelsius.toString() ) + TEMPARATURE_UNIT
                            cityScreenData.humidityValue = CITY_HUMIDITY + "\(cityData.main?.humidity ?? 0)" + HUMIDITY_UNIT
                            cityScreenData.rainyStatusValue = RAIN_CHANCES + (cityData.weather?[0].weatherDescription ?? DEFAULT_VALUE)
                            cityScreenData.windInfoValue = WIND_SPEED + (cityData.wind?.speed?.toString() ?? DEFAULT_VALUE) + WIND_UNIT
                            self.viewModelDelegate?.reloadCityScreen(cityScreenData: cityScreenData)
                        } catch {
                            // deal with error from JSON decoding if used in production
                            self.viewModelDelegate?.sendErrorReport(errorMessage: error)
                        }
            }
        })
    }
}

struct CityScreenData {
    var cityNameValue: String = DEFAULT_VALUE
    var temparatureValue: String = DEFAULT_VALUE
    var humidityValue: String = DEFAULT_VALUE
    var rainyStatusValue: String = DEFAULT_VALUE
    var windInfoValue: String = DEFAULT_VALUE
}

