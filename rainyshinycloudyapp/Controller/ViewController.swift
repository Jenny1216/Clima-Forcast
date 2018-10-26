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
import ChameleonFramework

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    //Contants
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "c252c50f0f19432e587014a65a163740"
    let CNT = "10"
    

    //Declare instance variables here
    let locationManager = CLLocationManager()
    let currentWeatherDataModel = CurrentWeatherDataModel()
    let formatter = DateFormatter()
    
    //Prelinked Outlets
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    
//    tableView outlets
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
        tableView.rowHeight = 70
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.gray
        
        
        
        updateUIWithWeatherData()
       
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
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID, "cnt" : CNT]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
        
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        locationLabel.text = "Error updating location"
        print(error)
        
    }
    
//MARK:- Networking
/***************************************************************/

//    get Weather data method
    
    func getWeatherData(url : String, parameters : [String:String]) {
        
        Alamofire.request(url, method:.get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess{
                
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
                    print(weatherJSON)
                    
                } else {
                    print("Error is \(String(describing: response.result.error))")
                }
            }
            
        }
    
    func updateWeatherData(json: JSON){
        
        if let _ /*tempResult*/ = json["main"]["temp"].double {
            currentWeatherDataModel.city = json["name"].stringValue
            currentWeatherDataModel.temperature = json["main"]["temp"].doubleValue
            currentWeatherDataModel.backgroundImage = json["weather"][0]["main"].stringValue
            currentWeatherDataModel.currentDate = formatter.string(from: Date())
            formatter.dateStyle = .long
        }
        
        updateUIWithWeatherData()
        
    }
    
    func updateUIWithWeatherData(){
        
        locationLabel.text = currentWeatherDataModel.city
        temperatureLabel.text = String(currentWeatherDataModel.temperature)
        dateLabel.text = "Today,\(currentWeatherDataModel.currentDate)"
        weatherImg.image = UIImage(named: currentWeatherDataModel.backgroundImage)
        weatherLabel.text = "\(currentWeatherDataModel.backgroundImage)"
        
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
/* MARK:- TableView Datasource Methods ******************************/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    
/* MARK:- TableView Delegate Methods **********************************/
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
            tableView.deselectRow(at: indexPath, animated: true)
            
        }
        
    }

