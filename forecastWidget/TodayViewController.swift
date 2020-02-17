//
//  TodayViewController.swift
//  forecastWidget
//
//  Created by KasimOzdemir on 30.01.2020.
//  Copyright © 2020 KasimOzdemir. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation
import Alamofire
import AlamofireObjectMapper

class TodayViewController: UIViewController, NCWidgetProviding,UICollectionViewDelegate, UICollectionViewDataSource {
    var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8.0
        layout.minimumInteritemSpacing = 8.0
        let width = (UIScreen.main.bounds.size.width - 56.0) / 4
        layout.estimatedItemSize = CGSize(width: width, height: 98.0)
        return layout
    }()
    
    @IBOutlet weak var collectionView: UICollectionView!
    var list : [WeatherLocation] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        self.collectionView?.collectionViewLayout = layout
        self.collectionView!.contentInset = UIEdgeInsets(top: 8, left: 0, bottom:0, right: 8)
        self.list = self.getLastForecast().list ?? []
        self.collectionView.reloadData()
        
        if self.isKeyPresentInUserDefaults(key: "Latitude"){
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
                    self.saveLastForecast(weatherForecast!)
                    self.list = weatherForecast?.list ?? []
                    self.collectionView.reloadData()
                }
            }
        }
    }
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            self.preferredContentSize = maxSize
        } else if activeDisplayMode == .expanded {
            self.preferredContentSize = CGSize(width: maxSize.width, height: self.collectionView.contentSize.height + 16.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count > 7 ? 8 : 0
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
        temp?.textColor = UIColor.white
        time?.textColor = UIColor.white
        return cell
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
}
