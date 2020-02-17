//
//  SecondViewController.swift
//  WeatheriOS
//
//  Created by KasimOzdemir on 28.01.2020.
//  Copyright © 2020 KasimOzdemir. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import CoreLocation

class WeatherViewController: UIViewController , CLLocationManagerDelegate{
    
    @IBOutlet weak var sunset: UILabel!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var temp_max_min: UILabel!
    @IBOutlet weak var description_: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var district: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var slider: UISlider!
    var isRequestCompleted = true;
    var timer = Timer()
    
    fileprivate let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackgroundView(type: .clearSky)
        self.slider.addGradientTrack()
        
        let weatherLocation = self.getLastWeather()
        if weatherLocation.id != nil {
            self.setAllViews(weatherLocation: weatherLocation)
        }
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = CLLocationDistance.init(500)
        if #available(iOS 11.0, *) {
            locationManager.showsBackgroundLocationIndicator = true
        } else {
            // Fallback on earlier versions
        }
        locationManager.startUpdatingLocation()
        
        NotificationCenter.default.addObserver(self,selector: #selector(applicationDidBecomeActive),name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func tick() {
        self.slider.value = self.slider.value + 1.0
    }
    
    @objc func applicationDidBecomeActive() {
        if timer.isValid {
            let weatherLocation = self.getLastWeather()
            if weatherLocation.id != nil {
                self.slider.value = Float(Date().millisecondsSince1970.subtractingReportingOverflow((weatherLocation.sys?.sunrise)!).partialValue / Int64.init(60.0))
            }
        }
        locationManager.stopUpdatingLocation()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isKeyPresentInUserDefaults(key: "Latitude") && !self.isLocationAccessEnabled(){
            if(Date().millisecondsSince1970.subtractingReportingOverflow(self.getWeatherRequestTime()).partialValue > 0 && Date().millisecondsSince1970.subtractingReportingOverflow(self.getWeatherRequestTime()).partialValue < (5*60)){
                return
            }
            let location = self.getLastLocation()
            self.setCityAndDistrict(coords: location)
            self.weatherService(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    func isLocationAccessEnabled() -> Bool{
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            case .notDetermined, .restricted, .denied:
                return false
            @unknown default:
                return false
            }
        } else {
            return false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        if !self.isRequestCompleted {
            return
        }
        if(Date().millisecondsSince1970.subtractingReportingOverflow(self.getWeatherRequestTime()).partialValue > 0 && Date().millisecondsSince1970.subtractingReportingOverflow(self.getWeatherRequestTime()).partialValue < (5*60)){
            return
        }
        self.setLastLocation(location: location)
        self.isRequestCompleted = false
        self.setCityAndDistrict(coords: location)
        self.weatherService(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            manager.stopUpdatingLocation()
        }
    }
    
    func weatherService(latitude : Double, longitude: Double){
        let parameters: [String: AnyObject] = [
            "lat": latitude,
            "lon": longitude,
            "units": self.getUnit(),
            "lang": self.getLanguageCode(),
            "APPID": Contants.appId
            ] as [String: AnyObject]
        Alamofire.request(AlamofireClient.weather, method: .get, parameters: parameters).validate(statusCode: 200..<201).responseObject { (response: DataResponse<WeatherLocation>) in
            DispatchQueue.main.async {
                let weatherLocation = response.result.value
                if response.result.isSuccess && weatherLocation != nil{
                    self.setWeatherRequestTime(Date().millisecondsSince1970)
                    self.saveLastWeather(weatherLocation!)
                    self.setAllViews(weatherLocation: weatherLocation!)
                }
                self.isRequestCompleted = true
            }
        }
    }
    
    func setCityAndDistrict(coords: CLLocation){
        
        CLGeocoder().reverseGeocodeLocation(coords) { (placemark, error) in
            if error != nil {
                print("CLGeocoder error")
            } else {
                
                let place = placemark! as [CLPlacemark]
                if place.count > 0 {
                    let place = placemark![0]
                    self.city.text = (place.administrativeArea ?? "").uppercased()
                    self.district.text = (place.subAdministrativeArea ?? "").uppercased()
                    self.setCity(self.city.text ?? "")
                    self.setDistrict(self.district.text ?? "")
                }
            }
        }
    }
    
    func setAllViews(weatherLocation : WeatherLocation){
        let type =  weatherLocation.weather?.first?.getType() ?? .clearSky
        let isDay = weatherLocation.weather?.first?.icon?.contains("d") ?? true
        self.tabBarController?.setTextItemTintColor(isDay: isDay)
        self.addBackgroundView(type: type)
        self.addNightView(isDay : isDay)
        Contants.weather = weatherLocation
        self.temp.text = (weatherLocation.main?.temp?.toIntString() ?? "0") + self.getSymbol()
        self.description_.text = (weatherLocation.weather?.first?.description ?? "").uppercased()
        self.temp_max_min.text = "\((weatherLocation.main?.temp_min?.toIntString() ?? "0"))\(self.getSymbol()) / \((weatherLocation.main?.temp_max?.toIntString() ?? "0"))\(self.getSymbol())"
        self.icon.setWeatherIcon(type: type, isDay: isDay)
        self.sunrise.text = weatherLocation.sys?.sunrise?.toMilisecondToHour()
        self.sunset.text = weatherLocation.sys?.sunset?.toMilisecondToHour()
        self.slider.maximumValue = Float(((weatherLocation.sys?.sunset?.subtractingReportingOverflow((weatherLocation.sys?.sunrise)!))?.partialValue)! / Int64.init(60.0))
        let value = Float(Date().millisecondsSince1970.subtractingReportingOverflow((weatherLocation.sys?.sunrise)!).partialValue / Int64.init(60.0))
        self.slider.value = value
        self.slider.tintColor = isDay ? Contants.sliderMinStartColor : UIColor.clear
        if(!timer.isValid){
            self.timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector:#selector(self.tick) , userInfo: nil, repeats: true)
        }
        self.city.text = self.getCity()
        self.district.text = self.getDistrict()
    }
}

