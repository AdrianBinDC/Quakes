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
        
        // minMag
        let expectedMinMagURL = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&minmag=1.0"
        let actualMinMagURL = apiManager.getURL(minMag: 1.0)
        XCTAssertEqual(expectedMinMagURL, actualMinMagURL?.absoluteString)
        // maxMag
        let expectedMaxMagURL = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&maxmag=1.0"
        let actualMaxMagURL = apiManager.getURL(maxMag: 1.0)
        XCTAssertEqual(expectedMaxMagURL, actualMaxMagURL?.absoluteString)
        // alertLevel: Green
        let expectedGreenAlertURL = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&alertlevel=green"
        let actualGreenAlertURL = apiManager.getURL(alertLevel: .green)
        XCTAssertEqual(expectedGreenAlertURL, actualGreenAlertURL?.absoluteString)
        // alertLevel: Yellow
        let expectedYellowAlertURL = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&alertlevel=yellow"
        let actualYellowAlertURL = apiManager.getURL(alertLevel: .yellow)
        XCTAssertEqual(expectedYellowAlertURL, actualYellowAlertURL?.absoluteString)
        // alertLevel: Orange
        let expectedOrangeAlertURL = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&alertlevel=orange"
        let actualOrangeAlertURL = apiManager.getURL(alertLevel: .orange)
        XCTAssertEqual(expectedOrangeAlertURL, actualOrangeAlertURL?.absoluteString)
        // alertLevel: Red
        let expectedRedAlertURL = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&alertlevel=red"
        let actualRedAlertURL = apiManager.getURL(alertLevel: .red)
        XCTAssertEqual(expectedRedAlertURL, actualRedAlertURL?.absoluteString)
        // minLat
        let expectedMinLatURL = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&minlatitude=0.0"
        let actualMinLatURL = apiManager.getURL(minLat: 0)
        XCTAssertEqual(expectedMinLatURL, actualMinLatURL?.absoluteString)
        // maxLat
        let expectedMaxLatURL = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&maxlatitude=0.0"
        let actualMaxLatURL = apiManager.getURL(maxLat: 0)
        XCTAssertEqual(expectedMaxLatURL, actualMaxLatURL?.absoluteString)
        // minLong
        let expectedMinLong = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&minlongitude=0.0"
        let actualMinLong = apiManager.getURL(minLong: 0)
        XCTAssertEqual(expectedMinLong, actualMinLong?.absoluteString)
        // maxLong
        let expectedMaxLong = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&maxlongitude=0.0"
        let actualMaxLong = apiManager.getURL(maxLong: 0)
        XCTAssertEqual(expectedMaxLong, actualMaxLong?.absoluteString)
        // startTime
        let expectedStartDate = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=2019-10-01T04:00:00Z"
        let actualStartDate = apiManager.getURL(startTime: Date.date(year: 2019, month: 10, day: 1))
        XCTAssertEqual(expectedStartDate, actualStartDate?.absoluteString)
        // endTime
        let expectedEndDate = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&endtime=2019-10-10T04:00:00Z"
        let actualEndDate = apiManager.getURL(endTime: Date.date(year: 2019, month: 10, day: 10))
        XCTAssertEqual(expectedEndDate, actualEndDate?.absoluteString)
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
