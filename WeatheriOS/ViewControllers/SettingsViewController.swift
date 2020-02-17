//
//  SettingsViewController.swift
//  WeatheriOS
//
//  Created by KasimOzdemir on 28.01.2020.
//  Copyright © 2020 KasimOzdemir. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var langIndex = 0
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    let langArray = ["Arabic","German","Greek","English","Persian","French","Hebrew","Hindi","Croatian","Italian","Japanese","Korean","Norwegian","Dutch","Polish","Portuguese","Russian","Spanish","Serbian","Turkish","Chinese"]
    let codeArray = ["ar","de","el","en","fa","fr","he","hi","hr","it","ja","kr","no","nl","pl","ro","ru","sp","sr","tr","zh"]
    let unitArray = ["metric","imperial","deafult"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.segmentedControl.defaultConfiguration()
        self.segmentedControl.selectedConfiguration()
        self.langIndex = self.codeArray.firstIndex(of: self.getLanguageCode()) ?? 0
        self.segmentedControl.selectedSegmentIndex = self.unitArray.firstIndex(of: self.getUnit()) ?? 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addBackgroundView(type: Contants.weather?.weather?.first?.getType() ?? .clearSky)
        self.addNightView(isDay: Contants.weather?.weather?.first?.icon?.contains("d") ?? true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.langArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let label = cell.viewWithTag(1) as? UILabel
        let background = cell.viewWithTag(2) as? UIView
        label?.text = self.langArray[indexPath.row].uppercased()
        if(indexPath.row == self.langIndex){
            background?.backgroundColor = Contants.scSelectedBackgroundColor
            label?.textColor = Contants.scSelectedTextColor
        }else{
            background?.backgroundColor = Contants.scNormalBackgroundColor
            label?.textColor = Contants.scNormalTextColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != self.langIndex {
            if let selectCell = collectionView.cellForItem(at: indexPath) {
                let label = selectCell.viewWithTag(1) as? UILabel
                let background = selectCell.viewWithTag(2) as? UIView
                background?.backgroundColor = Contants.scSelectedBackgroundColor
                label?.textColor = Contants.scSelectedTextColor
            }
            
            if let deselectCell = collectionView.cellForItem(at: IndexPath.init(row: self.langIndex, section: 0)) {
                let label = deselectCell.viewWithTag(1) as? UILabel
                let background = deselectCell.viewWithTag(2) as? UIView
                background?.backgroundColor = Contants.scNormalBackgroundColor
                label?.textColor = Contants.scNormalTextColor
            }
            self.langIndex = indexPath.row
            self.setLanguage(self.langArray[langIndex])
            self.setLanguageCode(self.codeArray[langIndex])
            self.setWeatherRequestTime(Date().millisecondsSince1970 - (5*60))
            self.setForecastRequestTime(Date().millisecondsSince1970 - (5*60))
        }
    }
    
    @IBAction func unitChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.setUnit("metric")
            self.setSymbol("°C")
            break
        case 1:
            self.setUnit("imperial")
            self.setSymbol("°F")
            break
        case 2:
            self.setUnit("default")
            self.setSymbol("°K")
            break
        default:
            break
        }
        self.setWeatherRequestTime(Date().millisecondsSince1970 - (5*60))
        self.setForecastRequestTime(Date().millisecondsSince1970 - (5*60))
    }
}

