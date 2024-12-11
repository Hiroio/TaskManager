//
//  MainSettings.swift
//  TaskManager
//
//  Created by Vladuslav on 10.09.2024.
//

import SwiftUI
import SwiftData

struct MainSettings: View {
    
    @Bindable var currentSettings: Settings
    @State private var endUpNotification = true
    @State private var isNotification = true
    @State private var reminderNotification = true
    @State private var morningNotification = true
    @State private var summaryNotification = true
    @State private var notificationIntervalSelection = 3
    
    let notificationInterval = [1, 2, 3, 6]
    
    var body: some View {
        VStack(spacing: 10){
            Text("Settings")
                .font(.title.bold())
            
            Rectangle()
                .frame(width: .infinity, height: 2)
                .foregroundStyle(.secondary.opacity(0.5))
            VStack(spacing: 15){
                Toggle("Notification",  isOn: $currentSettings.notification)
                    .font(.title2.bold())
                    .hSpacing(.leading)
                    .disabled(true)
                    .onTapGesture {
                    }
            }
            
            Divider()
            VStack(spacing: 15){
                Toggle("Show end-up notification", isOn: $currentSettings.endUpNotification)
                    .toggleStyle(.switch)
                    .font(.title3)
                
                
                
                Toggle("Morning notification", isOn: $currentSettings.morningNotification)
                    .toggleStyle(.switch)
                    .font(.title3)
                DatePicker("Select the time", selection: $currentSettings.morningTime, displayedComponents: .hourAndMinute)
                    .pickerStyle(.inline)
                
                Toggle("Daily Summary notification", isOn: $currentSettings.summaryNotification)
                    .toggleStyle(.switch)
                    .font(.title3)
                
                HStack{
                    Toggle("Reminder Notification",  isOn: $currentSettings.reminderNotification)
                        .font(.title3)
                        .hSpacing(.leading)
                }
                HStack{
                    Text("Reminder interval")
                        .padding(.horizontal, 15)
                    Spacer()
                    
                    Picker("", selection: $currentSettings.interval){
                        ForEach(notificationInterval, id: \.self){item in
                            Text("\(item) Hours")
                                .foregroundStyle(.white)
                        }
                        
                        
                        
                    }
                    .disabled(!currentSettings.reminderNotification)
                    .pickerStyle(.menu)
                    .background(.secondary.opacity(0.2))
                    .cornerRadius(30)
                    .accentColor(.black)
                    
                    
                }
            }
            .disabled(!currentSettings.notification)
            .padding()
            VStack{
                Divider()
                Text("Storage")
                    .font(.title2.bold())
                    .padding()
                    .hSpacing(.leading)
                StorageSettings()
                
            }
            .padding()
        }
        .hSpacing(.leading)
        .vSpacing(.top)
        .padding(.top, 15)
    }
    
    
    #Preview {
        ContentView()
    }
}
