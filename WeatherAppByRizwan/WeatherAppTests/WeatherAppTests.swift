//
//  WeatherAppTests.swift
//  WeatherAppTests
//  Created by Abdul Rizwan Abdul Basheer Shaikh on 20/06/21.
//  Copyright © 2021 Abdul Rizwan. All rights reserved.
//

import XCTest
@testable import WeatherApp

class WeatherAppTests: XCTestCase {
    
    
    var viewModel: CityViewModel? = nil
    var homeViewModel: HomeViewModel? = nil
    
    var service: HTTPManager!
    var sessionUnderTest : URLSession!
    var url: URL?
    
    
    override func setUp() {
        super.setUp()
        
        // setting default session configuration
        sessionUnderTest = URLSession(configuration : URLSessionConfiguration.default)
        let  weatherURL = "http://api.openweathermap.org/data/2.5/weather?lat=13.1&lon=80.3&appid=fae7190d7e6433ec3a45285ffcf55c86"
        // setting url string directy with query parameters
        url = URL(string: weatherURL)
    }
    
    
    //MARK: Slow failure Async test
    // API success test case
    func testAPISuccessStatus200(){
        
        // status code 200
        let promise = expectation(description: "Status code : 200")
        
        sessionUnderTest.dataTask(with: url!) { (data, response, error) in
            if let error = error{
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else{
                    XCTFail("Status code = \(statusCode)")
                }
            }
        }.resume()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testWeatherAPIWorking() throws {
        let expectation = XCTestExpectation.init(description: "Your expectation")
        let givenName = "Chennai"
        let  weatherURL = "http://api.openweathermap.org/data/2.5/weather?lat=13.1&lon=80.3&appid=fae7190d7e6433ec3a45285ffcf55c86"
        HTTPManager.shared.get(urlString: weatherURL, completionBlock: { [weak self] result in
                  guard let self = self else {return}
                  switch result {
                  case .failure(let error):
                      print ("failure", error)
                  case .success(let data) :
                      let decoder = JSONDecoder()
                      do
                              {
                                  let cityData = try decoder.decode(CityModel.self, from: data)
                                XCTAssertEqual(cityData.name!, givenName, "Given name is matched with expected value")
                              } catch {
                                  // deal with error from JSON decoding if used in production
                                  print(error)
                              }
                  }
                  DispatchQueue.main.async {
                      expectation.fulfill()
                  }
              })
              wait(for: [expectation], timeout: 10)
          }
        
    override func tearDown() {
        service = nil
        super.tearDown()
    }
    
}
