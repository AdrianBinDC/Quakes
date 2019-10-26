//
//  APIManager.swift
//  Quakes
//
//  Created by Adrian Bolinger on 10/24/19.
//  Copyright © 2019 Adrian Bolinger. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation


/// Struct to store query parameters for USGS Earthquake Database
struct USGSQueryParams {
    var minMag: Double?
    var maxMag: Double?
    var alertLevel: AlertLevel?
    var minLat: Double?
    var maxLat: Double?
    var minLong: Double?
    var maxLong: Double?
    var startTime: Date?
    var endTime: Date?
}

enum USGSAPIError: Error {
    case configurationError
    case serverError(message: String)
    case decodingError(message: String)
}

struct USGSAPIManager {
    
    enum USGSQueryType {
        case queryParams(params: USGSQueryParams)
        case coordinates(location: CLLocation, radius: Double)
    }
    
    func getData(queryType: USGSQueryType,
                 completion: @escaping(_ earthquakes: [Earthquake]?, _ error: USGSAPIError?) -> Void) {
        var url: URL?
        
        defer {
            if let unwrappedURL = url {
                getData(using: unwrappedURL) { (earthquakes, error) in
                    completion(earthquakes, error)
                }
            } else {
                completion(nil, nil)
            }
        }
        
        switch queryType {
        case .queryParams(let params):
            url = getURL(queryParameters: params)
        case .coordinates(let location, let radius):
            url = getURL(for: location, radius: radius)
        }
    }
    
    private func getData(using url: URL,
                         completion: @escaping (_ earthquakes: [Earthquake]?, _ error: USGSAPIError?) -> Void) {
        AF.request(url).response(queue: DispatchQueue.global(qos: .userInitiated)) { response in
            guard let statusCode = response.response?.statusCode else {
                completion(nil, nil)
                return
            }
            
            switch statusCode {
            case 200..<300:
                if let data = response.data {
                    // decode the JSON
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .millisecondsSince1970
                    do {
                        let decodedResponse = try decoder.decode(USGSQuakeData.self, from: data)
                        completion(decodedResponse.features, nil)
                    } catch {
                        completion(nil, USGSAPIError.decodingError(message: error.localizedDescription))
                    }
                }
            case 400..<500:
                completion(nil, USGSAPIError.serverError(message: response.debugDescription))
            case 500..<600:
                completion(nil, USGSAPIError.configurationError)
            default:
                break
            }
            
        }
    }
    
    func getURL(queryParameters: USGSQueryParams) -> URL? {
        var components = URLComponents(string: "https://earthquake.usgs.gov/fdsnws/event/1/query")
        
        // TODO: Figure out a more compact, but readable way to implement this
        var queryItems: [URLQueryItem] = []
        
        queryItems.append(URLQueryItem(name: "format",
                                       value: "geojson"))
        
        if let minMag = queryParameters.minMag {
            queryItems.append(URLQueryItem(name: "minmag",
                                           value: minMag.string))
        }
        
        if let maxMag = queryParameters.maxMag {
            queryItems.append(URLQueryItem(name: "maxmag",
                                           value: maxMag.string))
        }
        
        if let alertLevel = queryParameters.alertLevel {
            queryItems.append(URLQueryItem(name: "alertlevel",
                                           value: alertLevel.rawValue))
        }
        
        if let minLat = queryParameters.minLat {
            queryItems.append(URLQueryItem(name: "minlatitude",
                                           value: minLat.string))
        }
        
        if let maxLat = queryParameters.maxLat {
            queryItems.append(URLQueryItem(name: "maxlatitude",
                                           value: maxLat.string))
        }
        
        if let minLong = queryParameters.minLong {
            queryItems.append(URLQueryItem(name: "minlongitude",
                                           value: minLong.string))
        }
        
        if let maxLong = queryParameters.maxLong {
            queryItems.append(URLQueryItem(name: "maxlongitude",
                                           value: maxLong.string))
        }
        
        if let startTime = queryParameters.startTime {
            queryItems.append(URLQueryItem(name: "starttime",
                                           value: startTime.iso8601String))
        }
        
        if let endTime = queryParameters.endTime {
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
