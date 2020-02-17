//
//  CommonExtensions.swift
//  WeatheriOS
//
//  Created by KasimOzdemir on 31.01.2020.
//  Copyright © 2020 KasimOzdemir. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension UIColor {
    convenience init(_ hexString: String, alpha: CGFloat = 1.0) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (r, g, b) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: alpha)
    }
    
    
    public func setOpacity(_ opacity: CGFloat) -> UIColor {
        
        let rgb = self.cgColor.components
        return UIColor(red: rgb![0], green: rgb![1], blue: rgb![2], alpha: opacity)
        
    }
}
extension Date {
    func toString(format : String = "yyyy-MM-dd EEEE") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func addingDay(_ value : Int)-> Date {
        return self.addingTimeInterval(TimeInterval(value * 24 * 60 * 60))
    }
    
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

extension String {
    func toDate(format : String = "yyyy-MM-dd HH:mm:ss") -> Date {
        guard !self.isEmpty else {
            return Date()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self) ?? Date()
    }
}

extension Int64 {
    func toMilisecondToHour(format : String = "HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        return dateFormatter.string(from: date)
    }
    
    func toMilisecondToDateFormat(format : String = "yyyy-MM-dd EEEE") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        return dateFormatter.string(from: date)
    }
}

extension UIViewController {
    func saveLastWeather(_ weather : WeatherLocation){
        if let userDefaults = UserDefaults(suiteName: Contants.suiteName) {
            userDefaults.setValue(weather.toJSON(), forKey: "Weather")
        }
    }
    
    func getLastWeather() -> WeatherLocation {
        if let userDefaults = UserDefaults(suiteName: Contants.suiteName) {
            if let dict = userDefaults.dictionary(forKey: "Weather") {
                return WeatherLocation.init(JSON: dict)!
            }
            return WeatherLocation.init()
        }
        return WeatherLocation.init()
    }
    
    func saveLastForecast(_ weather : WeatherForecast){
        if let userDefaults = UserDefaults(suiteName: Contants.suiteName) {
            userDefaults.setValue(weather.toJSON(), forKey: "Forecast")
        }
    }
    
    func getLastForecast() -> WeatherForecast {
        if let userDefaults = UserDefaults(suiteName: Contants.suiteName) {
            if let dict = userDefaults.dictionary(forKey: "Forecast") {
                return WeatherForecast.init(JSON: dict)!
            }
            return WeatherForecast.init()
        }
        return WeatherForecast.init()
    }
    
    func setLanguage(_ language : String){
        if let userDefaults = UserDefaults(suiteName: Contants.suiteName) {
            userDefaults.setValue(language, forKey: "Language")
        }
    }
    
    func getLanguage() -> String {
        if let userDefaults = UserDefaults(suiteName: Contants.suiteName) {
            if let language = userDefaults.string(forKey: "Language") {
                return language
            }
            return "English"
        }
        return "English"
    }
    
    func setLanguageCode(_ code : String){
        if let userDefaults = UserDefaults(suiteName: Contants.suiteName) {
            userDefaults.setValue(code, forKey: "Code")
        }
    }
    
    func getLanguageCode() -> String {
        if let userDefaults = UserDefaults(suiteName: Contants.suiteName) {
            if let code = userDefaults.string(forKey: "Code") {
                return code
            }
            return "en"
        }
        return "en"
    }
    
    func setUnit(_ unit : String){
        if let userDefaults = UserDefaults(suiteName: Contants.suiteName) {
            userDefaults.setValue(unit, forKey: "Unit")
        }
    }
    
    func getUnit() -> String {
        if let userDefaults = UserDefaults(suiteName: Contants.suiteName) {
            if let unit = userDefaults.string(forKey: "Unit") {
                return unit
            }
            return "metric"
        }
        return "metric"
    }
    
    func setSymbol(_ symbol : String){
        if let userDefaults = UserDefaults(suiteName: Contants.suiteName) {
            userDefaults.setValue(symbol, forKey: "Symbol")
        }
    }
    
    func getSymbol() -> String {
        if let userDefaults = UserDefaults(suiteName: Contants.suiteName) {
            if let symbol = userDefaults.string(forKey: "Symbol") {
                return symbol
            }
            return "°C"
        }
        return "°C"
    }
    
    func setCity(_ city : String){
        if let userDefaults = UserDefaults(suiteName: Contants.suiteName) {
            userDefaults.setValue(city, forKey: "City")
        }
    }
    
