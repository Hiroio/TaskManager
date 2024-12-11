//
//  CalendarTaskVIew.swift
//  TaskManager
//
//  Created by Vladuslav on 20.08.2024.
//

import SwiftUI
import SwiftData

struct CalendarTaskVIew: View {
    @Binding var date: Date
    @Query private var tasks: [Task]
    init(date: Binding<Date>) {
        self._date = date
        
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date.wrappedValue)
        let endOfDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        let predicate = #Predicate<Task> {
            return $0.date >= startDate && $0.date < endOfDate
        }
        let sortDescriptor = [
            SortDescriptor(\Task.date, order: .reverse)
        ]
        self._tasks = Query(filter: predicate, sort: sortDescriptor, animation: .snappy)
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 6, content: {
            HStack(spacing: 5){
                Text(date.formatted(date: .complete, time: .omitted))
                    .font(.title2)
            }
            .hSpacing(.leading)
            .font(.title)
            .bold()
            .padding()
            ScrollView{
            if tasks.isEmpty{
                VStack{
                    Text("No tasks")
                        .font(.title.bold())
                        .foregroundStyle(.secondary.opacity(0.4))
                        .padding(.top, 30)
                    Image(systemName: "list.bullet")
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
                    .padding(.top)
                }
            }
        }
            
        })
        .vSpacing(.top)
    }
}

#Preview {
    Callendar()
}
