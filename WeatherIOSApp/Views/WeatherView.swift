//
//  WeatherView.swift
//  WeatherIOSApp
//
//  Created by Kit Sitou on 6/9/26.
//

import SwiftUI

struct WeatherView: View {
    
    @StateObject private var weatherViewModel: WeatherViewModel = WeatherViewModel()
    var convertedDate: Date?{
        let stringTime = weatherViewModel.timeText
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: stringTime)
    }
    
    var body: some View {
        
        NavigationStack{
            TextField("Please enter a city", text: $weatherViewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.words)
            
            Button("Get Weather"){
                Task{
                    await weatherViewModel.search()
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.black.opacity(0.8))
            .foregroundStyle(.white)
            
            if weatherViewModel.isLoading {
                ProgressView("is loading...")
            }
            if !weatherViewModel.errorMessage.isEmpty {
                Text(weatherViewModel.errorMessage)
                    .font(Font.body.bold())
                    .foregroundStyle(.red)
            }
            if !weatherViewModel.cityName.isEmpty {
                
                VStack(alignment: .center, spacing: 8){
                    
                    Text(weatherViewModel.cityName)
                        .font(.system(size: 26))
                    Text(weatherViewModel.timeText)
                         //format:  .dateTime.weekday(.wide).hour().minute())
                    Text(weatherViewModel.windText)
                    Text(weatherViewModel.temperatureText)


                }.padding()
            }
            
            
            
            
        }.padding()
    }
}

#Preview {
    WeatherView()
}
