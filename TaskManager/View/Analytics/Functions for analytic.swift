//
//  Functions for analytic.swift
//  TaskManager
//
//  Created by Vladuslav on 06.09.2024.
//
import SwiftUI
import Foundation

func weekCount(tasks: [Task]) -> [String: Int] {
    let calendar = Calendar.current
    var sunday = Date.now
    repeat{
        sunday = calendar.date(byAdding: .day, value: -1, to: sunday)!
    }while sunday.format("E") != "Sun"
    
    
    var WeekCount: [String : Int] = [:]
    for _ in 1...7{
        WeekCount.updateValue(tasks.filter { task in
            return calendar.isDate(task.date, equalTo: sunday, toGranularity: .day)
        }.count, forKey: sunday.format("E"))
        sunday = Calendar.current.date(byAdding: .day, value: 1, to: sunday)!
    }
    
    return WeekCount
}
func tasksInDateRange(tasks: [Task]) -> Int {
    return tasks.filter { task in
        let calendar = Calendar.current
        let endOfDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -6, to: endOfDate)!
        return task.date >= startDate && task.date <= endOfDate
    }.count
    
}
func completedInDateRange(tasks: [Task]) -> Int {
    return tasks.filter { task in
        let calendar = Calendar.current
        let endOfDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -6, to: endOfDate)!
        return task.date >= startDate && task.date <= endOfDate && task.isComplete
    }.count

}

func MonthCount(tasks: [Task]) -> [String: Int] {
    let calendar = Calendar.current
    let start = Date().startOfMonth
    var taskCount: [String: Int] = [:]
    var step = start
    let end = Date().endOfMonth
    

    while step <= end {
        // Визначаємо кінець поточного тижня
        let currentEnd = calendar.date(byAdding: .day, value: 6, to: step)!.fixTimeZone()
        // Перевірка, щоб не виходити за межі кінця місяця
        let weekEnd = min(currentEnd, end)

        let startDay = step.format("dd")
        let endDay = weekEnd.format("dd")

        // Підрахунок задач в поточному тижні
        let count = tasks.filter { task in
            task.date >= step && task.date <= weekEnd
        }.count

        taskCount["\(startDay) - \(endDay)"] = count

        // Переходимо до наступного тижня (збільшуємо на 7 днів)
        step = calendar.date(byAdding: .day, value: 7, to: step)!.fixTimeZone()
    }



    return taskCount
}

func previousMonthCount(tasks: [Task]) -> [String: Int]{
    let calendar = Calendar.current
    let start = Date().startOfPreviousMonth
    let end = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: start) ?? Date()
    var step = start
    var taskCount: [String: Int] = [:]
    
    while step <= end {
        // Визначаємо кінець поточного тижня
        let currentEnd = calendar.date(byAdding: .day, value: 6, to: step)!.fixTimeZone()
        // Перевірка, щоб не виходити за межі кінця місяця
        let weekEnd = min(currentEnd, end)

        let startDay = step.format("dd")
        let endDay = weekEnd.format("dd")

        // Підрахунок задач в поточному тижні
        let count = tasks.filter { task in
            task.date >= step && task.date <= weekEnd
        }.count

        taskCount["\(startDay) - \(endDay)"] = count

        // Переходимо до наступного тижня (збільшуємо на 7 днів)
        step = calendar.date(byAdding: .day, value: 7, to: step)!.fixTimeZone()
    }
    

    
    return taskCount
}
    


func customPeriodCount(inPeriod startDeletePeriod: Date, to endDeletePeriod: Date, tasks: [Task]) -> [String: Int] {
    let calendar = Calendar.current
    var start = startDeletePeriod
    var stepForMoreDates = startDeletePeriod
    var fixWhileDate = endDeletePeriod
    var countTask = 0
    var dictForReturn: [String: Int] = [:]
    let tasksToCount = tasks.filter { task in
        let taskDate = calendar.startOfDay(for: task.date)
        let startDate = calendar.startOfDay(for: startDeletePeriod)
        let endDate = calendar.startOfDay(for: endDeletePeriod)
        
        return taskDate >= startDate && taskDate <= endDate
    }
    
    if calendar.dateComponents([.day], from: startDeletePeriod, to: endDeletePeriod).day ?? 0 <= 20 {
        fixWhileDate = calendar.date(byAdding: .day, value: 1, to: fixWhileDate) ?? endDeletePeriod
        while "\(start.format("dd")).\(start.format("MM"))" != "\(fixWhileDate.format("dd")).\(endDeletePeriod.format("MM"))" {
            countTask = tasks.filter { task in
                calendar.isDate(task.date, inSameDayAs: start)
            }.count
            dictForReturn["\(start.format("dd"))"] = countTask
            start = calendar.date(byAdding: .day, value: 1, to: start) ?? startDeletePeriod
        }
        return dictForReturn
    } else if calendar.dateComponents([.day], from: startDeletePeriod, to: endDeletePeriod).day ?? 0 <= 64{
        while "\(stepForMoreDates.format("dd")).\(stepForMoreDates.format("MM"))" != "\(endDeletePeriod.format("dd")).\(endDeletePeriod.format("MM"))" {
            stepForMoreDates = calendar.date(byAdding: .day, value: 7, to: start) ?? start
            stepForMoreDates = min(stepForMoreDates, endDeletePeriod)
            countTask = tasks.filter{task in
                return task.date >= start && task.date <= stepForMoreDates
            }.count
            dictForReturn["\(start.format("dd")) - \(stepForMoreDates.format("dd"))"] = countTask
            start = calendar.date(byAdding: .day, value: 8, to: start) ?? start
        }
        return dictForReturn
    } else {
        fixWhileDate = calendar.date(byAdding: .month, value: 1, to: fixWhileDate) ?? endDeletePeriod
        while "\(start.format("MM"))" != "\(fixWhileDate.format("MM"))" {
            print(Int(start.format("MM")) ?? start.format("MM"))
            countTask = tasks.filter{task in
                return task.date.format("MM") == start.format("MM")
            }.count
            dictForReturn["\(start.format("MM"))"] = countTask
            start = calendar.date(byAdding: .month, value: 1, to: start) ?? start
            
        }
        return dictForReturn
    }
    
}
