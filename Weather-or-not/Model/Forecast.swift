//
//  Forecast.swift
//  Weather-or-not
//
//  Created by Lyubomir Marinov on 11/10/17.
//  Copyright © 2017 Lyubomir Marinov. All rights reserved.
//

import Foundation

struct Forecast: Codable {
    var dateTime: String
    var info: MainInfo
    var weather: [Weather]?
    
    enum CodingKeys: String, CodingKey {
        case dateTime = "dt_txt"
        case info = "main"
        case weather
    }
    
    struct MainInfo: Codable {
        var temp: Double
    }
    
    struct Weather: Codable {
        var main: String
        var icon: String
    }
    
    static func buildFromLocalWithDate(_ date: String, andTemp temperature: Double) -> Forecast {
        return Forecast(dateTime: date, info: MainInfo(temp: temperature), weather: nil)
    }
    
    func getDateWithoutTime() -> String {
        return dateTime.components(separatedBy: " ").first ?? ""
    }
}

precedencegroup CompareByDatePrecedence {
    associativity: right
    higherThan: ComparisonPrecedence
}

infix operator =~: CompareByDatePrecedence

func =~(lhs: Forecast, rhs: Forecast) -> Bool {
    return lhs.getDateWithoutTime() == rhs.getDateWithoutTime()
}
