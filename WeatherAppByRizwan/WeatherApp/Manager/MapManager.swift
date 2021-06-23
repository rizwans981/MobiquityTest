//
//  MapManager.swift
//  WeatherApp
//  Created by Abdul Rizwan Abdul Basheer Shaikh on 20/06/21.
//  Copyright © 2021 Abdul Rizwan. All rights reserved.
//

import Foundation

import MapKit

class MapMananger { }

extension MapMananger {
    
    class func fetchLocalSearch(with keywords: String, region: MKCoordinateRegion,  completion: @escaping (_ result: Result<MKLocalSearch.Response, Error>) -> ()) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = keywords
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let response = response {
                print(response)
                completion(.success(response))
            }
            
            if let error = error {
                completion(.failure(error))
            }
        }
    }
}

extension MapMananger {
    
    class func reverseCoordinate(_ coordinate: CLLocationCoordinate2D, completion: @escaping (_ result: Result<[MKPlacemark], Error>) -> ())  {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (clPlacemarks, error) in
            if let clPlacemarks = clPlacemarks {
                let placemarks = clPlacemarks.map { (clPlacemark) -> MKPlacemark in
                    return MKPlacemark(placemark: clPlacemark)
                }
                completion(.success(placemarks))
            }
            
            if let error = error {
                completion(.failure(error))
            }
        }
    }
}
