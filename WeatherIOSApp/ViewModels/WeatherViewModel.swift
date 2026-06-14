//
//  WeatherViewModel.swift
//  WeatherIOSApp
//
//  Created by Kit Sito on 6/6/26.
//
import Combine
import Foundation

@MainActor
class WeatherViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    
    //data display
    @Published var cityName: String = ""
    @Published var temperatureText: String = ""
    @Published var windText: String = ""
    @Published var timeText: String = ""
    
    //help var
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    let API: APIService = APIService()
    
    func search() async {
        self.errorMessage = ""
        self.isLoading = true
        
        let trimmedText:String = self.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedText.isEmpty{
            self.errorMessage = "Plase enter a city"
            self.isLoading = false
            return
        }
        do{
            let result = try await API.fetchCurrentWeather(forCity: trimmedText)
            self.cityName = result.cityName
            self.temperatureText = "\(result.weather.temperature)"
            self.windText = "\(result.weather.windspeed)"
            self.timeText = "\(result.weather.time)"
            self.isLoading = false
            
            
        }catch{
            self.errorMessage = "something went wrong"
            self.isLoading = false
        }
    }
    
}
