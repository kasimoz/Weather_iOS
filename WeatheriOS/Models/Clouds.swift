//
//  Clouds.swift
//  WeatheriOS
//
//  Created by KasimOzdemir on 30.01.2020.
//  Copyright © 2020 KasimOzdemir. All rights reserved.
//

import Foundation
import ObjectMapper

struct Clouds : Mappable {
    var all : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        all <- map["all"]
    }
    
}
