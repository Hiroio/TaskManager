//
//  LineChart.swift
//  TaskManager
//
//  Created by Vladuslav on 28.09.2024.
//

import SwiftUI
import Charts

struct LineChart: View {
    @State private var selectedPeriod: String = "Week"
    @State var Tasks: [Task]
    @State private var customStartDate = Date()
    @State private var customEndDate = Date()
    
    let dayOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let periods: [String] = [ "Week", "Month", "Last-Month", "Custom"]
    @State var customRange: [String: Int]
    
    var body: some View {
        let weekValues = weekCount(tasks: Tasks)
        let thisMonth = MonthCount(tasks: Tasks)
        let previousMonth = previousMonthCount(tasks: Tasks)
        
        VStack{
            VStack(spacing: 0){
                Picker("Select Period", selection: $selectedPeriod) {
                    ForEach(periods, id: \.self) { period in
                        Text(period).tag(period).bold()
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                if selectedPeriod == "Custom" {
                    VStack(spacing: 0) {
                        ZStack{
                            HStack {
                                DatePicker("", selection: $customStartDate, in: ...Date(), displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                                
                                Rectangle().frame(width: 2).frame(height: 30).foregroundStyle(.secondary.opacity(0.4)).cornerRadius(10)
                                
                                DatePicker("", selection: $customEndDate, in: ...Date(), displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                                Button(){
                                    customRange = customPeriodCount(inPeriod: customStartDate, to: customEndDate, tasks: Tasks)
                                }label: {
                                    Image(systemName: "calendar.badge.checkmark")
                                        .foregroundStyle(.blue)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .padding(0)
                        }
                    }
                    
                }
                
            }
            .background(.secondary.opacity(0.1))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 2)
            }
            .padding()
            .transition(.move(edge: .top).combined(with: .opacity))
            .animation(.easeInOut(duration: 0.4), value: selectedPeriod)
            
            
            Chart {
                if selectedPeriod == "Week"{
                    ForEach(dayOfWeek, id: \.self) { day in
                        if let value = weekValues[day] {
                            LineMark(
                                x: .value("Day", day),
                                y: .value("Value", value)
                            )
                            .foregroundStyle(.green)
                        }
                    }
                }
                else if selectedPeriod == "Month"{
                    ForEach(sortedWeekKeys(from: thisMonth), id: \.self) { week in
                        if let value = thisMonth[week] {
                            LineMark(
                                x: .value("Day", week),
                                y: .value("Value", value)
                            )
                            .foregroundStyle(.green)
                        }
                    }
                } else if selectedPeriod == "Last-Month" {
                    ForEach(sortedWeekKeys(from: previousMonth), id: \.self) { week in
                        if let value = previousMonth[week] {
                            LineMark(
                                x: .value("Day", week),
                                y: .value("Value", value)
                            )
                            .foregroundStyle(.green)
                        }
                    }
                }else if selectedPeriod == "Custom" {
                    ForEach(sortDictionaryByCharacters(customRange), id: \.self) { item in
                        if let value = customRange[item] {
                            LineMark(
                                x: .value("Day", item),
                                y: .value("Value", value)
                            )
                            .foregroundStyle(.green)
                        }
                    }
                }
                
            }
            .padding()
            
            
        }
        .vSpacing(.top)
        .frame(maxWidth: .infinity)
        .frame(height: 300)
        .background(.white)
        .padding(5)
        .cornerRadius(40)
        .overlay{
            RoundedRectangle(cornerRadius: 40)
                .stroke(.black, lineWidth: 3)
            
        }
    }
    func sortDictionaryByFirstCharacter(_ dictionary: [String: Int]) -> [(key: String, value: Int)] {
        return dictionary.sorted { lhs, rhs in
            guard let lhsFirstChar = lhs.key.first, let rhsFirstChar = rhs.key.first else { return false }
            return lhsFirstChar < rhsFirstChar
        }
    }

    func sortDictionaryByCharacters(_ dictionary: [String: Int]) -> [String] {
        return dictionary.sorted { lhs, rhs in
            let lhsFirstTwoChars = lhs.key.prefix(2)
            let rhsFirstTwoChars = rhs.key.prefix(2)
            return lhsFirstTwoChars < rhsFirstTwoChars
        }
        .map { $0.key }
    }
    
    func sortedWeekKeys(from taskCount: [String: Int]) -> [String] {
        return taskCount.keys.sorted { key1, key2 in
            let week1Start = Int(key1.split(separator: "-")[0]) ?? 0
            let week2Start = Int(key2.split(separator: "-")[0]) ?? 0
            return week1Start < week2Start
        }
    }
}

#Preview {
    MainAnalytics()
}
