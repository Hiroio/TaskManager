//
//  MainAnalytics.swift
//  TaskManager
//
//  Created by Vladuslav on 26.08.2024.
//

import SwiftUI
import SwiftData
import Charts

struct MainAnalytics: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var Tasks: [Task]
    
    @State private var selectedPeriod: String = "Week"
    @State private var taskCounts: [String: Int] = [:]
    @State private var customStartDate = Date()
    @State private var customEndDate = Date()
    
    
    
    let dayOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let periods: [String] = [ "Week", "Month", "Last-Month", "Custom"]
    let calendar = Calendar.current
    let TodaysDay = Date()
    
    var body: some View {
        let completedTasksCount = Tasks.filter { $0.isComplete }.count
        let notCompletedTasksCount = Tasks.filter { !$0.isComplete }.count
        
        NavigationStack{
            GeometryReader{_ in
                VStack{
                    VStack{
                        Chart {
                            SectorMark(angle: .value("Completed", completedTasksCount), innerRadius: .ratio(0.7), angularInset: 1.5)
                                .foregroundStyle(.green.opacity(0.7))
                            
                                .cornerRadius(8)
                            
                            
                            SectorMark(angle: .value("Not Completed", notCompletedTasksCount), innerRadius: .ratio(0.7), angularInset: 1.5)
                                .foregroundStyle(.red.opacity(0.7))
                                .cornerRadius(8)
                            
                        }
                        
                        .chartBackground{_ in
                            VStack{
                                Text("Total Tasks")
                                    .font(.title2)
                                Text("\(Tasks.count)")
                                    .font(.title2.bold())
                            }
                        }
                        .padding(.top, 10)
                        Spacer()
                        HStack{
                            HStack{
                                Circle()
                                    .fill(.green)
                                    .frame(width: 10)
                                Text("Completed: \(completedTasksCount)")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                            Spacer()
                            
                            HStack{
                                Circle()
                                    .fill(.red)
                                    .frame(width: 10)
                                Text("Uncompleted: \(notCompletedTasksCount)")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 10)
                    }
                    .fixedSize(horizontal: false, vertical: false)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 50)
                    .background(.white)
                    .cornerRadius(40)
                    .overlay{
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(.black, lineWidth: 3)
                    }
                    
                    
                    HStack(spacing: 12){
                        
                        HStack {
                            ZStack{
                                VStack{
                                    Text("\(tasksInDateRange(tasks: Tasks))")
                                        .font(.system(size: 30).bold())
                                        .foregroundStyle(.green.opacity(0.8))
                                        .padding()
                                        .background(
                                            Circle()
                                                .stroke(.black, lineWidth: 2)
                                                .fill(.green.opacity(0.2))
                                        )
                                        .offset(x: 35)
                                    
                                }
                                VStack{
                                    Text("Avarage")
                                        .font(.title2.bold())
                                        .offset(x: -15, y: -15)
                                        .lineLimit(1)
                                        .frame(width: 100)
                                    Text("Task")
                                        .font(.title.bold())
                                        .offset(x: -35)
                                        .lineLimit(1)
                                        .frame(width: 100)
                                        .foregroundStyle(.green.opacity(0.6))
                                    Text("perweek")
                                        .font(.title2.bold())
                                        .offset(x: -15, y: 15)
                                        .lineLimit(1)
                                        .frame(width: 100)
                                }
                                
                            }
                        }
                        .frame(width: 160, height: 150)
                        .background(Color.white)
                        .overlay{
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(.black, lineWidth: 4)
                        }
                        .cornerRadius(30)
                        
                        
                        
                        HStack{
                            ZStack{
                                VStack{
                                    ZStack{
                                        Text("13")
                                            .font(.system(size: 30).bold())
                                            .foregroundStyle(.red.opacity(0.8))
                                            .padding()
                                            .background(
                                                Circle()
                                                    .stroke(.black, lineWidth: 2)
                                                    .fill(.red.opacity(0.2))
                                            )
                                            .offset(x: -35)
                                    }
                                    
                                }
                                VStack{
                                    Text("Avarage")
                                        .font(.title2.bold())
                                        .offset(x: 15, y: -15)
                                        .lineLimit(1)
                                        .frame(width: 100)
                                    Text("TIme")
                                        .font(.title.bold())
                                        .offset(x: 35)
                                        .lineLimit(1)
                                        .frame(width: 100)
                                        .foregroundStyle(.red.opacity(0.6))
                                    Text("perday")
                                        .font(.title2.bold())
                                        .offset(x: 15, y: 15)
                                        .lineLimit(1)
                                        .frame(width: 100)
                                }
                                
                            }
                        }
                        .frame(width: 160, height: 150)
                        .background(.white)
                        .overlay{
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(.black, lineWidth: 4)
                        }
                        .cornerRadius(30)
                    }
                    LineChart(Tasks: Tasks, customRange: [:])
                }
                .padding(.horizontal, 15)
                
            }
            .navigationTitle("Your Analytics")
            .navigationBarTitleDisplayMode(.inline)
            .background(.secondary.opacity(0.2))
            
        }
    }
}

    

    

    



#Preview {
    MainAnalytics()
}
