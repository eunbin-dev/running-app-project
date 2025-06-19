//
//  ContentView.swift
//  running-app-project
//
//  Created by mac297 on 6/19/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            WeatherView()
                .tabItem {
                    Label("날씨", systemImage: "cloud.sun")
                }
        }
    }
}

#Preview {
    ContentView()
}
