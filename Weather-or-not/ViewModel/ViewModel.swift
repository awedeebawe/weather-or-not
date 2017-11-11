//
//  ViewModel.swift
//  Weather-or-not
//
//  Created by Lyubomir Marinov on 11/10/17.
//  Copyright © 2017 Lyubomir Marinov. All rights reserved.
//

import UIKit
import CoreLocation

class ViewModel {
    
    // Initial location: London, of course :)
    public var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 51.509865, longitude: -0.118092)
    
    private var forecastValues: [String: [Forecast]] = [:]
    private var selectedCity: City?
    
    public var updateStarted: (() -> ())? = nil
    public var updateEnded: (() -> ())? = nil
    public var updateFailed: (() -> ())? = nil
    
    fileprivate let remoteClient = RemoteClient()
    fileprivate let localClient = LocalClient()
    
    // It's a consuming process to generate formatter, so let's store one up here
    fileprivate let formatter = DateFormatter()
    
    // MARK: Data fetching
    func updateRemote() {
        updateStarted?()
        
        remoteClient.fetchForecast(forLat: currentLocation.latitude, andLon: currentLocation.longitude) { data in
            guard let forecastData = data else {
                self.updateFailed?()
                return
            }
            
            self.extractValuesFromResponseObject(forecastData)
            self.selectedCity = forecastData.city

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
            
            self.extractValuesFromResponseObject(forecastData)
            self.selectedCity = forecastData.city
            
            self.updateEnded?()
        }
    }
    
    // MARK: UITableView cell information setup
    func updateRow(_ row: ForecastRow, atIndexPath indexPath: IndexPath) {
        let dayString = getDate(forRow: indexPath.section)
        row.dayLabel.text = formatDay(fromString: dayString)
    }
    
    // MARK: UICollectionView cell information setup
    func updateCell(_ cell: ForecastCell, atIndexPath indexPath: IndexPath) {
        guard let forecastObject = getForecastObject(atIndexPath: indexPath) else {
            return
        }
        cell.timeLabel.text = forecastObject.getTimeWithoutDate()
        cell.tempLabel.text = "\(forecastObject.getTemperature())°"
        cell.iconImage.image = UIImage(named: forecastObject.getWeatherIcon()) ?? UIImage()
    }

    fileprivate func getDate(forRow row: Int) -> String {
        return forecastValues.keys.sorted { $0 < $1 }[row]
    }
    
    fileprivate func formatDay(fromString dateString: String) -> String {
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else {
            // Not the original format
            return dateString
        }
        
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    /// Get the selected city name (if present)
    func getCurrentCityName() -> String {
        return selectedCity?.name ?? "Unknown"
    }
    
    /// Get all the hour for a specific day
    func getForecastsForSpecificDay(_ day: String) -> [Forecast] {
        return forecastValues[day] ?? []
    }
    
    /// Get the specific object depending on the day and hour (table row and collection cell)
    func getForecastObject(atIndexPath indexPath: IndexPath) -> Forecast? {
        let dayString = getDate(forRow: indexPath.section)
        
        return forecastValues[dayString]?[indexPath.item]
    }
    
    /// Get number of the unique fetched days
    func getNumberOfDays() -> Int {
        return forecastValues.keys.count
    }
    
    /// Get the number of the hours per day fetched
    func getNumberOfHours(atRow row: Int) -> Int {
        let dayString = getDate(forRow: row)
        
        return forecastValues[dayString]?.count ?? 0
    }
    
    // MARK: Private helper methods
    fileprivate func extractValuesFromResponseObject(_ forecastResponse: ForecastData) {
        forecastValues.removeAll()
        forecastResponse.list.forEach { (forecast) in
            let forecastDate = forecast.getDateWithoutTime()
            
            if forecastValues[forecastDate] == nil {
                forecastValues[forecastDate] = []
            }
            
            forecastValues[forecastDate]?.append(forecast)
        }
        
    }
}
