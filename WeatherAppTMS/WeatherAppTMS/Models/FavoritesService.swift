//
//  FavoritesService.swift
//  WeatherAppTMS
//
//  Created by maxim shiryaev on 17.02.22.
//

import Foundation

class FavoritesCityService {
    
    static let shared = FavoritesCityService()
    public var cities: [String] = []
    public let defaults = UserDefaults.standard
    private init() {
        
    }
    
    public var stringKey: String = "key"
    
    
    public func addCity(city: String) {
        self.cities.append(city)
        defaults.set(self.cities, forKey: stringKey)
        
    }
    
    public func removeCity(city: String) {
        if let index = self.cities.firstIndex(of: city) {
            self.cities.remove(at: index)
            defaults.set(self.cities, forKey: stringKey)
        }
    }
    
    
    
    public func getCities() -> [String] {
        let citiesFromStorage = defaults.stringArray(forKey: stringKey) ?? []
        self.cities = citiesFromStorage
        return citiesFromStorage
    }
    
}
