//
//  Notifications.swift
//  TaskManager
//
//  Created by Vladuslav on 19.09.2024.
//

import SwiftUI
import UserNotifications

var accessGranted = false


func requestNotificationPermission() async -> Bool {
    let center = UNUserNotificationCenter.current()
    
    do {
        // Використовуємо await для асинхронного запиту
        let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
        if granted {
            print("Дозвіл отримано")
            manageNotification()
            return true
        } else {
            print("Дозвіл відхилено")
            return false
        }
    } catch {
        print("Сталася помилка: \(error.localizedDescription)")
        return false
    }
}

func manageNotification(){
    scheduleDailySummary()
    morningNotification()
    reminderIntervalNotification(interval: 3)
}

// нічне підведення підсумків
func scheduleDailySummary() {
    let content = UNMutableNotificationContent()
    content.title = "Щоденне зведення"
    content.body = "Ось підсумки за сьогодні."
    content.sound = .default
    
    var dateComponents = DateComponents()
    dateComponents.hour = 22 // Сповіщення о 21:00
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    let request = UNNotificationRequest(identifier: "scheduleDailySummary", content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request)
}


// щоранкове сповіщення
func morningNotification(){
    let content = UNMutableNotificationContent()
    content.title = "Good morning!"
    content.body = "Are you ready to start your day?"
    content.sound = .default
    
    var dateComponents = DateComponents()
    dateComponents.hour = 08 // Сповіщення о 08:00
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    let request = UNNotificationRequest(identifier: "morningNotification", content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request)
}


// коли закінчується таск сповіщення
func taskExpirationNotification(tasks: [Task]){
    let content = UNMutableNotificationContent()

    content.sound = .default
    let calendar = Calendar.current
    
    
    let filteredTasks = tasks.filter { task in
        calendar.isDate(task.endDate, inSameDayAs: Date())
    }
    
    let taskDictionary = filteredTasks.reduce(into: [String: Date]()) { dict, task in
        dict[task.title] = task.endDate
    }
    
    for (key , value) in taskDictionary{
        var fixedValue = value.fixTimeZone()
        let trigger = UNCalendarNotificationTrigger(dateMatching: calendar.dateComponents([.day, .hour, .minute], from: fixedValue), repeats: false)
        let request = UNNotificationRequest(identifier: key, content: content, trigger: trigger)
        
             
        content.title = "Task '\(key)' is Ending"
        content.body = "Are you ready to end with it?"
        
        UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Помилка при додаванні сповіщення: \(error)")
                    }else{
                        print("Сповіщення готове")
                        print(value.formatted(.dateTime))
                    }
                }
    }
    
    
    
    
}

// нагадування із інтервалом
func reminderIntervalNotification(interval: Int = 3){
    let content = UNMutableNotificationContent()
    content.title = "Нагадування"
    content.body = "Минуло \(interval / 3600) години."
    content.sound = .default
    
    // Тригер через певний інтервал часу
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(interval * 3600), repeats: false)
    
    // Створюємо унікальний запит для кожного часу
    let request = UNNotificationRequest(identifier: "reminderIntervalNotification", content: content, trigger: trigger)
    
    // Додаємо сповіщення
    UNUserNotificationCenter.current().add(request)
}
