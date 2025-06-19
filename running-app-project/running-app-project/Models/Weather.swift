//
//  Weather.swift
//  running-app-project
//
//  Created for RunningHelper on 6/19/25.
//

import Foundation

struct RunningWeather {
    let temperature: Double
    let feelsLike: Double
    let humidity: Int
    let windSpeed: Double
    let windDirection: Double
    let precipitation: Double
    let uvIndex: Int
    let visibility: Double
    let airQualityIndex: Int?
    let weatherCondition: WeatherCondition
    let timestamp: Date
    
    var temperatureInCelsius: String {
        return "\(Int(temperature))°C"
    }
    
    var feelsLikeInCelsius: String {
        return "체감 \(Int(feelsLike))°C"
    }
    
    var humidityPercentage: String {
        return "\(humidity)%"
    }
    
    var windSpeedKmh: String {
        return "\(Int(windSpeed * 3.6)) km/h"
    }
    
    var runningScore: RunningScore {
        calculateRunningScore()
    }
    
    private func calculateRunningScore() -> RunningScore {
        var score = 100
        
        // Temperature penalty
        if temperature < 0 || temperature > 30 {
            score -= 30
        } else if temperature < 5 || temperature > 25 {
            score -= 15
        }
        
        // Humidity penalty
        if humidity > 80 {
            score -= 20
        } else if humidity > 70 {
            score -= 10
        }
        
        // Wind penalty
        if windSpeed > 10 {
            score -= 20
        } else if windSpeed > 7 {
            score -= 10
        }
        
        // Weather condition penalty
        switch weatherCondition {
        case .rain, .snow:
            score -= 30
        case .cloudy:
            score -= 5
        case .clear:
            score += 5
        default:
            break
        }
        
        // UV penalty
        if uvIndex > 7 {
            score -= 15
        }
        
        // Air quality penalty
        if let aqi = airQualityIndex {
            if aqi > 150 {
                score -= 40
            } else if aqi > 100 {
                score -= 20
            }
        }
        
        return RunningScore(rawScore: max(0, score))
    }
}

enum WeatherCondition: String, CaseIterable {
    case clear = "맑음"
    case cloudy = "흐림"
    case rain = "비"
    case snow = "눈"
    case fog = "안개"
    case wind = "강풍"
}

struct RunningScore {
    let rawScore: Int
    
    var level: RunningCondition {
        switch rawScore {
        case 80...100:
            return .excellent
        case 60..<80:
            return .good
        case 40..<60:
            return .fair
        case 20..<40:
            return .poor
        default:
            return .notRecommended
        }
    }
    
    var recommendation: String {
        switch level {
        case .excellent:
            return "완벽한 러닝 날씨입니다! 🏃‍♂️"
        case .good:
            return "러닝하기 좋은 날씨입니다."
        case .fair:
            return "러닝 가능하지만 주의가 필요합니다."
        case .poor:
            return "러닝하기 좋지 않은 날씨입니다."
        case .notRecommended:
            return "실내 운동을 권장합니다."
        }
    }
}

enum RunningCondition {
    case excellent
    case good
    case fair
    case poor
    case notRecommended
    
    var color: String {
        switch self {
        case .excellent:
            return "green"
        case .good:
            return "blue"
        case .fair:
            return "yellow"
        case .poor:
            return "orange"
        case .notRecommended:
            return "red"
        }
    }
}

struct RunningTip {
    let category: TipCategory
    let message: String
}

enum TipCategory {
    case clothing
    case hydration
    case safety
    case performance
}