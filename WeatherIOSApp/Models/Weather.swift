//
//  Weather.swift
//  WeatherIOSApp
//
//  Created by Kit Sito on 6/6/26.
import Foundation


//the api documnet require city name and corridate for
// search the weather condition

struct GeoCodingResult: Codable{
    let name: String
    let latitude: Double
    let longitude: Double
}

//{} = OBJECT -> CUSTOM TYPE-> MODEL
struct WeatherModel: Codable{
    let results: [GeoCodingResult]?
  
}


//one single object not list of array, becasue we give out the corridate 
struct ForecastResponse: Codable{
    let current_weather:CurrentWeather // key
}

struct CurrentWeather: Codable{
    //temp, windspeed, ,weathercode, time
    let temperature: Double
    let windspeed: Double
    let weathercode: Int
    let time: String
    
}

