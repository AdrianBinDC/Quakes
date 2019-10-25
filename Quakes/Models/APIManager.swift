//
//  APIManager.swift
//  Quakes
//
//  Created by Adrian Bolinger on 10/24/19.
//  Copyright © 2019 Adrian Bolinger. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import CoreLocation

struct USGSAPIManager {
    
    
    /// Generates an URL for USGS Earthquake Database Endpoint
    /// - Parameter minMag: minimum magnitude (Optional)
    /// - Parameter maxMag: maximum magnitude (Optional)
    /// - Parameter alertLevel: Alert Level (green, yellow, orange, or red)
    /// - Parameter minLat: minimum latitude (Optional)
    /// - Parameter maxLat: maximum latitude (Optional)
    /// - Parameter minLong: minimum longitude (Optional)
    /// - Parameter maxLong: maximum longitude (Optional)
    /// - Parameter startTime: start time (Optional, UTC)
    /// - Parameter endTime: end time (Optional, UTC)
    func getURL(minMag: Double? = nil,
                maxMag: Double? = nil,
                alertLevel: AlertLevel? = nil,
                minLat: Double? = nil,
                maxLat: Double? = nil,
                minLong: Double? = nil,
                maxLong: Double? = nil,
                startTime: Date? = nil,
                endTime: Date? = nil) -> URL? {
        var components = URLComponents(string: "https://earthquake.usgs.gov/fdsnws/event/1/query")
        
        // TODO: Figure out a more compact, but readable way to implement this
        var queryItems: [URLQueryItem] = []
        
        queryItems.append(URLQueryItem(name: "format",
                                       value: "geojson"))
        
        if let minMag = minMag {
            queryItems.append(URLQueryItem(name: "minmag",
                                           value: minMag.string))
        }
        
        if let maxMag = maxMag {
            queryItems.append(URLQueryItem(name: "maxmag",
                                           value: maxMag.string))
        }
        
        if let alertLevel = alertLevel {
            queryItems.append(URLQueryItem(name: "alertlevel",
                                           value: alertLevel.rawValue))
        }
        
        if let minLat = minLat {
            queryItems.append(URLQueryItem(name: "minlatitude",
                                           value: minLat.string))
        }
        
        if let maxLat = maxLat {
            queryItems.append(URLQueryItem(name: "maxlatitude",
                                           value: maxLat.string))
        }
        
        if let minLong = minLong {
            queryItems.append(URLQueryItem(name: "minlongitude",
                                           value: minLong.string))
        }
        
        if let maxLong = maxLong {
            queryItems.append(URLQueryItem(name: "maxlongitude",
                                           value: maxLong.string))
        }
        
        if let startTime = startTime {
            queryItems.append(URLQueryItem(name: "starttime",
                                           value: startTime.iso8601String))
        }
        
        if let endTime = endTime {
            queryItems.append(URLQueryItem(name: "endtime",
                                           value: endTime.iso8601String))
        }
        
        components?.queryItems = queryItems
        
        return components?.url
    }
    
    
    /// Generates an URL for a given CLLocation with a specified radius in kilometers
    /// - Parameter location: A CLLocation with latitude and longitude coordinates
    /// - Parameter radius: A radius in kilometers
    func getURL(for location: CLLocation,
                radius: Double) -> URL? {
        // 20_001.6 is the maximum value accepted by the API
        guard radius <= 20001.6 else {
            return nil
        }
        var components = URLComponents(string: "https://earthquake.usgs.gov/fdsnws/event/1/query")
        
        var queryItems: [URLQueryItem] = []
        
        queryItems.append(URLQueryItem(name: "format",
                                       value: "geojson"))
        
        queryItems.append(URLQueryItem(name: "latitude",
                                       value: location.coordinate.latitude.string))
        
        queryItems.append(URLQueryItem(name: "longitude",
                                       value: location.coordinate.longitude.string))
        
        queryItems.append(URLQueryItem(name: "maxradiuskm",
                                       value: radius.string))
        
        
        components?.queryItems = queryItems
        
        return components?.url
    }
    
}
