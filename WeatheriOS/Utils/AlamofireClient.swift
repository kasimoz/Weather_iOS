//
//  AlamofireClient.swift
//  WeatheriOS
//
//  Created by KasimOzdemir on 30.01.2020.
//  Copyright © 2020 KasimOzdemir. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireClient {
    
    static var baseUrl = "http://api.openweathermap.org/data/2.5/"
    
    static var weather = baseUrl+"weather"
    static var forecast = baseUrl+"forecast"
}
