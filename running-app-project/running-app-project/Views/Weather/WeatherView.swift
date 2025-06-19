//
//  WeatherView.swift
//  running-app-project
//
//  Created for RunningHelper on 6/19/25.
//

import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if let weather = viewModel.currentWeather {
                        RunningScoreCard(weather: weather)
                        
                        WeatherDetailCard(weather: weather)
                        
                        RunningTipsCard(weather: weather)
                    } else {
                        ProgressView("날씨 정보를 불러오는 중...")
                            .padding()
                    }
                }
                .padding()
            }
            .navigationTitle("러닝 날씨")
            .refreshable {
                await viewModel.fetchWeather()
            }
        }
        .task {
            await viewModel.fetchWeather()
        }
    }
}

struct RunningScoreCard: View {
    let weather: RunningWeather
    
    var body: some View {
        VStack(spacing: 16) {
            Text("러닝 적합도")
                .font(.headline)
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.3)
                    .foregroundColor(Color(weather.runningScore.level.color))
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(weather.runningScore.rawScore) / 100.0)
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .foregroundColor(Color(weather.runningScore.level.color))
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.easeInOut, value: weather.runningScore.rawScore)
                
                VStack {
                    Text("\(weather.runningScore.rawScore)")
                        .font(.system(size: 48, weight: .bold))
                    Text("점")
                        .font(.caption)
                }
            }
            .frame(width: 200, height: 200)
            
            Text(weather.runningScore.recommendation)
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
}

struct WeatherDetailCard: View {
    let weather: RunningWeather
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("상세 날씨")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                WeatherDetailItem(
                    icon: "thermometer",
                    title: "온도",
                    value: weather.temperatureInCelsius,
                    subtitle: weather.feelsLikeInCelsius
                )
                
                WeatherDetailItem(
                    icon: "humidity",
                    title: "습도",
                    value: weather.humidityPercentage,
                    subtitle: weather.humidity > 70 ? "높음" : "적정"
                )
                
                WeatherDetailItem(
                    icon: "wind",
                    title: "바람",
                    value: weather.windSpeedKmh,
                    subtitle: windDirection(weather.windDirection)
                )
                
                WeatherDetailItem(
                    icon: "sun.max",
                    title: "자외선",
                    value: "\(weather.uvIndex)",
                    subtitle: uvLevel(weather.uvIndex)
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    func windDirection(_ degrees: Double) -> String {
        let directions = ["북", "북동", "동", "남동", "남", "남서", "서", "북서"]
        let index = Int((degrees + 22.5) / 45.0) % 8
        return directions[index]
    }
    
    func uvLevel(_ index: Int) -> String {
        switch index {
        case 0...2:
            return "낮음"
        case 3...5:
            return "보통"
        case 6...7:
            return "높음"
        case 8...10:
            return "매우 높음"
        default:
            return "위험"
        }
    }
}

struct WeatherDetailItem: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct RunningTipsCard: View {
    let weather: RunningWeather
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("러닝 팁")
                .font(.headline)
            
            ForEach(generateTips(for: weather), id: \.message) { tip in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: tipIcon(for: tip.category))
                        .foregroundColor(.blue)
                        .frame(width: 24)
                    Text(tip.message)
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    func generateTips(for weather: RunningWeather) -> [RunningTip] {
        var tips: [RunningTip] = []
        
        if weather.temperature < 10 {
            tips.append(RunningTip(category: .clothing, message: "긴팔 상의와 방풍 재킷을 착용하세요."))
        } else if weather.temperature > 25 {
            tips.append(RunningTip(category: .clothing, message: "통기성 좋은 옷을 입고 모자를 착용하세요."))
        }
        
        if weather.humidity > 70 {
            tips.append(RunningTip(category: .hydration, message: "수분 섭취를 평소보다 늘리세요."))
        }
        
        if weather.uvIndex > 5 {
            tips.append(RunningTip(category: .safety, message: "자외선 차단제를 바르고 선글라스를 착용하세요."))
        }
        
        if weather.windSpeed > 7 {
            tips.append(RunningTip(category: .performance, message: "바람을 등지고 시작해서 맞바람으로 돌아오세요."))
        }
        
        return tips
    }
    
    func tipIcon(for category: TipCategory) -> String {
        switch category {
        case .clothing:
            return "tshirt"
        case .hydration:
            return "drop"
        case .safety:
            return "exclamationmark.shield"
        case .performance:
            return "figure.run"
        }
    }
}

#Preview {
    WeatherView()
}