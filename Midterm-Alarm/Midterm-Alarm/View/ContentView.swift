//
//  ContentView.swift
//  Midterm-Alarm
//
//  Created by Alexandra Biryukova on 3/18/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var alarmsViewModel = AlarmsViewModel()
    @State var isActive = false
    
    @ViewBuilder
    var listView: some View {
        if alarmsViewModel.alarms.isEmpty {
            VStack {
                Text("No alarms")
                    .padding(.top, 24)
                Spacer()
            }
        } else {
            List {
                ForEach(alarmsViewModel.alarms.sorted { $0.time < $1.time }) { alarm in
                    ZStack {
                        AlarmView(alarm: alarm, completion: { alarm, isEnabled in
                            var newAlarm = alarm
                            newAlarm.isEnabled = isEnabled
                            alarmsViewModel.changeAlarm(alarm: newAlarm)
                        })
                        NavigationLink(
                            destination: AlarmDetailView(viewState: .details, alarm: alarm, completion: {
                                alarm, action in
                                guard action == .delete else {
                                    alarmsViewModel.changeAlarm(alarm: alarm)
                                    return
                                }
                                alarmsViewModel.removeAlarm(alarm: alarm)
                            })) {
                        }.buttonStyle(PlainButtonStyle()).frame(width:0).opacity(0)
                    }
                }.onDelete(perform: alarmsViewModel.removeAlarm)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            listView
                .navigationBarTitle("Alarms", displayMode: .inline)
                .toolbar {
                    Button(action: { isActive = true }, label: {
                        Image(systemName: "plus")
                    })
                }
        } .sheet(isPresented: $isActive) {
            AlarmDetailView(viewState: .new, completion: { alarm, action in
                isActive = false
                alarmsViewModel.addAlarm(alarm: alarm)
            })
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
