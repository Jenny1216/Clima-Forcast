//
//  ForecastDataModel.swift
//  rainyshinycloudyapp
//
//  Created by Jinisha Savani on 10/25/18.
//  Copyright © 2018 Jinisha Savani. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ForecastDataModel {
    
    var time : String?
    var day : String?
    var weatherImg = " "
    var highTemp : Double = 0
    var lowTemp : Double = 0
    var formatterForTime = DateFormatter()
    var formatterForDay = DateFormatter()
    
    convenience init(forecastDict : JSON) {
        
        self.init()
        
        lowTemp = forecastDict["main"]["temp_min"].doubleValue
        highTemp = forecastDict["main"]["temp_max"].doubleValue
        weatherImg = forecastDict["weather"][0]["main"].stringValue
        
        if let forecastedDate = forecastDict["dt"].double {
            
            let unixConvertedDate = Date(timeIntervalSince1970: forecastedDate )
            //   for Time
            formatterForTime.timeStyle = .short
            time = formatterForTime.string(from: unixConvertedDate)
            //   for day
            formatterForDay.dateFormat = "EEEE"
            day = formatterForDay.string(from: unixConvertedDate)
        }
    }
}


