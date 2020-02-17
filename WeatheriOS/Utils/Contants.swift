//
//  Contants.swift
//  WeatheriOS
//
//  Created by KasimOzdemir on 28.01.2020.
//  Copyright © 2020 KasimOzdemir. All rights reserved.
//

import Foundation
import UIKit

class Contants{
    static var clearSkyStartColor = UIColor.init("4373bb")
    static var clearSkyCenterColor = UIColor.init("c4ddec")
    static var clearSkyEndColor = UIColor.init("c4ddec")
    
    static var fewCloudsStartColor = UIColor.init("2aabd2")
    static var fewCloudsCenterColor = UIColor.init("c1e3d6")
    static var fewCloudsEndColor = UIColor.init("fbd4ae")
    
    static var scatteredCloudsStartColor = UIColor.init("356075")
    static var scatteredCloudsCenterColor = UIColor.init("8158bf")
    static var scatteredCloudsEndColor = UIColor.init("f8f4fc")
    
    static var brokenCloudsStartColor = UIColor.init("0a0c32")
    static var brokenCloudsCenterColor = UIColor.init("8cc0e8")
    static var brokenCloudsEndColor = UIColor.init("fbd4ae")
    
    static var showerRainStartColor = UIColor.init("043039")
    static var showerRainCenterColor = UIColor.init("25979b")
    static var showerRainEndColor = UIColor.init("a9e0e1")
    
    static var rainStartColor = UIColor.init("96c4e5")
    static var rainCenterColor = UIColor.init("f7cbe9")
    static var rainEndColor = UIColor.init("fbfcd1")
    
    static var thunderstormStartColor = UIColor.init("3f464e")
    static var thunderstormCenterColor = UIColor.init("b5c0d3")
    static var thunderstormEndColor = UIColor.init("ced4e3")
    
    static var snowStartColor = UIColor.init("a9b3c4")
    static var snowCenterColor = UIColor.init("ebecf0")
    static var snowEndColor = UIColor.init("ffffff")
    
    static var mistStartColor = UIColor.init("d2bf9b")
    static var mistCenterColor = UIColor.init("e7e7e7")
    static var mistEndColor = UIColor.init("c6a399")
    
    static var unselectedItemTintColor = UIColor.init("757575")
    static var selectedImageTintColor = UIColor.init("FF9800")
    static var unselectedItemTintColorNight = UIColor.init("CCCCCC")
    static var selectedImageTintColorNight = UIColor.init("3F51B5")
    
    static var sliderMinStartColor = UIColor.init("FFEB3B")
    static var sliderMinEndColor = UIColor.init("FF5722")
    static var sliderMaxStartColor = UIColor.init("93EFFF")
    static var sliderMaxEndColor = UIColor.init("3F51B5")
    
    static var scNormalBackgroundColor = UIColor.init("E3F6FF")
    static var scSelectedBackgroundColor = UIColor.init("FF9800")
    static var scNormalTextColor = UIColor.init("222C4E")
    static var scSelectedTextColor = UIColor.init("FFFFFF")
    
    static var appId = "YourApiKey"
    static var suiteName = "group.weather.forecast"
    
    static var weather : WeatherLocation?
    
}


enum DescriptionType {
    case clearSky
    case fewClouds
    case scatteredClouds
    case brokenClouds
    case showerRain
    case rain
    case thunderstorm
    case snow
    case mist
}
