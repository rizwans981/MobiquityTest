//
//  CLLocationCoordinate2D.swift
//  WeatherApp
//  Created by Abdul Rizwan Abdul Basheer Shaikh on 20/06/21.
//  Copyright © 2021 Abdul Rizwan. All rights reserved.
//

import Foundation
import CoreLocation.CLLocation

extension CLLocationCoordinate2D: Codable {
    
    enum CodingKeys: String, CodingKey {
        case latitude, longitude
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try values.decode(Double.self, forKey: .latitude)
        let longitude = try values.decode(Double.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        let numbersAfterCommaAccuracy: Double = 4
        let ratio = numbersAfterCommaAccuracy * 10
        let isLatitudeEqual = ((lhs.latitude - rhs.latitude) * ratio).rounded(.down) == 0
        let isLongitudeEqual = ((lhs.latitude - rhs.latitude) * ratio).rounded(.down) == 0
        return isLatitudeEqual && isLongitudeEqual
    }
}
