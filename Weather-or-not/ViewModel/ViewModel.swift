//
//  ViewModel.swift
//  Weather-or-not
//
//  Created by Lyubomir Marinov on 11/10/17.
//  Copyright © 2017 Lyubomir Marinov. All rights reserved.
//

import Foundation

class ViewModel {
    
    public var forecastData: ForecastData?
    
    var updateStarted: (() -> ())? = nil
    var updateEnded: (() -> ())? = nil
    var updateFailed: (() -> ())? = nil
    
    fileprivate let remoteClient = RemoteClient()
    fileprivate let localClient = LocalClient()
    
    func updateRemote() {
        updateStarted?()
        
        remoteClient.fetchForecast(forLat: 53.241924, andLon: -1.117965) { data in
            guard let forecastData = data else {
                print("Failed to fetch")
                self.updateFailed?()
                return
            }
            
            self.forecastData = forecastData
            
            self.updateEnded?()
        }
    }
    
    func updateLocal() {
        updateStarted?()
        
        localClient.fetchDataFromCSV { data in
            guard let forecastData = data else {
                print("Failed to parse")
                self.updateFailed?()
                return
            }
            
            self.forecastData = forecastData
            
            self.updateEnded?()
        }
    }
    
    func getCurrentCityName() -> String {
        return forecastData?.city.name ?? "Unknown"
    }
    
    func getForecastForUniqueDays() -> [Forecast] {
        guard let data = forecastData else {
            return []
        }
        
        var duplicateDays: [Forecast] = []
        return data.list.flatMap { (forecast) -> Forecast? in
            if duplicateDays.filter({ $0 =~ forecast }).count == 0 {
                duplicateDays.append(forecast)
                return forecast
            } else {
                return nil
            }
        }
    }
    
    func getForecastForSpecificDay(_ day: String) -> [Forecast] {
        guard let data = forecastData else {
            return []
        }
        
        return data.list.filter({ $0.getDateWithoutTime() == day })
    }
    
    func getNumberOfDays() -> Int {
        return getForecastForUniqueDays().count
    }
    
    func getNumberOfHours(forDay day: String) -> Int {
        return getForecastForSpecificDay(day).count
    }
}
