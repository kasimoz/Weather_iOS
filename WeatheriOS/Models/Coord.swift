//
//  Coord.swift
//  WeatheriOS
//
//  Created by KasimOzdemir on 30.01.2020.
//  Copyright © 2020 KasimOzdemir. All rights reserved.
//

import Foundation
import ObjectMapper

struct Coord : Mappable {
    var lon : Double?
    var lat : Double?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        lon <- map["lon"]
        lat <- map["lat"]
    }
    
}
