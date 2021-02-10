//
//  ContentView.swift
//  Weather
//
//  Created by Alexandra Biryukova on 2/8/21.
//

import SwiftUI

enum Weather: String {
    case sun = "cloud.sun.fill"
    case rainSun = "cloud.sun.rain.fill"
    case wind
    case snowWind = "wind.snow"
    case moon = "moon.stars.fill"
}

struct Day {
    var weekday: String
    var weather: Weather
    var degrees: Int
}

struct AppTheme {
    enum ThemeType { case light, dark }
    
    var type: ThemeType
    
    var buttonTitle: String {
        switch type {
        case .light:
            return "Change day time"
        case .dark:
            return "Change night theme"
        }
    }
    var weather: Weather {
        switch type {
        case .light:
            return .sun
        case .dark:
            return .moon
        }
    }
    
    var backgroundColors: [UIColor] {
        switch type {
        case .light:
            return [#colorLiteral(red: 0.04604121298, green: 0.5065652132, blue: 0.9934260249, alpha: 1), #colorLiteral(red: 0.5258821249, green: 0.8294555545, blue: 0.9505758882, alpha: 1)]
        case .dark:
            return [#colorLiteral(red: 0.03136631846, green: 0.03137654066, blue: 0.03136408329, alpha: 1), #colorLiteral(red: 0.4667922258, green: 0.4664440751, blue: 0.4838180542, alpha: 1)]
        }
    }
    
    mutating func toggle() {
        type = type == .light ? .dark : .light
    }
    
    init(type: ThemeType) {
        self.type = type
    }
}

struct DayView: View {
    var day: Day
    
    init(day: Day) {
        self.day = day
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(day.weekday.uppercased())
                .font(.system(size: 16))
            Image(systemName: day.weather.rawValue)
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            Text("\(day.degrees)º")
                .font(.title)
        }.padding(4)
    }
}

struct ContentView: View {
    @State private var currentTheme = AppTheme(type: .light)
    let degrees: [Int] = [79, 74, 70, 70, 76]
    let weathers: [Weather] = [.sun, .rainSun, .wind, .snowWind, .sun]
    
    var weekDays: [String] {
        let startDay = Calendar.current.component(.weekday, from: Date())
        let endDay = (startDay + 4) % 7
        let days = Calendar.current.shortWeekdaySymbols
        guard startDay < endDay else {
            return Array(days[startDay..<days.count]) + Array(days[0...endDay])
        }
        return Array(days[startDay...endDay])
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(gradient: Gradient(colors: [Color(currentTheme.backgroundColors[0]),
                                                       Color(currentTheme.backgroundColors[1])]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 16) {
                Text("Cupertino, CA")
                    .font(.system(size: 32, weight: .medium))
                    .padding(.top, 16)
                Image(systemName: currentTheme.weather.rawValue)
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .padding(.top, 32)
                Text("89º")
                    .font(.system(size: 72, weight: .medium))
                    .padding(.top, 16)
                HStack {
                    ForEach(Array(weekDays.enumerated()), id: \.offset) { index, weekday in
                        DayView(day: .init(weekday: weekday, weather: weathers[index], degrees: degrees[index]))
                    }
                }.padding(.top, 16)
                Spacer()
                Button(action: { currentTheme.toggle() }) {
                    Text(currentTheme.buttonTitle)
                        .foregroundColor(.blue)
                        .font(.system(size: 20, weight: .bold))
                }.frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 48)
                Spacer()
            }
        }.foregroundColor(.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
