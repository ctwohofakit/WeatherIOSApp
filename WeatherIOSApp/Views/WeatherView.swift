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
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        
        let parsedDate = formatter.date(from: stringTime)
        return parsedDate
    }
    
    var greeting : String{
        guard let date = convertedDate else { return "no date" }
        let hour = Calendar.current.component(.hour, from: date)
        return hour < 18 ? "Good Morning" : "Good Evening"
    }
   
    
    var body: some View {
        
        NavigationStack{
            HStack{
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
            }
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
//                        Text(weatherViewModel.timeText)
                        
                        if let date = convertedDate {
                            Text(date, style: .date)
                        }else {
                            Text("no date")
                        }
                        //format:  .dateTime.weekday(.wide).hour().minute())
                        if greeting == "Good Morning" {
                                Image(systemName: "cloud.sun.fill")
                                    .resizable()
                                    .frame(maxWidth: 300, maxHeight: 200, alignment: .center)
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.gray.opacity(0.6), .yellow)
                                    .padding()
                            
                            }else {
                                Image(systemName: "moon.stars")
                                    .resizable()
                                    .frame(maxWidth: 200, maxHeight: 200, alignment: .center)
                                    .foregroundStyle(.blue.opacity(0.6), .yellow)
                                    .symbolRenderingMode(.palette)
                                    .padding()
            
                            }
                        
                            Text(greeting)
                                .font(.title)
                        
                        
                        Spacer()
                        HStack{
                            VStack(spacing:5){
                                Image(systemName: "sun.horizon")
                                //                                .resizable()
                                    .frame(width: 30, height: 30, alignment: .center)
                                    .foregroundStyle(.gray)
                                Text("TIME")
                                    .font(.footnote)
                                if let date = convertedDate {
                                    Text(date, style: .time)
                                        .font(.title3)
                                }else {
                                    Text("no time")
                                }

                                   
                            }
                            Spacer()
                            Divider()
                            VStack(spacing:5){
                                Image(systemName: "wind.snow")
                                //                                .resizable()
                                    .frame(width: 30, height: 30, alignment: .center)
                                    .foregroundStyle(.gray)
                                Text("WIND")
                                    .font(.footnote)
                                Text("\(weatherViewModel.windText) m/s")
                                    .font(.title3)
                                
                            }
                            Divider()
                            Spacer()
                            VStack(spacing:5){
                                Image(systemName: "thermometer.variable")
                                //                                .resizable()
                                    .frame(width: 30, height: 30, alignment: .center)
                                    .foregroundStyle(.gray)
                                Text("TEMPERATURE")
                                    .font(.footnote)
                                
                               

                                Text(weatherViewModel.temperatureText + "°C")
                                    .font(.title3)
                                
                            }
                            
                        }.frame(maxWidth: 300, maxHeight: 80)
                    }.padding()
                }
                
            
            
            
        }.padding()
            .preferredColorScheme(greeting == "Good Evening" ? .dark : .light)
    }
}

#Preview {
    WeatherView()
}
