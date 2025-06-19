//
//  WeatherViewModel.swift
//  running-app-project
//
//  Created for RunningHelper on 6/19/25.
//

import Foundation
import SwiftUI

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var currentWeather: RunningWeather?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchWeather() async {
        isLoading = true
        errorMessage = nil
        
        // TODO: Replace with actual weather API call
        // For now, using mock data
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay to simulate API call
        
        currentWeather = RunningWeather(
            temperature: 18.5,
            feelsLike: 16.2,
            humidity: 65,
            windSpeed: 3.5,
            windDirection: 45,
            precipitation: 0,
            uvIndex: 4,
            visibility: 10,
            airQualityIndex: 75,
            weatherCondition: .clear,
            timestamp: Date()
        )
        
        isLoading = false
    }
}