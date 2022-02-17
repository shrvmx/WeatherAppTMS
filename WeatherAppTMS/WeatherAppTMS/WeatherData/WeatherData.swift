//
//  WeatherData.swift
//  WeatherAppTMS
//
//  Created by maxim shiryaev on 3.12.21.
//

import Foundation

struct WeatherData: Codable {
    let address: String?
    let timezone: String?
    let days: [Days]?
    let currentConditions: CurrentConditions
}
struct Days: Codable {
    let datetime: String?
    let tempmax: Double?
    let tempmin: Double?
    let temp: Double?
    let conditions: String?
    let windspeed: Double?
    let feelslike: Double?
    let humidity: Double?
    let sunset: String?
    let sunrise: String?
    let cloudcover: Double?
    let visibility: Double?
}
struct CurrentConditions: Codable {
    let temp: Double?
    let humidity: Double?
    let windspeed: Double?
    let conditions: String?
}
