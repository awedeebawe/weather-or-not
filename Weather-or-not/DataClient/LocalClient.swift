//
//  LocalClient.swift
//  Weather-or-not
//
//  Created by Lyubomir Marinov on 11/10/17.
//  Copyright © 2017 Lyubomir Marinov. All rights reserved.
//

import Foundation

class LocalClient {
    
    func fetchDataFromCSV(_ completion: @escaping (ForecastData?) -> ()) {
        guard let csvFile = Bundle.main.path(forResource: "demo", ofType: "csv") else {
            completion(nil)
            return
        }
        
        do {
            let csvPath = URL(fileURLWithPath: csvFile)
            let csvData = try Data(contentsOf: csvPath)
            
            guard let csvString = String(data: csvData, encoding: .utf8) else {
                completion(nil)
                return
            }
            let csvLinesArray = csvString.components(separatedBy: "\n")
            
            let forecastArray = csvLinesArray.map({ (line) -> Forecast in
                return self.buildForecast(fromCSV: line)
            })
            
            let city = City(name: "Sofia")
            
            let forecastData = ForecastData(list: forecastArray, city: city)
            completion(forecastData)
        } catch {
            completion(nil)
        }
    }
    
    fileprivate func buildForecast(fromCSV csvLine: String) -> Forecast {
        let csvData = csvLine.components(separatedBy: ",")
        let date = csvData[0]
        let temperature = Double(csvData[1]) ?? 0.0
        return Forecast.buildFromLocalSourceWithDate(date, andTemp: temperature)
    }
}
