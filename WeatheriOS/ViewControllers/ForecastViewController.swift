//
//  FirstViewController.swift
//  WeatheriOS
//
//  Created by KasimOzdemir on 28.01.2020.
//  Copyright © 2020 KasimOzdemir. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class ForecastViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8.0
        layout.minimumInteritemSpacing = 8.0
        let width = (UIScreen.main.bounds.size.width - 40.0) / 4
        layout.estimatedItemSize = CGSize(width: width, height: 98.0)
        return layout
    }()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var pressure: UILabel!
    let inHg : CGFloat = 0.030
    var list : [WeatherLocation] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.collectionViewLayout = layout
        self.collectionView!.contentInset = UIEdgeInsets(top: 0, left: 0, bottom:0, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addBackgroundView(type: Contants.weather?.weather?.first?.getType() ?? .clearSky)
        self.addNightView(isDay: Contants.weather?.weather?.first?.icon?.contains("d") ?? true)
        if Contants.weather != nil {
            self.feelsLike.text = (Contants.weather?.main?.feels_like?.toIntString() ?? "0") + self.getSymbol()
            self.wind.text = (Contants.weather?.wind?.speed?.toIntString() ?? "0") + " m/s"
            self.humidity.text = (Contants.weather?.main?.humidity?.toIntString() ?? "0") + " %"
            self.pressure.text = String.init(format: "%.2f IN", (CGFloat(Contants.weather?.main?.pressure ?? 0.0) * self.inHg))
        }
        
        self.list = getLastForecast().list ?? []
        self.collectionView.reloadData()
        self.tableView.reloadData()
        
        if self.isKeyPresentInUserDefaults(key: "Latitude"){
            if(Date().millisecondsSince1970.subtractingReportingOverflow(self.getForecastRequestTime()).partialValue > 0 && Date().millisecondsSince1970.subtractingReportingOverflow(self.getForecastRequestTime()).partialValue < (5*60)){
                self.list = getLastForecast().list ?? []
                self.collectionView.reloadData()
                self.tableView.reloadData()
                return
            }
            let location = self.getLastLocation()
            self.forecastService(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    
    func forecastService(latitude : Double, longitude: Double){
        let parameters: [String: AnyObject] = [
            "lat": latitude,
            "lon": longitude,
            "units": self.getUnit(),
            "lang": self.getLanguageCode(),
            "APPID": Contants.appId
            ] as [String: AnyObject]
        Alamofire.request(AlamofireClient.forecast, method: .get, parameters: parameters).validate(statusCode: 200..<201).responseObject { (response: DataResponse<WeatherForecast>) in
            DispatchQueue.main.async {
                let weatherForecast = response.result.value
                if response.result.isSuccess && weatherForecast != nil{
                    self.setForecastRequestTime(Date().millisecondsSince1970)
                    self.saveLastForecast(weatherForecast!)
                    self.list = weatherForecast?.list ?? []
                    self.collectionView.reloadData()
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count > 8 ? 9 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let time = cell.viewWithTag(1) as? UILabel
        let icon = cell.viewWithTag(2) as? UIImageView
        let temp = cell.viewWithTag(3) as? UILabel
        let type =  self.list[indexPath.row].weather?.first?.getType() ?? .clearSky
        let isDay = self.list[indexPath.row].weather?.first?.icon?.contains("d") ?? true
        time?.text = self.list[indexPath.row].dt?.toMilisecondToHour()
        icon?.setWeatherIcon(type: type, isDay: isDay)
        temp?.text = (self.list[indexPath.row].main?.temp?.toIntString() ?? "0") + self.getSymbol()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.backgroundColor = list.count > 4 ? UIColor.white.withAlphaComponent(0.33) : UIColor.clear
        return list.count > 4 ? 5 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let day = cell!.viewWithTag(1) as? UILabel
        let icon = cell!.viewWithTag(2) as? UIImageView
        let temp = cell!.viewWithTag(3) as? UILabel
        let date = self.list[0].dt_txt?.toDate().addingDay(indexPath.row + 1).toString()
        let array = date?.split(separator: " ")
        day?.text = String.init(array?.last ?? "")
        let index = self.getIndexOfDate(date: String.init(array?.first ?? "") + " 12:00:00")
        let type =  self.list[index].weather?.first?.getType() ?? .clearSky
        let isDay = self.list[index].weather?.first?.icon?.contains("d") ?? true
        icon?.setWeatherIcon(type: type, isDay: isDay)
        temp?.text = (self.list[index].main?.temp?.toIntString() ?? "0") + self.getSymbol()
        return cell!
    }
    
    
    public func getIndexOfDate(date : String)-> Int{
        var index = 0
        for i in 0..<self.list.count {
            if date == self.list[i].dt_txt{
                index = i
                break
            }
        }
        return index;
    }
    
}

