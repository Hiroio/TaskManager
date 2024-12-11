//
//  TasksView.swift
//  TaskManager
//
//  Created by Vladuslav on 12.08.2024.
//

import SwiftUI
import SwiftData

struct TasksView: View {
    
    @Binding var date: Date
    // SwiftData Dynamic query
    @Query private var tasks: [Task]
    init(date: Binding<Date>) {
        self._date = date
        
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date.wrappedValue)
        let endOfDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        let predicate = #Predicate<Task> {
            return $0.date >= startDate && $0.date < endOfDate
        }
        
        // Settings
        let sortDescriptor = [
            SortDescriptor(\Task.date)
        ]
        self._tasks = Query(filter: predicate, sort: sortDescriptor, animation: .snappy)
    }
    var body: some View {
        VStack{
            if tasks.isEmpty{
                VStack{
                    Text("Create Tasks")
                        .font(.title.bold())
                        .foregroundStyle(.secondary.opacity(0.4))
                        .padding(.top, 30)
                    Image(systemName: "shared.with.you")
                        .resizable()
                        .scaledToFit()
                        .padding(60)
                        .foregroundColor(.secondary.opacity(0.4))
                }
                    .padding(.top, 15)
                
            }else{
                VStack(alignment: .leading){
                    ForEach(tasks) { task in
                        TaskItem(task: task)
                            .background(alignment: .leading){
                                if tasks.last?.id != task.id{
                                    Rectangle()
                                        .frame(width: 2)
                                        .offset(x: 9, y: 45)
                                    
                                }
                            }
                    }
                }
                .padding(.top)
            }
        }
    }
}

    #Preview {
        ContentView()
    }
