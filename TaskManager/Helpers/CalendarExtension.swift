//
//  CalendarExtension.swift
//  TaskManager
//
//  Created by Vladuslav on 04.09.2024.
//

import Foundation

extension Calendar {
    func rangeFromTodayToSixMonthsAgo(from date: Date) -> Range<Date>? {
        // Отримуємо початкову дату, тобто сьогоднішній день
        let startOfRange = date
        
        // Обчислюємо дату, яка відповідає півроку назад
        guard let endOfRange = self.date(byAdding: .month, value: -6, to: startOfRange) else {
            return nil
        }
        
        return endOfRange..<startOfRange
    }

    func rangeOfDaysInPreviousMonth(from date: Date) -> Range<Int>? {
        guard let oneMonthAgo = self.date(byAdding: .month, value: -1, to: date) else {
            return nil
        }
        
        // Повертаємо діапазон днів для минулого місяця
        return self.range(of: .day, in: .month, for: oneMonthAgo)
    }
    
    func rangeOfCurrentMonth(from date: Date) -> Range<Date>? {
        // Отримуємо початок поточного місяця
        guard let startOfMonth = self.date(from: self.dateComponents([.year, .month], from: date)) else {
            return nil
        }
        
        // Отримуємо початок наступного місяця
        guard let endOfMonth = self.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) else {
            return nil
        }
        
        return startOfMonth..<self.date(byAdding: .day, value: 1, to: endOfMonth)!
    }
    
    func rangeOfCurrentWeek(from date: Date) -> Range<Date>? {
            // Отримуємо початок поточного тижня (понеділок)
            guard let startOfWeek = self.dateInterval(of: .weekOfYear, for: date)?.start else {
                return nil
            }
            
            // Додаємо 6 днів до початку тижня, щоб отримати кінець тижня (неділя)
            guard let endOfWeek = self.date(byAdding: .day, value: 6, to: startOfWeek) else {
                return nil
            }
            
            return startOfWeek..<self.date(byAdding: .day, value: 1, to: endOfWeek)!
        }
    
    
}
