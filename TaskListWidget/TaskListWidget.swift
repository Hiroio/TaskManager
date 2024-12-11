//
//  TaskListWidget.swift
//  TaskListWidget
//
//  Created by Vladuslav on 01.10.2024.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        let entry = SimpleEntry(date: .now)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    
}

struct TaskListWidgetEntryView : View {
    var entry: Provider.Entry
//    Query
    @Query(ListDescrriptor, animation: .snappy) private var tasks: [Task]
    var body: some View {
            VStack {
                if tasks.isEmpty {
                    VStack{
                        Spacer()
                        Text("Nothing to do?")
                        Text("Add a task!")
                        Text("🧐")
                        Spacer()
                    }
                } else{
                    VStack(spacing: 5){
                        HStack{
                            Spacer()
                            Text("Your Tasks")
                                .font(.caption.bold())
                            Spacer()
                        }
                        ForEach(tasks){task in
                            HStack(spacing: 0){
                                Circle()
                                    .fill(.white)
                                    .frame(width: 5)
                                    .padding(5)
                                Text(task.title)
                                    .font(.caption.bold())
                                    .lineLimit(1)
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color(task.tint).opacity(0.6))
                            .clipShape(.rect(cornerRadius: 25))
                        }
                    }
                }
            }
            .navigationTitle("Tasks")
            .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    static var ListDescrriptor: FetchDescriptor<Task> {
        let calendar = Calendar.current
        
        let todayStart = calendar.date(byAdding: .hour, value: -3, to: Date()) ?? Date()
        let tomorrowStart = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: todayStart)!)
        
        let predicate = #Predicate<Task> { !$0.isComplete && $0.date >= todayStart && $0.date < tomorrowStart }
        let sort = [SortDescriptor(\Task.date)]

        var descrriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        descrriptor.fetchLimit = 5
        return descrriptor
    }
}

struct TaskListWidget: Widget {
    let kind: String = "TaskListWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TaskListWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .modelContainer(for: Task.self)
        }
        .supportedFamilies([.systemMedium, .systemSmall])
        .configurationDisplayName("Today's tasks")
        .description("This is today's task list.")
    }
}

#Preview(as: .systemSmall) {
    TaskListWidget()
} timeline: {
    SimpleEntry(date: .now)
    
}
