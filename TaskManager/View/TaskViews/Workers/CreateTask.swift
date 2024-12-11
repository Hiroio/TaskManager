//
//  CreateTask.swift
//  TaskManager
//
//  Created by Vladuslav on 11.09.2024.
//

import SwiftUI
import SwiftData


struct CreateTask: View {
    @Query private var Tasks: [Task]
    @Binding var createTask: Bool
    @State private var taskTittle: String = ""
    @State private var taskCaption: String = ""
    @State private var taskDate: Date = Date()
    @State private var taskEndingDate: Date = Date()
    @State private var taskColor: String = "taskColor1"
    @State private var endTask = false
    @State private var isEmojiPopoverPresented = false
    @State private var selectedEmoji: String = "🧐"
    
    
    @Environment(\.modelContext) private var context
    
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading, spacing: 4){
                    HStack{
                        Text(taskTittle)
                            .font(.system(size: 20, weight: .semibold))
                            .hSpacing(.leading)
                        Spacer()
                        Image(systemName: "clock")
                        VStack{
                            Text("\(taskDate.format("hh:mm a"))")
                                .font(.callout)
                            if endTask{
                                Text("\(taskEndingDate.format("hh:mm a"))")
                                    .font(.callout)
                            }
                        }
                        
                    }
                    
                    Text(taskCaption)
                        .font(.callout)
                    
                }
                .frame(maxWidth: .infinity)
                
                Text("\(selectedEmoji)")
                    .font(.largeTitle)
                
            }
            .padding()
            .background(Color(taskColor))
            .clipShape(.rect(cornerRadius: 25))
            .padding(.horizontal, 20)
            VStack{
                TextField("Your task Tittle", text: self.$taskTittle.max(14))
                    .lineLimit(1)
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding()
                    .overlay{
                        Divider()
                            .offset(y: 15)
                            .padding()
                    }
                
                
                HStack{
                    VStack{
                        TextField("Your task Caption", text: $taskCaption)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding()
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
                        Text("\(selectedEmoji)")
                            .padding()
                            .font(.largeTitle)
                    }
                    .popover(isPresented: $isEmojiPopoverPresented) {
                       EmojiSelectorView(selection: $selectedEmoji)
                            .frame(minWidth: 300, maxHeight: 400)
                            .presentationCompactAdaptation(.popover)
                    }
                }
                HStack{
                    Text("Date")
                    Spacer()
                    VStack{
                        DatePicker("", selection: $taskDate)
                            .datePickerStyle(.automatic)
                            .frame(maxWidth: .infinity)
                            .onTapGesture(count: 99, perform: {
                                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Code@*/ /*@END_MENU_TOKEN@*/
                            })
                        HStack{
                            Spacer()
                            Text("Expiration")
                            Toggle("", isOn: $endTask)
                                .frame(width: 40)
                                .padding(.trailing, 15)
                        }
                        if endTask{
                            DatePicker("", selection: $taskEndingDate)
                                .datePickerStyle(.automatic)
                                .frame(maxWidth: .infinity)
                                .onTapGesture(count: 99, perform: {
                                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Code@*/ /*@END_MENU_TOKEN@*/
                                })
                        }
                        
                    }
                }
                .padding()
                VStack(alignment: .leading){
                    Text("Task Color")
                        .font(.title3)
                    
                    let colors:[String] = (1...8).compactMap{ color in
                        return "taskColor\(color)"
                    }
                    
                    HStack(spacing: 5){
                        ForEach(colors, id: \.self){ color in
                            Circle()
                                .fill(Color(color))
                                .padding(2)
                                .background{
                                    Circle()
                                        .fill(.black)
                                        .opacity(taskColor == color ? 0.5 : 0)
                                }
                                .scaleEffect(taskColor == color ? 1.2 : 1)
                                .onTapGesture {
                                    withAnimation(.snappy) {
                                        taskColor = color
                                    }
                                    
                                }
                        }
                    }
                    .padding()
                }
                .padding()
                
            }
            .padding()
            .background(.white)
            .cornerRadius(20)
            .overlay{
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.black, lineWidth: 4)
            }
            .padding()
            Button{
                let task = Task(title: taskTittle, caption: taskCaption, date: taskDate,isEnding: endTask, endDate: taskEndingDate, tint: taskColor, emoji: selectedEmoji)
                do{
                    
                    context.insert(task)
                    try context.save()
                    createTask = false
                    taskExpirationNotification(tasks: Tasks)
                } catch {
                    print(error.localizedDescription)
                }
            } label: {
                Text("Create Task")
                    .frame(maxWidth: .infinity)
                    .frame(height: 70)
                    .foregroundColor(.white)
                    .font(.title2.bold())
                    .background{
                        Rectangle().fill(.black)
                            .cornerRadius(30)
                            .ignoresSafeArea()
                    }
            }
            .padding(.horizontal, 15)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.clear)
        .ignoresSafeArea(.keyboard)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button(action: {
                    hideKeyboard()
                }) {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
            }
        }
        .onTapGesture {
            self.hideKeyboard()
        }
    }
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
    
#Preview {
    ContentView()
}

