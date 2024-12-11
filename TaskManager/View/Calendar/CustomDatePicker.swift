//
//  DatePicker.swift
//  TaskManager
//
//  Created by Vladuslav on 19.08.2024.
//

import SwiftUI

struct CustomDatePicker: View {
    @Binding var currentDate: Date
    @State private var navigationState = false
    @State private var selectedDay: Date = .init()
    let scaleanimation = 0
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    @State private var date = Date.now
    @State private var days: [Date] = []
    let daysOfWeek: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" ]
    var body: some View {
        
        VStack{
            // Header
            HStack(spacing: 20){
                VStack{
                    Text(date.format("MMMM"))
                    Text(date.format("YYYY"))
                        .foregroundStyle(.gray)
                }
                .hSpacing(.leading)
                
                Spacer()
                
                Button{date = previousMonth(currentMonth: date)}label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.black)
                }
                Button{date = nextMonth(currentMonth: date)}label: {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.black)
                }
            }
            .padding()
            .font(.title)
            .bold()
            
            //Days
            HStack(spacing: 10){
                ForEach(daysOfWeek, id: \.self){day in
                    Text(day)
                        .font(.callout.bold())
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Dates
            LazyVGrid(columns: columns){
                ForEach(days, id: \.self){ day in
                    if day.monthInt != date.monthInt{
                        Text("")
                    }else{
                        Text("\(day.formatted(.dateTime.day()))")
                            .font(.callout.bold())
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(
                                Circle()
                                    .foregroundStyle(Date.now.startOfDay == day.startOfDay ? .green.opacity(0.4) : .gray.opacity(0.3))
                            )
                            .onTapGesture {
                                withAnimation(.snappy){
                                    navigationState = true
                                    selectedDay = day
                                    print(day)
                                }
                                
                            }
                    }
                }
                
            }
            NavigationLink(destination: CalendarTaskVIew(date: $selectedDay), isActive: $navigationState){EmptyView()}
        }
        .padding()
        .onAppear{
            days = date.calendarDisplayDays
        }
        .onChange(of: date){
            days = date.calendarDisplayDays
        }
    }
    func nextMonth (currentMonth: Date) -> Date{
        let calender = Calendar.current
        return calender.date(byAdding: .month, value: 1, to: currentMonth) ?? Date.now
    }
    func previousMonth (currentMonth: Date) -> Date{
        let calender = Calendar.current
        return calender.date(byAdding: .month, value: -1, to: currentMonth) ?? Date.now
    }
    
    
}

#Preview {
    Callendar()
}