    func getCity() -> String {
        if let userDefaults = UserDefaults(suiteName: Contants.suiteName) {
            if let city = userDefaults.string(forKey: "City") {
                return city
            }
            return ""
        }
        return ""
    }
    
    func setDistrict(_ district : String){
        if let userDefaults = UserDefaults(suiteName: Contants.suiteName) {
            userDefaults.setValue(district, forKey: "District")
        }
    }
    
    func getDistrict() -> String {
        if let userDefaults = UserDefaults(suiteName: Contants.suiteName) {
            if let district = userDefaults.string(forKey: "District") {
                return district
            }
            return ""
        }
        return ""
    }
    
    func setWeatherRequestTime(_ time : Int64){
        if let userDefaults = UserDefaults(suiteName: Contants.suiteName) {
            userDefaults.setValue(String.init(time), forKey: "WeatherRequestTime")
        }
    }
    
    func getWeatherRequestTime() -> Int64 {
        if let userDefaults = UserDefaults(suiteName: Contants.suiteName) {
            if let time = userDefaults.string(forKey: "WeatherRequestTime") {
                return Int64.init(time)!
            }
            return Date().millisecondsSince1970
        }
        return Date().millisecondsSince1970
    }
    
    
    func setForecastRequestTime(_ time : Int64){
        if let userDefaults = UserDefaults(suiteName: Contants.suiteName) {
            userDefaults.setValue(String.init(time), forKey: "ForecastRequestTime")
        }
    }
    
    func getForecastRequestTime() -> Int64 {
        if let userDefaults = UserDefaults(suiteName: Contants.suiteName) {
            if let time = userDefaults.string(forKey: "ForecastRequestTime") {
                return Int64.init(time)!
            }
            return Date().millisecondsSince1970
        }
        return Date().millisecondsSince1970
    }
    
    func setLastLocation(location : CLLocation){
        if let userDefaults = UserDefaults(suiteName: Contants.suiteName) {
            userDefaults.setValue(location.coordinate.latitude, forKey: "Latitude")
            userDefaults.setValue(location.coordinate.longitude, forKey: "Longitude")
        }
    }
    
    func getLastLocation() -> CLLocation {
        let userDefaults = UserDefaults(suiteName: Contants.suiteName)
        return CLLocation.init(latitude: userDefaults!.double(forKey: "Latitude"), longitude: userDefaults!.double(forKey: "Longitude"))
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        let userDefaults = UserDefaults(suiteName: Contants.suiteName)
        return userDefaults!.object(forKey: key) != nil
    }
}

extension Weather {
    func getType() -> DescriptionType {
        switch self.icon?[0..<2] {
        case "01":
            return .clearSky
        case "02":
            return .fewClouds
        case "03":
            return .scatteredClouds
        case "04":
            return .brokenClouds
        case "09":
            return .showerRain
        case "10":
            return .rain
        case "11":
            return .thunderstorm
        case "13":
            return .snow
        case "50":
            return .mist
        default:
            return .clearSky
        }
    }
}



extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[start..<end])
    }
    
    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        return String(self[start...])
    }
}


extension Double {
    func toIntString() -> String? {
        return String(format: "%.0f", self)
    }
}

extension UIImageView {
    func setWeatherIcon(type : DescriptionType, isDay : Bool){
        switch type {
        case .clearSky:
            self.image = UIImage.init(named: isDay ? "clear_sky" : "clear_sky_night")
            break
        case .fewClouds:
            self.image = UIImage.init(named: isDay ? "few_clouds" : "few_clouds_night")
            break
        case .scatteredClouds:
            self.image = UIImage.init(named: isDay ? "scattered_clouds" : "scattered_clouds_night")
            break
        case .brokenClouds:
            self.image = UIImage.init(named: isDay ? "broken_clouds" : "broken_clouds_night")
            break
        case .showerRain:
            self.image = UIImage.init(named: isDay ? "shower_rain" : "shower_rain_night")
            break
        case .rain:
            self.image = UIImage.init(named: isDay ? "rain" : "rain_night")
            break
        case .thunderstorm:
            self.image = UIImage.init(named: isDay ? "thunderstorm" : "thunderstorm_night")
            break
        case .snow:
            self.image = UIImage.init(named: isDay ? "snow" : "snow_night")
            break
        case .mist:
            self.image = UIImage.init(named: isDay ? "mist" : "mist_night")
            break
        }
    }
}
