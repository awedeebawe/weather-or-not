//
//  CsvGenerator.swift
//  csv-generator
//
//  Created by Lyubomir Marinov on 8.11.17.
//

import Foundation

public final class CsvGenerator {
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        
        return formatter
    }
    
    /// Build CSV String and save it in a file
    public func buildCSVFile() {
        let lines = generateCSVLines().joined(separator: "\n")
        
        let csvFilePath = FileManager.default.currentDirectoryPath + "/demo.csv"
        
        do {
            try lines.write(toFile: csvFilePath, atomically: true, encoding: .utf8)
            print("SUCCESS: Your CSV file was saved successfully 🤘")
        } catch {
            print("ERROR: Cannot save CSV file 😭")
        }
    }
    
    /// Generate random CSV values
    private func generateCSVLines() -> [String] {
        // Create empty array to hold the strings
        var csvLines: [String] = []
        
        // Loop "through" the next five days
        for day in 1...5 {
            // Loop the hours
            for hour in stride(from: 0, to: 24, by: 3) {
                // get the next day + it's hour
                if let futureDay = self.buildDate(After: day, bySetting: hour) {
                    let csvLine = self.createCSVLine(fromDate: futureDay)
                    csvLines.append(csvLine)
                }
            }
        }
        
        return csvLines
    }
    
    /// Generate Date object by setting the number of days since today and the specific hour
    private func buildDate(After nDays: Int, bySetting hour: Int) -> Date? {
        // Create today, with specific hour...
        guard let date = Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: Date()) else {
            return nil
        }
        
        // ... and return Date object with the necessary number of days added
        return Calendar.current.date(byAdding: .day, value: nDays, to: date)
    }
    
    /// For the sake of clean code, the CSV line generation is moved to a separate method
    private func createCSVLine(fromDate date: Date) -> String {
        let futureDayString = self.dateFormatter.string(from: date)
        // Get a random 0-20 deg. Celsius temperature and turn it into Kelvin (sort of, I omitted the decimal part)
        let randomTempInKelvin = arc4random_uniform(20) + 273
        
        // Now assemble the values into one CSV line
        return "\(futureDayString),\(randomTempInKelvin)"
    }
}
