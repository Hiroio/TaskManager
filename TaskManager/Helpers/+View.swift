//
//  +View.swift
//  TaskManager
//
//  Created by Vladuslav on 12.06.2024.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func hSpacing(_ alignment: Alignment) -> some View{
        self.frame(maxWidth: .infinity, alignment: alignment)
    }
    @ViewBuilder
    func vSpacing(_ alignment: Alignment) -> some View{
        self.frame(maxHeight: .infinity, alignment: alignment)
    }
    
    //same date check

}
func isSameDate(_ date1: Date, _ date2: Date) -> Bool{
    return Calendar.current.isDate(date1, inSameDayAs: date2)
}

extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(limit))
            }
        }
        return self
    }
}
