//
//  ForecastCell.swift
//  rainyshinycloudyapp
//
//  Created by Jinisha Savani on 10/27/18.
//  Copyright © 2018 Jinisha Savani. All rights reserved.
//

import UIKit
import SwiftyJSON

class ForecastCell: UITableViewCell {
    
    @IBOutlet weak var forecastDay: UILabel!
    @IBOutlet weak var forecastImgLabel: UILabel!
    @IBOutlet weak var forecastMinTemp: UILabel!
    @IBOutlet weak var forecastMaxTemp: UILabel!
    @IBOutlet weak var forecastTime: UILabel!
    @IBOutlet weak var forecastImage: UIImageView!
    
    func configureForecastCell(forecast : ForecastDataModel) {
        
        forecastDay.text = forecast.day
        forecastTime.text = forecast.time
        forecastMinTemp.text = "\(forecast.lowTemp)˚"
        forecastMaxTemp.text = "\(forecast.highTemp)˚"
        forecastImage.image = UIImage(named: forecast.weatherImg)
        forecastImgLabel.text = forecast.weatherImg
    }
}
