//
//  AlarmView.swift
//  Midterm-Alarm
//
//  Created by Alexandra Biryukova on 3/18/21.
//

import SwiftUI

struct AlarmView: View {
    @Binding var alarm: Alarm
    @State var isEnabled: Bool
    
    private let completion: (Alarm, Bool) -> Void
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    init(alarm: Alarm, completion: @escaping (Alarm, Bool) -> Void) {
        _alarm = .constant(alarm)
        _isEnabled = State(wrappedValue: alarm.isEnabled)
        self.completion = completion
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Toggle(isOn: $isEnabled) {
                VStack(spacing: 8) {
                    Text("\(alarm.time, formatter: Self.dateFormatter)")
                        .font(.system(size: 40, weight: .bold))
                        .multilineTextAlignment(.center)
                    Text(alarm.description)
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                }
                .onReceive([isEnabled].publisher.first()) { (isEnabled) in
                    guard alarm.isEnabled != isEnabled else { return }
                    completion(alarm, isEnabled)
                }
                .padding(.leading, 16)
                .padding(.bottom, 8)
            }
        }
    }
}
