//
//  NetworkManager.swift
//  WeatherAppTMS
//
//  Created by maxim shiryaev on 3.12.21.
//

import Foundation

class NetworkManager {
    private init() {}
    
    static let shared: NetworkManager = NetworkManager()
    
    func getWeather(from city: String, result: @escaping ((WeatherData?) -> ())) {
        let urlString = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/\(city)?unitGroup=metric&key=U25WC6KGR7TSAFGZXB4LQUQR8&options=nonulls&include=fcst%2Cstats%2Ccurrent"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let task = URLSession(configuration: .default)
        task.dataTask(with: request) { (data, response, error) in
            if error == nil {
                let decoder = JSONDecoder()
                var decoderWeatherData: WeatherData?
                
                if data != nil {
                    decoderWeatherData = try? decoder.decode(WeatherData.self, from: data!)
                }
                result(decoderWeatherData)
            } else {
                print(error as Any)
            }
        }.resume()
    }
    
    func getWeather(from coordinates: (latitude: Double, longitude: Double), result: @escaping ((WeatherData?) -> ())) {
        let urlString = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/\(coordinates.latitude),\(coordinates.longitude)?unitGroup=metric&key=U25WC6KGR7TSAFGZXB4LQUQR8&options=nonulls&include=fcst%2Cstats%2Ccurrent"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let task = URLSession(configuration: .default)
        task.dataTask(with: request) { (data, response, error) in
            if error == nil {
                let decoder = JSONDecoder()
                var decoderWeatherData: WeatherData?
                
                if data != nil {
                    decoderWeatherData = try? decoder.decode(WeatherData.self, from: data!)
                }
                result(decoderWeatherData)
            } else {
                print(error as Any)
            }
        }.resume()
    }
}
