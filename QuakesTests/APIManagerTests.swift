//
//  APIManagerTests.swift
//  QuakesTests
//
//  Created by Adrian Bolinger on 10/24/19.
//  Copyright © 2019 Adrian Bolinger. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Quakes

class APIManagerTests: XCTestCase {
    
    func testURLGeneration() {
        let apiManager = USGSAPIManager()
        let queryParams = USGSQueryParams(minMag: 1.0,
                                          maxMag: 1.0,
                                          alertLevel: .green,
                                          minLat: 0.0,
                                          maxLat: 0.0,
                                          minLong: 0.0,
                                          maxLong: 0.0,
                                          startTime: Date.date(year: 2019, month: 10, day: 1),
                                          endTime: Date.date(year: 2019, month: 10, day: 10))
        
        let expectedURL = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&minmag=1.0&maxmag=1.0&alertlevel=green&minlatitude=0.0&maxlatitude=0.0&minlongitude=0.0&maxlongitude=0.0&starttime=2019-10-01T04:00:00Z&endtime=2019-10-10T04:00:00Z"
        let actualURL = apiManager.getURL(queryParameters: queryParams)
        XCTAssertEqual(expectedURL, actualURL?.absoluteString)
    }
    
    func testCoordinateURL() {
        let apiManager = USGSAPIManager()
        let tokyo = CLLocation(latitude: 37.6762, longitude: 139.6503)
        let expectedURL = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&latitude=37.6762&longitude=139.6503&maxradiuskm=200.0"
        let actualURL = apiManager.getURL(for: tokyo,
                                          radius: 200)
        XCTAssertEqual(expectedURL, actualURL?.absoluteString)
        
        let tooBigRadius = apiManager.getURL(for: tokyo, radius: 20001.7)
        XCTAssertNil(tooBigRadius)
    }
}
