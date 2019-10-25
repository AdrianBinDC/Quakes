//
//  Date+Extension.swift
//  Quakes
//
//  Created by Adrian Bolinger on 10/24/19.
//  Copyright © 2019 Adrian Bolinger. All rights reserved.
//

import Foundation

extension Date {
    var iso8601String: String {
        return ISO8601DateFormatter().string(from: self)
    }
    
    static func date(year: Int, month: Int, day: Int) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        
        return Calendar.current.date(from: components)
    }
}
