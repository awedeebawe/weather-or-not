//
//  ForecastData.swift
//  Weather-or-not
//
//  Created by Lyubomir Marinov on 11/10/17.
//  Copyright © 2017 Lyubomir Marinov. All rights reserved.
//

import Foundation

struct ForecastData: Codable {
    var list: [Forecast]
    var city: City
}
