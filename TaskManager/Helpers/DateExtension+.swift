//
//  DateExtension.swift
//  TaskManager
//
//  Created by Vladuslav on 12.06.2024.
//

import SwiftUI

extension Date{
    func format(_ format: String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
    
    func fixTimeZone() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    struct WeekDay: Identifiable{
        var id: UUID = .init()
        var date: Date
    }
    
    //Cheacking for todays date
    var isToday: Bool{
        return Calendar.current.isDateInToday(self)
    }
    
    var isSameHour: Bool {
        return Calendar.current.compare(self, to: .init(), toGranularity: .hour) == .orderedSame
    }
    
    var isPast: Bool{
        return Calendar.current.compare(self, to: .init(), toGranularity: .hour) == .orderedSame
    }
    
    //fetching week based on date
    func fetchWeek(_ date: Date = .init()) -> [WeekDay] {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        
        var week: [WeekDay] = []
        let weekDate = calendar.dateInterval(of: .weekOfMonth, for: startDate)
        guard let startWeek = weekDate?.start else{
            return []
        }
        //  full week
        (0..<7).forEach{index in
            if let weekDay = calendar.date(byAdding: .day, value: index, to: startDate){
                week.append(.init(date: weekDay))
            }
        }
        return week
    }
    
    //next week creation
    func createNextWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfLastDate = calendar.startOfDay(for: self)
        guard let nextDate = calendar.date(byAdding: .weekday,value: 1, to: startOfLastDate) else { return [] }
        
        return fetchWeek(nextDate)
    }
    
    // previous week creation
    func createPreviousWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfLastDate = calendar.startOfDay(for: self)
        guard let nextDate = calendar.date(byAdding: .weekday,value: -7, to: startOfLastDate) else { return [] }
        
        return fetchWeek(nextDate)
    }
    
    func adding (_ component: Calendar.Component, value: Int, using calendar: Calendar = .current) -> Date? {
            return calendar.date(byAdding: component, value: value, to: self)
        }

        var startOfDayNow: Date {
            return Calendar.current.startOfDay(for: self)
        }
    
}
