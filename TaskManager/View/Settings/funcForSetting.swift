//
//  funcForSetting.swift
//  TaskManager
//
//  Created by Vladuslav on 14.09.2024.
//

import SwiftUI
import SwiftData
import Foundation
import UserNotifications


func tasksInDateRangeSettings(tasks: [Task], inPeriod startDeletePeriod: Date, to endDeletePeriod: Date) -> Int {
    let calendar = Calendar.current
    return tasks.filter { task in
        let taskDate = calendar.startOfDay(for: task.date)
        let startDate = calendar.startOfDay(for: startDeletePeriod)
        let endDate = calendar.startOfDay(for: endDeletePeriod)
        
        return taskDate >= startDate && taskDate <= endDate
    }.count
    
}


