//
//  NewTask.swift
//  TaskManager
//
//  Created by Vladuslav on 10.08.2024.
//

import SwiftUI
import SwiftData

struct NewTask: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var taskTittle: String = ""
    @State private var TaskCaption: String = ""
    @State private var taskDate: Date = Date()
    @State private var taskColor: String = "taskColor1"
    
    @Environment(\.modelContext) private var context
    
    var body: some View {
        VStack(alignment: .leading){
            VStack(alignment: .leading){
                Label("Add new Task", systemImage: "arrow.left")
                    .font(.title2)
                    .onTapGesture {
                        dismiss()
                    }
                VStack(spacing: 10){
                    TextField("Your task Tittle", text: $taskTittle)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Divider()
                    
                }.padding(.top)
            }
            .hSpacing(.leading)
            .padding(15)
            .frame(maxWidth: .infinity)
            .background{
                Rectangle().fill(.white)
                    .clipShape(.rect(bottomLeadingRadius: 30, bottomTrailingRadius: 30))
                    .ignoresSafeArea()
            }
            
            
            // Task Tittle
            VStack(alignment: .leading, spacing: 30, content: {

                VStack(spacing: 20){
                    TextField("Your task Caption", text: $TaskCaption)
                        .font(.title3)
                    Divider()
                }
                VStack(alignment: .leading, spacing: 20){
                    Text("Timeline")
                        .font(.title3)
                    
                    DatePicker("", selection: $taskDate, in: ...Date())
                        .datePickerStyle(.automatic)
                        .frame(maxWidth: .infinity)
                        .onTapGesture(count: 99, perform: {
                            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Code@*/ /*@END_MENU_TOKEN@*/
                        })
                    
                    Divider()
                    
                }
                VStack(alignment: .leading, spacing: 20){
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
                }
            })
            .padding(30)
            .vSpacing(.top)
            
            Button{
                let task = Task(title: taskTittle, caption: TaskCaption, date: taskDate, tint: taskColor)
                do{
                    context.insert(task)
                    try context.save()
                    dismiss()
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
                            .clipShape(.rect(topLeadingRadius: 40, topTrailingRadius: 40))
                            .ignoresSafeArea()
                    }
            }

        }
        .vSpacing(.top)
        .background(.secondary.opacity(0.1))
        .ignoresSafeArea(.keyboard, edges: .bottom)
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
