//
//  WeatherManager.swift
//  Clima
//
//  Created by Ayush Bharsakle on 27/09/25.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate{
    func didUpdateWeather(weather : WeatherModel)
}

struct WeatherManager {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=ffcef6f14038532bc05c37b7da1b0145&units=metric";
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName : String){
        let urlString = weatherUrl + "&q=\(cityName)";
        performRequest(urlString: urlString)
    }
    
    func fetchWeather(lat : Double , lon : Double){
        let newURL = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=ffcef6f14038532bc05c37b7da1b0145&units=metric"
        print(newURL)
        performRequest(urlString: newURL)
    }
    
    func performRequest(urlString : String){
        
        //        1. Create a URL
        if let url = URL(string: urlString){ // Optional
            
            //        2. Create a URLSession -> KINDA BROWSER Session
            let urlSession = URLSession(configuration: .default)
            
            //            3. Give session a task to perform
            let task = urlSession.dataTask(with: url) { (data, urlResponse, error) in // Completion handler will be excuted when the task will be run ::::: Also this is an example of closure
                if error != nil{
                    print(error!)
                    return;
                }
                if let safeData = data{
                    print(safeData)
                    parseJSON(weatherData: safeData)
                    
                }
            };
            
            //            4. Perform the task
            task.resume(); // Newly initialized task begin in suspended state. Hence we need to call resume as per
        }
        
        
    }
    
    func parseJSON(weatherData : Data){
        let decoder = JSONDecoder();
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData);
            let id = decodedData.weather[0].id;
            let city = decodedData.name
            let temperature = decodedData.main.temp
            
            let weather = WeatherModel(conditionId: id, cityName: city, temperature: temperature)
            
            // Using the delegate pattern here
            delegate!.didUpdateWeather(weather: weather);
        } catch{
            print(error);
        }
        
    }
}
