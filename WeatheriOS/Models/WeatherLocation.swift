//
//  WeatherLocation.swift
//  WeatheriOS
//
//  Created by KasimOzdemir on 30.01.2020.
//  Copyright © 2020 KasimOzdemir. All rights reserved.
//

import Foundation
import ObjectMapper

struct WeatherLocation: Mappable {
    var coord : Coord?
    var weather : [Weather]?
    var base : String?
    var main : Main?
    var visibility : Int?
    var wind : Wind?
    var clouds : Clouds?
    var dt : Int64?
    var dt_txt : String?
    var sys : Sys?
    var timezone : Int?
    var id : Int?
    var name : String?
    var cod : Int?
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        coord <- map["coord"]
        weather <- map["weather"]
        base <- map["base"]
        main <- map["main"]
        visibility <- map["visibility"]
        wind <- map["wind"]
        clouds <- map["clouds"]
        dt <- map["dt"]
        sys <- map["sys"]
        timezone <- map["timezone"]
        id <- map["id"]
        name <- map["name"]
        cod <- map["cod"]
        dt_txt <- map["dt_txt"]
    }
    
}
