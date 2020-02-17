//
//  Wind.swift
//  WeatheriOS
//
//  Created by KasimOzdemir on 30.01.2020.
//  Copyright © 2020 KasimOzdemir. All rights reserved.
//

import Foundation
import ObjectMapper

struct Wind : Mappable {
    var speed : Double?
    var deg : Double?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        speed <- map["speed"]
        deg <- map["deg"]
    }
    
}
