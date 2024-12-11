//
//  Analytic.swift
//  TaskManager
//
//  Created by Vladuslav on 26.08.2024.
//
import Foundation
import SwiftData


@Model
class Settings {
    var notification: Bool
    var interval: Int
    var morningTime: Date
    var endUpNotification: Bool = true
    var reminderNotification: Bool = true
    var morningNotification: Bool = true
    var summaryNotification: Bool = true
    
    
    
    init(notification: Bool = false, interval: Int = 3, morningTime: Date = createDateWithTimeOnly(hour: 8, minute: 0) ?? Date(), endUpNotification: Bool = true, reminderNotification: Bool = true, morningNotification: Bool = true, summaryNotification: Bool = true) {
        self.notification = notification
        self.interval = interval
        self.morningTime = morningTime
        self.endUpNotification = endUpNotification
        self.reminderNotification = reminderNotification
        self.morningNotification = morningNotification
        self.summaryNotification = summaryNotification
    }
}

func createDateWithTimeOnly(hour: Int, minute: Int) -> Date? {
    var components = Calendar.current.dateComponents([.year, .month, .day], from: Date()) // Поточний день
    components.hour = hour
    components.minute = minute
    
    return Calendar.current.date(from: components)
}
