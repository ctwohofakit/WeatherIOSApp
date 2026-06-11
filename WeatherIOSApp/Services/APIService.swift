//
//  APIService.swift
//  WeatherIOSApp
//
//  Created by Kit Sito on 6/6/26.
//
import Foundation

class APIService {
    //enum for error message
    enum NetworkError: Error{
        case invalidURL
        case invalidResponse
        case badStatusCode(statusCode:Int)
        case noResults
    }
    
        //USER FUNCTION
        func fetchCurrentWeather(forCity city:String) async throws ->
        (cityName: String, weather:CurrentWeather){
            
            let geocodingResult: GeoCodingResult = try await fetchCoordinates(forCity: city)
            
            let currentWeather: CurrentWeather = try await fetchWeather(latitude: geocodingResult.latitude, longitude: geocodingResult.longitude)
            
            /*  let currentWeather: CurrentWeather = try await fetchWeather(latitude:geocodingResult.latitude,longitude:geocodingResult.longitude)*/
            
            return (geocodingResult.name, currentWeather)
            
        }
        
        
        
        //Data is a general type,
        
        //call1 gets the coordinates
        //call2 gets the weather
        func performFetchRequest(url: URL) async throws -> Data {
        
            //1.create the URLSession()
            let session: URLSession = URLSession.shared
            
            //2. perform a request to the URL and wait for the server to resposne
            //try -> because this call can fail
            //await -> wait for server to response
            let result:(Data, URLResponse) = try await session.data(from: url)

            //3. split the result
            let data: Data = result.0 //Data -> Content -> Json
            let response: URLResponse = result.1 //URLResposne -> information about the request, ex: status code
            
            //4. We want only the HTTP repsone with codes(200, 404, 500)
                //if we don't have http response, it mean somthing went wrong
            
            if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse{
                
                //5. Get the  status code from the reponse
                let statusCode: Int = httpResponse.statusCode
                
                //6. only trea status 200-299 as success
                    //if outside that range, throw error
                if statusCode < 200 || statusCode > 299 {
                    throw NetworkError.badStatusCode(statusCode: statusCode)
                }
                return data
            }
            throw NetworkError.invalidResponse
            
        }
        //API 1: user send a CityName and API return the json to parse it into a model(GeoCodingResult) from Weather Model
        private func fetchCoordinates(forCity city:String) async throws -> GeoCodingResult {
            //change parameter of the api endpoint allow user change input, will pull the search by city
            
            //BASE URL ="https://geocoding-api.open-meteo.com/v1/search"
            //URLComponents allows us to change the URL dynamically
            
            var urlComponents: URLComponents? = URLComponents(string: "https://geocoding-api.open-meteo.com/v1/search")
            if urlComponents == nil {
                throw NetworkError.invalidURL
            }
            
            //queryItem is the paratmeter to add to endpoint
            urlComponents?.queryItems = [
                URLQueryItem(name: "name", value: city),
                URLQueryItem(name: "count", value: "1"),
                URLQueryItem(name: "language", value: "en"),
                URLQueryItem(name: "format", value: "json")
            ]
            
            let url: URL? = urlComponents?.url
            
            if url == nil {
                throw NetworkError.invalidURL
            }
            
            //send the request
            let data : Data = try await performFetchRequest(url: url!)
            
            //decode
            let decoder:JSONDecoder = JSONDecoder()
            
            //here we have an array of WeatherModel items
            let response: WeatherModel = try decoder.decode(WeatherModel.self, from: data)

            // In eed the array of results to exist
            if let results:[GeoCodingResult] = response.results{
                //I only need the firest result because it means that one is the most likely to be my place
                if let firstResult:GeoCodingResult = results.first{
                    
                    //if I have that one, return it
                    return firstResult
                }
            }
            throw NetworkError.noResults
        }
        
        
        private func fetchWeather(latitude: Double, longitude: Double) async throws -> CurrentWeather {
            //change parameter of the api endpoint allow user change input, will pull the search by city
            
            //BASE URL ="https://api.open-meteo.com/v1/forecast"
            //URLComponents allows us to change the URL dynamically
            
            var urlComponents: URLComponents? = URLComponents(string: "https://api.open-meteo.com/v1/forecast")
            if urlComponents == nil {
                throw NetworkError.invalidURL
            }
            
            //queryItem is the paratmeter to add to endpoint
            urlComponents?.queryItems = [
                URLQueryItem(name: "latitude", value: String(latitude)),
                URLQueryItem(name: "longitude", value: String(longitude)),
                URLQueryItem(name: "current_weather", value: "true"),
                URLQueryItem(name: "timezone", value: "auto")
            ]
            
            let url: URL? = urlComponents?.url
            
            if url == nil {
                throw NetworkError.invalidURL
            }
            
            //send the request
            let data : Data = try await performFetchRequest(url: url!)
            
            //decode
            let decoder:JSONDecoder = JSONDecoder()
            
            //here we have an array of WeatherModel items
            let response: ForecastResponse = try decoder.decode(ForecastResponse.self, from: data)

            // In eed the array of results to exist
            return response.current_weather
        }
        
        
    
    
    
}
