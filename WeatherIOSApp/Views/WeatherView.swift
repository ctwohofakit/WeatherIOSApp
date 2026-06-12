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
                        Text(weatherViewModel.timeText)
                        
                        if let date = convertedDate {
                            Text(date, style: .date)
                        }else {
                            Text("no date")
                        }
                        //format:  .dateTime.weekday(.wide).hour().minute())
                        Image(systemName: "cloud.sun.fill")
                            .resizable()
                            .frame(maxWidth: 300, maxHeight: 180, alignment: .center)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.gray.opacity(0.3), .yellow)
                            .padding()
                        
                        Text(weatherViewModel.temperatureText + "°C")
                            .font(.title)
                            .padding()
                        
                        Spacer()
                        HStack{
                            VStack(spacing:5){
                                Image(systemName: "sun.horizon")
                                //                                .resizable()
                                    .frame(width: 10, height: 10, alignment: .center)
                                    .foregroundStyle(.gray)
                                Text(weatherViewModel.timeText).lineLimit(1)
                                    .font(.footnote)
                            }
                            Divider()
                            VStack(spacing:5){
                                Image(systemName: "wind.snow")
                                //                                .resizable()
                                    .frame(width: 10, height: 10, alignment: .center)
                                    .foregroundStyle(.gray)
                                Text(weatherViewModel.windText)
                                    .font(.footnote)
                                
                            }
                            Divider()
                            VStack(spacing:5){
                                Image(systemName: "thermometer.variable")
                                //                                .resizable()
                                    .frame(width: 10, height: 10, alignment: .center)
                                    .foregroundStyle(.gray)
                                Text(weatherViewModel.temperatureText)
                                    .font(.footnote)
                                
                            }
                            
                        }.frame(maxWidth: 300, maxHeight: 80)
                    }.padding()
                }
                
            
            
            
        }.padding()
    }
}

#Preview {
    WeatherView()
}
