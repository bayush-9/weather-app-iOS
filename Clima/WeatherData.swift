//
//  WeatherData.swift
//  Clima
//
//  Created by Ayush Bharsakle on 28/09/25.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation

struct Main : Decodable{
    let temp : Double
}

struct Weather : Decodable{
    let description : String
    let id : Int
}

struct WeatherData : Decodable {// Decodable for JSON
    let name : String
    let main : Main
    let weather : [Weather]

}
