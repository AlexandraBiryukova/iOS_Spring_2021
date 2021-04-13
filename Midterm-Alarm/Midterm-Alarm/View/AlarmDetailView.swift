//
//  AlarmDetailView.swift
//  Midterm-Alarm
//
//  Created by Alexandra Biryukova on 3/18/21.
//

import SwiftUI

struct AlarmDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    enum ViewState { case new, details }
    enum Action { case save, delete }
    @State private var alarm: Alarm
    
    private let viewState: ViewState
    private let completion: (Alarm, Action) -> ()
    
    init(viewState: ViewState, alarm: Alarm? = nil, completion: @escaping (Alarm, Action) -> ()) {
        self.viewState = viewState
        if let alarm = alarm {
            _alarm = State(wrappedValue: alarm)
        } else {
            _alarm = State(initialValue: Alarm(time: Date(), description: "", isEnabled: false))
        }
        self.completion = completion
    }
    
    @ViewBuilder
    var cancelButton: some View {
        if viewState == .new {
            Button(action: { self.presentationMode.wrappedValue.dismiss()}, label: {
                Text("Cancel")
            })
        }
    }
    
    @ViewBuilder
    var deleteButton: some View {
        if viewState == .details {
            Button("Delete") {
                completion(alarm, .delete)
                self.presentationMode.wrappedValue.dismiss()
            }.disabled(alarm.description.isEmpty)
            .foregroundColor(.white)
            .font(.system(size: 18, weight: .medium, design: .default))
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(Color.red)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                Spacer()
                VStack(spacing: 16) {
                    DatePicker("", selection: $alarm.time,
                               displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                    TextField("Alarm description", text: $alarm.description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal, 48)
                Spacer()
                VStack(spacing: 8) {
                    deleteButton
                    Button(viewState == .details ? "Change" : "Save") {
                        completion(alarm, .save)
                        self.presentationMode.wrappedValue.dismiss()
                    }.disabled(alarm.description.isEmpty)
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .medium, design: .default))
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(buttonColor)
                }
                .padding(.horizontal, 32)
            }
            .navigationBarItems(leading: cancelButton)
            .navigationBarTitle("New Alarm", displayMode: .inline)
            .navigationBarHidden(viewState == .details)
            .padding(.top, 24)
        }
        .navigationBarTitle("Change Alarm", displayMode: .inline)
        
    }
    
    var buttonColor: Color {
        return alarm.description.isEmpty ? .gray : .blue
    }
}
