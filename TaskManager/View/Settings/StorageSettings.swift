//
//  StorageSettings.swift
//  TaskManager
//
//  Created by Vladuslav on 10.09.2024.
//

import SwiftUI
import SwiftData

struct StorageSettings: View {
    @Environment(\.modelContext) var modelContext
    @Query private var Tasks: [Task]
    @State private var startDeletePeriod = Date()
    @State private var endDeletePeriod = Date()
    @State private var showingAlert = false
    
    var body: some View {
        Divider()
        Text("Choose the period you want to delete")
            .font(.title3)
        Text("You will delete: .. tasks")
            .font(.callout)
        HStack{
            
            HStack(alignment: .lastTextBaseline) {
                DatePicker("", selection: $startDeletePeriod, in: ...Date(), displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                
                Rectangle().frame(width: 2).frame(height: 30).foregroundStyle(.secondary.opacity(0.4)).cornerRadius(10)
                
                DatePicker("", selection: $endDeletePeriod, in: ...Date(), displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                
                Button(){showingAlert = true}label: {
                    Text("Delete")
                        .frame(width: 80,height: 30)
                        .foregroundStyle(.red)
                        .overlay{
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.red, lineWidth: 2)
                        }
                        .offset(y: -10)
                }.alert(Text("Are you sure?"),
                        isPresented: $showingAlert,
                        actions: {
                    Button(action: {deleteTasks(inPeriod: startDeletePeriod, to: endDeletePeriod, tasks: Tasks)}, label: {
                        Image(systemName: "trash")
                        Text("Delete")
                    }).foregroundColor(Color.red)
                    Button("Cancel", role: .cancel) { }
                }, message: {
                    Text("You want to delete \(tasksInDateRangeSettings(tasks: Tasks, inPeriod: startDeletePeriod, to: endDeletePeriod)) tasks")
                })
            }
                        
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .padding(0)
            
        }
    }
    
    func deleteTasks(inPeriod startDeletePeriod: Date, to endDeletePeriod: Date, tasks: [Task]) {
        let calendar = Calendar.current
        let tasksToDelete = tasks.filter { task in
            let taskDate = calendar.startOfDay(for: task.date)
            let startDate = calendar.startOfDay(for: startDeletePeriod)
            let endDate = calendar.startOfDay(for: endDeletePeriod)
            
            return taskDate >= startDate && taskDate <= endDate
        }
        print(tasksToDelete)
        // Видаляємо всі відфільтровані завдання
        for task in tasksToDelete {
            modelContext.delete(task)
        }

        // Зберігаємо зміни у моделі даних
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context after deletion: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
