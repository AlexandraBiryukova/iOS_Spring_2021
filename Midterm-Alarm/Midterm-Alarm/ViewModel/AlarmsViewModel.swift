//
//  AlarmsViewModel.swift
//  Midterm-Alarm
//
//  Created by Alexandra Biryukova on 3/18/21.
//

import SwiftUI

struct Alarm: Identifiable, Equatable {
    let id = UUID()
    var time: Date
    var description: String
    var isEnabled: Bool
}

class AlarmsViewModel: ObservableObject {
    @Published var alarms: [Alarm] = []
    
    func removeAlarm(at indexSet: IndexSet) {
        removeAlarm(alarm: alarms.sorted { $0.time < $1.time }[indexSet.first ?? 0])
    }
    
    func changeAlarm(alarm: Alarm) {
        guard let index = alarms.firstIndex(where: { $0.id == alarm.id }) else { return }
        alarms[index] = alarm
    }
    
    func removeAlarm(alarm: Alarm) {
        guard let index = alarms.firstIndex(where: { $0.id == alarm.id }) else { return }
        alarms.remove(at: index)
    }
    
    func addAlarm(alarm: Alarm) {
        alarms.append(alarm)
    }
}
