//
//  Task.swift
//  TaskManager
//
//  Created by Vladuslav on 12.06.2024.
//

import SwiftUI
import SwiftData

@Model
class Task: Identifiable, ObservableObject{
    var id: UUID
    var title: String
    var caption: String
    var date: Date
    var isEnding: Bool
    var endDate: Date
    var isComplete: Bool
    var tint: String
    var emoji: String
    
    init(id: UUID = .init(), title: String, caption: String, date: Date = .init(),isEnding: Bool = false, endDate: Date = .init(), isComplete: Bool = false, tint: String, emoji: String) {
        self.id = id
        self.title = title
        self.caption = caption
        self.date = date
        self.isEnding = isEnding
        self.endDate = endDate
        self.isComplete = isComplete
        self.tint = tint
        self.emoji = emoji
    }
    
    var tintColor: Color {
        switch tint{
        case "taskColor1": return .taskColor1
        case "taskColor2": return .taskColor2
        case "taskColor3": return .taskColor3
        case "taskColor4": return .taskColor4
        case "taskColor5": return .taskColor5
        case "taskColor6": return .taskColor6
        case "taskColor7": return .taskColor7
        case "taskColor8": return .taskColor8
        default: return .black
            
        }
    }
}


extension Date {
    static func updateHour(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: value, to: .init()) ?? .init()
    }
}


class TaskList: ObservableObject {
    @Published var tasks: [Task] = []
}
