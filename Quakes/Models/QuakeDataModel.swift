//
//  QuakeDataModel.swift
//  Quakes
//
//  Created by Adrian Bolinger on 10/24/19.
//  Copyright © 2019 Adrian Bolinger. All rights reserved.
//

import Foundation
import CoreLocation

// Documentation Page: https://earthquake.usgs.gov/data/comcat/data-eventterms.php
// API keys: https://earthquake.usgs.gov/earthquakes/feed/v1.0/geojson.php

// MARK: - USGSQuakeData
struct USGSQuakeData: Codable {
    let type: String
    let metadata: Metadata
    let features: [Earthquake]
    let bbox: [Double]
}

// MARK: - Feature
struct Earthquake: Codable, Hashable {
    let type: FeatureType
    let properties: Properties
    let geometry: Geometry
    let id: String
    
    static func == (lhs: Earthquake, rhs: Earthquake) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Geometry
struct Geometry: Codable {
    let type: GeometryType
    let coordinates: [Double]
    
    var clLocation: CLLocation {
        // API always returns an array with two elements
        return CLLocation(latitude: coordinates[0], longitude: coordinates[1])
    }
}

enum GeometryType: String, Codable {
    case point = "Point"
}

// MARK: - Properties
struct Properties: Codable {
    let alert: AlertLevel?
    let cdi: Double?
    let code: String
    let detail: String
    let dmin: Double?
    let felt: Int?
    let gap: Double?
    let ids: String
    let mag: Double?
    let mmi: Double?
    let net: Net
    let nst: Int?
    let place: String
    let rms: Double
    let sig: Int
    let sources: String
    let status: Status
    let time: Int
    let title: String
    let tsunami: Int
    let type: PropertiesType
    let types: String
    let tz: Int?
    let updated: Int
    let url: String
}

enum AlertLevel: String, Codable {
    case green = "green"
    case yellow = "yellow"
    case orange = "orange"
    case red = "red"
}

enum Net: String, Codable {
    case ak = "ak"
    case av = "av"
    case ci = "ci"
    case hv = "hv"
    case ld = "ld"
    case mb = "mb"
    case nc = "nc"
    case nm = "nm"
    case nn = "nn"
    case ok = "ok"
    case pr = "pr"
    case se = "se"
    case us = "us"
    case uu = "uu"
    case uw = "uw"
}

enum Status: String, Codable {
    case automatic = "automatic"
    case reviewed = "reviewed"
}

enum PropertiesType: String, Codable {
    case earthquake = "earthquake"
    case explosion = "explosion"
    case iceQuake = "ice quake"
    case otherEvent = "other event"
    case quarryBlast = "quarry blast"
}

enum FeatureType: String, Codable {
    case feature = "Feature"
}

// MARK: - Metadata
struct Metadata: Codable {
    let api: String
    let count: Int
    let generated: Int
    let status: Int
    let title: String
    let url: String
}
