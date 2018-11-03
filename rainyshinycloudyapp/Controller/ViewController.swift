//
//  ViewController.swift
//  rainyshinycloudyapp
//
//  Created by Jinisha Savani on 9/11/18.
//  Copyright © 2018 Jinisha Savani. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    //Contants
    let CURRENT_WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let FORECAST_URL = "https://api.openweathermap.org/data/2.5/forecast?"
    let APP_ID = "c252c50f0f19432e587014a65a163740"
    
    //Declare instance variables here
    let locationManager = CLLocationManager()
    let currentWeatherDataModel = CurrentWeatherDataModel()    
    let formatter = DateFormatter()
    var arrayToStoreObjData = [JSON]()
    let forecastCell = ForecastCell()
    var isCelsius = false
    
    //Prelinked Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var degreeButton: UIButton!
    
    //tableView outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup location manager here
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Setup table view here
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 75
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.gray
        updateUIWithCurrentWeatherData()
        
    }
    
    // Button Action from Kelvin to Fahrenheit and celsius
  
    @IBAction func tempConversion(_ sender: UIButton) {

        if isCelsius {
            updateTempToFahrenheit()
            degreeButton.setTitle("˚F", for: .normal)
            isCelsius = false
        } else {
            updateTempToCelsius()
            degreeButton.setTitle("˚C", for: .normal)
            isCelsius = true
        }
        self.tableView.reloadData()
        
    }
    //MARK: - Set Location Delegate Methods here
    /**************************************************************/
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            getWeatherData(url: CURRENT_WEATHER_URL, parameters: params)
            getWeatherData(url: FORECAST_URL, parameters: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        locationLabel.text = "Error updating location"
        print(error)
    }
    
    //MARK:- Networking
    /***************************************************************/
    
    // Current Weather Data Methods
    
    func getWeatherData(url : String, parameters : [String:String]) {
        
        Alamofire.request(url, method:.get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess{
                
                let WeatherJSON : JSON = JSON(response.result.value!)
                self.updateCurrentWeatherData(json: WeatherJSON)
                self.updateForecastWeatherData(json: WeatherJSON)
//                print(WeatherJSON)
            } else {
                print("Error is \(String(describing: response.result.error))")
            }
        }
    }
    
    func updateCurrentWeatherData(json: JSON){
        
        if let _ = json["main"]["temp"].double {
            currentWeatherDataModel.city = json["name"].stringValue
            currentWeatherDataModel.temperature = json["main"]["temp"].doubleValue
            currentWeatherDataModel.backgroundImage = json["weather"][0]["main"].stringValue
            formatter.dateStyle = .long
            currentWeatherDataModel.currentDate = formatter.string(from: Date())
        }
        updateUIWithCurrentWeatherData()
    }
    
    func updateUIWithCurrentWeatherData(){
        
        locationLabel.text = "\(currentWeatherDataModel.city)"
        dateLabel.text = "\(currentWeatherDataModel.currentDate)"
        weatherImg.image = UIImage(named: currentWeatherDataModel.backgroundImage)
        weatherLabel.text = "\(currentWeatherDataModel.backgroundImage)"
    updateTempToFahrenheit()
    }
   
    func updateTempToFahrenheit(){

        let temperature = String(format: "%.2f", ((currentWeatherDataModel.temperature - 273.15) * (9/5) + 32))

        temperatureLabel.text = "\(temperature)"
    }

    func updateTempToCelsius(){

        let temperature = String(format: "%.2f", (currentWeatherDataModel.temperature - 273.15))

        temperatureLabel.text = "\(temperature)"
    }
  
    //  Forecast Weather Data Methods
    
    func updateForecastWeatherData(json : JSON){

        if let _ /*dict*/ = json.dictionary {
            
            if let list = json["list"].array {
                
                for obj in list {
                    _ = ForecastDataModel(forecastDict: obj)
                    self.arrayToStoreObjData.append(obj)
                }
            }
        }
        self.tableView.reloadData()
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    /* MARK:- TableView Datasource Methods ******************************/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayToStoreObjData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as? ForecastCell
        {
            let objArray = arrayToStoreObjData[indexPath.row]
            let forecastDataModel = ForecastDataModel(forecastDict: objArray)
            
            if isCelsius {
                cell.configureForecastCellWithCelcius(forecast: forecastDataModel)
            } else {
            
            cell.configureForecastCellWithFahrenheit(forecast: forecastDataModel)
               
            }
            
            
            return cell
            
        } else {
            return ForecastCell()
        }
    }
    
    /* MARK:- TableView Delegate Methods **********************************/
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

