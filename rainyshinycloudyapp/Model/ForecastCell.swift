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
    
    func configureForecastCellWithFahrenheit(forecast : ForecastDataModel) {
        
        forecastDay.text = forecast.day
        forecastTime.text = forecast.time
        forecastImage.image = UIImage(named: forecast.weatherImg)
        forecastImgLabel.text = forecast.weatherImg
        
        let minTemp = String(format: "%.2f", ((forecast.lowTemp - 273.15) * (9/5) + 32))
        forecastMinTemp.text = "\(minTemp)˚"
        let maxTemp = String(format: "%.2f", ((forecast.highTemp - 273.15) * (9/5) + 32))
        forecastMaxTemp.text = "\(maxTemp)˚"
        
}
    
    func configureForecastCellWithCelcius(forecast : ForecastDataModel) {
        
        forecastDay.text = forecast.day
        forecastTime.text = forecast.time
        forecastImage.image = UIImage(named: forecast.weatherImg)
        forecastImgLabel.text = forecast.weatherImg
        
        let minTemp = String(format: "%.2f", (forecast.lowTemp - 273.15))
        forecastMinTemp.text = "\(minTemp)˚"
        let maxTemp = String(format: "%.2f", (forecast.highTemp - 273.15))
        forecastMaxTemp.text = "\(maxTemp)˚"
        
    }
}
