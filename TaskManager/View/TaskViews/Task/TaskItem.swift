//
//  TaskItem.swift
//  TaskManager
//
//  Created by Vladuslav on 17.06.2024.
//

import SwiftUI
import SwiftData

struct TaskItem: View {
    
    @Bindable var task: Task
    @Environment(\.modelContext) private var modelContext
    @State private var offsetX: CGFloat = 0
    @State private var showButtons: Bool = false
    @State private var navigationState = false
    @State private var taskIsEnd = false
    @State private var isEmojiPopoverPresented = false
    
    var body: some View {
        
        HStack{
            Circle()
                .fill(indicatedColor)
                .frame(width: 15, height: 15)
                .padding(1)
                .background(.white.shadow(.drop(color: .black.opacity(0.5), radius: 1)), in: .circle)
                .overlay{
                    Circle()
                        .frame(width: 50, height: 50)
                        .blendMode(.destinationOver)
                        .onTapGesture {
                            withAnimation(.snappy){
                                task.isComplete.toggle()
                            }
                        }
                }
            HStack{
                VStack(alignment: .leading, spacing: 4){
                    HStack{
                        Text(task.title)
                            .font(.system(size: 20, weight: .semibold))
                        
                        Spacer()
                        Label("\(task.date.format("hh:mm a"))", systemImage: "clock")
                            .font(.callout)
                        
                    }
                    .hSpacing(.leading)
                    HStack{
                        Text(task.caption)
                            .font(.callout)
                        if task.isEnding{
                            Spacer()
                            Label("\(task.endDate.format("hh:mm a"))", systemImage: "clock.badge.checkmark")
                                .font(.callout)
                        }
                    }
                }
                VStack{
                    Text("\(task.emoji)")
                        .font(.largeTitle)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(task.tint).opacity(0.5))
            .clipShape(.rect(cornerRadius: 25))
            .offset(x: offsetX)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.width < 0 {
                            offsetX = max(value.translation.width, -10) // Фіксований офсет -25
                            showButtons = true
                        }
                    }
                    .onEnded { value in
                        withAnimation {
                            if value.translation.width < -3 {
                                offsetX = -3 // Залишається на -25 після завершення свайпу
                                showButtons = true
                            } else {
                                offsetX = 0
                                showButtons = false
                            }
                        }
                    })
            if showButtons{
                HStack{
                    // Кнопки для свайпу
                    VStack(spacing: 4) {
                        Button(action: {
                            deleteTask(task)
                        }) {
                            Image(systemName: "trash")
                                .font(.title)
                                .foregroundColor(.red)
                                .cornerRadius(8)
                        }
                        Button(action: {
                            withAnimation(.snappy){
                                navigationState.toggle()
                                
                            }
                        }) {
                            Image(systemName: "pencil")
                                .font(.title)
                                .foregroundColor(.gray)
                                .cornerRadius(8)
                        }
                    }
                    .offset(x: showButtons ? 0 : 80)
                    .opacity(showButtons ? 1 : 0)
                    
                    
                }
                .frame(width: 30)
            }
        }
        .padding(3)
//        NavigationLink(destination: EditTask(Task: task), isActive: $navigationState){EmptyView()}
        
        if navigationState{
            VStack{
                TextField("Your task Tittle", text: $task.title.max(14))
                    .lineLimit(1)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 15)
                    .overlay{
                        Divider()
                            .offset(y: 15)
                            .padding()
                    }
                
                
                HStack{
                    VStack{
                        TextField("Your task Caption", text: $task.caption)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 15)
                            .overlay{
                                Divider()
                                    .offset(y: 15)
                                    .padding()
                            }
                    }
                    Spacer()
                    Button(action: {
                        isEmojiPopoverPresented.toggle()
                    }) {
                        Text("\(task.emoji)")
                            .padding()
                            .font(.largeTitle)
                    }
                    .popover(isPresented: $isEmojiPopoverPresented) {
                        EmojiSelectorView(selection: $task.emoji)
                            .frame(minWidth: 300, maxHeight: 400)
                            .presentationCompactAdaptation(.popover)
                    }
                    
                }
                HStack{
                    VStack{
                        Text("Date")
                            .vSpacing(.leading)
                        Button(){
                            showButtons.toggle()
                            navigationState.toggle()
                        }label: {
                            Text("Save")
                                .padding(10)
                                .padding(.horizontal, 15)
                                .foregroundStyle(.white)
                                .background{
                                    Rectangle()
                                        .fill(.black)
                                        .cornerRadius(30)
                                }
                        }
                    }
                    Spacer()
                    VStack{
                        DatePicker("", selection: $task.date)
                            .datePickerStyle(.automatic)
                            .frame(maxWidth: .infinity)
                            .onTapGesture(count: 99, perform: {
                                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Code@*/ /*@END_MENU_TOKEN@*/
                            })
                        HStack{
                            Spacer()
                            Text("Expiration")
                            Toggle("", isOn: $task.isEnding)
                                .frame(width: 40)
                                .padding(.trailing, 15)
                        }
                        if task.isEnding{
                            DatePicker("", selection: $task.endDate)
                                .datePickerStyle(.automatic)
                                .frame(maxWidth: .infinity)
                                .onTapGesture(count: 99, perform: {
                                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Code@*/ /*@END_MENU_TOKEN@*/
                                })
                        }
                        
                    }
                }
                .padding(.horizontal, 15)
                
            }
        }
    }
        
        var indicatedColor: Color {
            if task.isComplete {
                return .green
            }
            return task.date.isSameHour ? .white : task.date.isPast ? .blue : .white
        }
        
        private func deleteTask(_ task: Task) {
            modelContext.delete(task) // Видалення завдання з контексту SwiftData
            
            do {
                try modelContext.save() // Збереження змін
            } catch {
                print("Помилка при збереженні після видалення: \(error)")
            }
        }
    }
    
#Preview {
    ContentView()
}
