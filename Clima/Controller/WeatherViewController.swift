//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTypedText: UITextField!
    var weatherManager = WeatherManager();
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Most Important Step in order to extablish listeners!!!
        searchTypedText.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @IBAction func resetLocationTapped(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTypedText.endEditing(true);
    }
}

//MARK: WeatherManagerDelegate
extension WeatherViewController : WeatherManagerDelegate{
    func didUpdateWeather(weather: WeatherModel) {
        print("Finally delegate working")
        print(weather);
        
        // UI Updates need to be send on main thread. Long time taking tasks cannot be taken up in UI updation.
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
        
    }
}


//MARK: UITextFieldDelegate
extension WeatherViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTypedText.endEditing(true);
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true;
        }else{
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if let cityName = searchTypedText.text{
            weatherManager.fetchWeather(cityName: cityName);
        }
        
    }
    
}

//MARK: CLLoacationManager
extension WeatherViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let locationsList = locations.last{
            let lat = locationsList.coordinate.latitude
            let lon = locationsList.coordinate.longitude
            weatherManager.fetchWeather(lat: lat, lon: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}

