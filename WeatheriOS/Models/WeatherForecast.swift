//
//  WeatherForecast.swift
//  WeatheriOS
//
//  Created by KasimOzdemir on 30.01.2020.
//  Copyright © 2020 KasimOzdemir. All rights reserved.
//

import Foundation
import ObjectMapper

struct WeatherForecast : Mappable {
    var cod : Int?
    var message : String?
    var count : Int?
    var list : [WeatherLocation]?
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        cod <- map["cod"]
        message <- map["message"]
        count <- map["count"]
        list <- map["list"]
    }
    
}
