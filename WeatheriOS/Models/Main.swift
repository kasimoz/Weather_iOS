//
//  Main.swift
//  WeatheriOS
//
//  Created by KasimOzdemir on 30.01.2020.
//  Copyright © 2020 KasimOzdemir. All rights reserved.
//

import Foundation
import ObjectMapper

struct Main : Mappable {
	var temp : Double?
	var feels_like : Double?
	var temp_min : Double?
	var temp_max : Double?
	var pressure : Double?
	var humidity : Double?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		temp <- map["temp"]
		feels_like <- map["feels_like"]
		temp_min <- map["temp_min"]
		temp_max <- map["temp_max"]
		pressure <- map["pressure"]
		humidity <- map["humidity"]
	}

}
