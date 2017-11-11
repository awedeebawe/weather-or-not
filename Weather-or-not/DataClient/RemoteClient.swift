//
//  RemoteClient.swift
//  Weather-or-not
//
//  Created by Lyubomir Marinov on 11/10/17.
//  Copyright © 2017 Lyubomir Marinov. All rights reserved.
//

import Foundation

class RemoteClient {

    func fetchForecast(forLat lat: Double, andLon lon: Double, completion: @escaping (ForecastData?) -> ()) {
        guard let forecastUrl = generateUrl(withLat: lat, andLon: lon) else {
            completion(nil)
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: forecastUrl) { (data, _, _) in
            guard let responseData = data else {
                completion(nil)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let forecastData = try decoder.decode(ForecastData.self, from: responseData)
                completion(forecastData)
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
    
    fileprivate func generateUrl(withLat lat: Double, andLon lon: Double) -> URL? {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&units=metric&appid=ab53baebef7edee85bd164c7982488d6"
        
        return URL(string: urlString)
    }
}
