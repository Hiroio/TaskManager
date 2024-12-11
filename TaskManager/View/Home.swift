//
//  ContentView.swift
//  TaskManager
//
//  Created by Vladuslav on 12.06.2024.
//

import SwiftUI
import SwiftData

struct Home: View {
    @State var currentDate: Date = .init()
    //Slider
    @State var weekSlider: [[Date.WeekDay]] = []
    @State var currentWeekIndex: Int = 1
    @State var createTaskStatus = false
    
    //Namespace animation
    @Namespace private var animation
    
    @State var createWeek: Bool = false
    
    @State private var isStripVisible = false
    
    // Create task
    @State private var  createNewTask: Bool = false
    
    var body: some View {
        NavigationStack{
            GeometryReader{_ in
            ZStack{
                if createNewTask {
                    Color.secondary.opacity(0.8)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture{
                            createNewTask = false
                        }
                        .zIndex(1)
                    CreateTask(createTask: $createNewTask)
                        .transition(.move(edge: .bottom))
                        .zIndex(2)
                }
                VStack(alignment: .leading, spacing: 0){
                    // HeaderView
                    HeaderView()
                    
                    // ScrollView for Tasks
                    ScrollView(.vertical){
                        VStack{
                            // Task View
                            TasksView(date: $currentDate)
                        }
                        .hSpacing(.center)
                        .vSpacing(.center)
                    }
                    .scrollIndicators(.hidden)
                    
                }
                .vSpacing(.top)
                .frame(maxWidth: .infinity)
                .onAppear() {
                    if weekSlider.isEmpty{
                        let currentWeek = Date().fetchWeek()
                        
                        if let firstDate = currentWeek.first?.date {
                            weekSlider.append(firstDate.createPreviousWeek())
                        }
                        weekSlider.append(currentWeek)
                        
                        if let lastDate = currentWeek.last?.date {
                            weekSlider.append(lastDate.createNextWeek())
                        }
                    }
                    
                }
                .overlay(alignment: .topTrailing){
                    Button(action: {
                        withAnimation{
                            
                            createNewTask.toggle()
                        }
                    }, label: {
                        Image(systemName: "plus")
                            .imageScale(.large)
                            .padding(10)
                            .background(.black)
                            .clipShape(Circle())
                            .padding([.horizontal])
                            .foregroundColor(.white)
                    })
                    .padding(.top, 20)
                    .background(.clear)
                }
                .overlay(alignment: .bottomTrailing){
                    OverlayStripView()
                }
                
            }
        }
            .ignoresSafeArea(.keyboard)
        }
    }
    
    // header
    @ViewBuilder
    func HeaderView() -> some View{
        VStack(alignment: .leading, spacing: 6, content: {
            HStack(spacing: 5){
                Text(currentDate.format("MMMM"))
                Text(currentDate.format("YYYY"))
                    .foregroundStyle(.gray)
            }
            .font(.title)
            .bold()
            
            Text(currentDate.formatted(date: .complete, time: .omitted))
                .font(.callout)
                .fontWeight(.semibold)
                .textScale(.secondary)
            
            TabView(selection: $currentWeekIndex){
                ForEach(weekSlider.indices, id: \.self) {index in
                    let week = weekSlider[index]
                    
                    weekView(week)
                        .padding(.horizontal, 5)
                        .tag(index)
                }
            }
            .padding(.horizontal, -15)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 90)
        })
        .padding(15)
        .hSpacing(.leading)
        .background{
            Rectangle().fill(.white)
                .clipShape(.rect(bottomLeadingRadius: 30, bottomTrailingRadius: 30))
                .ignoresSafeArea()
        }
        .onChange(of: currentWeekIndex, initial: false) { oldValue, newValue in
            //Create when reach fisrt last page
            if newValue == 0 || newValue == (weekSlider.count - 1) {
                createWeek = true
            }
        }
    }
    
    // slider
    @ViewBuilder
    func weekView(_ week: [Date.WeekDay]) -> some View{
        HStack(spacing: 0) {
            ForEach(week) { day in
                VStack(spacing: 8){
                    Text(day.date.format("E"))
                        .font(.title3)
                        .fontWeight(.medium)
                        .textScale(.secondary)
                        .foregroundStyle(.gray)
                    
                        Text(day.date.format("dd"))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .textScale(.secondary)
                            .foregroundStyle(isSameDate(day.date, currentDate) ? .white : .black)
                            .frame(width: 35, height: 35)
                            .background{
                                if isSameDate(day.date, currentDate){
                                    Circle()
                                        .fill(.black)
                                        .matchedGeometryEffect(id: "TABINDICATOR", in: animation)
                                }
                                if day.date .isToday{
                                    Circle()
                                        .fill(.green)
                                        .frame(width: 5, height: 5)
                                        .offset(y: 15)
                                        
                                }
                            }
                            .background(.white.shadow(.drop(radius: 1)), in: .circle)
                        
                        // Indicator for current day
                                            }
                .hSpacing(.center)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.snappy){
                        currentDate = day.date
                    }
                    
                }
            }
        }
        .background{
            GeometryReader {
                let minX = $0.frame(in: .global).minX
                
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self, perform: { value in
                        if value.rounded() == 15 && createWeek{
                            paginateWeek()
                            createWeek = false
                        }
                    })
            }
        }
    }
    
    
    func paginateWeek() {
        if weekSlider.indices.contains(currentWeekIndex){
            if let firstDate = weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                weekSlider.insert(firstDate.createPreviousWeek(), at: 0)
                weekSlider.removeLast()
                currentWeekIndex = 1
            }
            if let lastDate = weekSlider[currentWeekIndex].last?.date, case self.currentWeekIndex = (weekSlider.count - 1){
                weekSlider.append(lastDate.createNextWeek())
                weekSlider.removeFirst()
                self.currentWeekIndex = weekSlider.count - 2
            }
        }
    }
    
}

#Preview {
    ContentView()
}
