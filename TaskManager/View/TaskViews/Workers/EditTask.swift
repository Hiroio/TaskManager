//
//  EditTask.swift
//  TaskManager
//
//  Created by Vladuslav on 23.08.2024.
//

import SwiftUI
import SwiftData

struct EditTask: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var Task: Task
    
    var body: some View {
        VStack(alignment: .leading){
            VStack(alignment: .leading){
                Label("Add new Task", systemImage: "arrow.left")
                    .font(.title2)
                    .onTapGesture {
                        dismiss()
                    }
                VStack(spacing: 10){
                    TextField("Your task Tittle", text: $Task.title)
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
                    TextField("Your task Caption", text: $Task.caption)
                        .font(.title3)
                    Divider()
                }
                VStack(alignment: .leading, spacing: 20){
                    Text("Timeline")
                        .font(.title3)
                    
                    DatePicker("", selection: $Task.date)
                        .datePickerStyle(.compact)
                    
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
                                        .opacity(Task.tint == color ? 0.5 : 0)
                                }
                                .scaleEffect(Task.tint == color ? 1.2 : 1)
                                .onTapGesture {
                                    withAnimation(.snappy) {
                                        Task.tint = color
                                    }
                                    
                                }
                        }
                    }
                }
            })
            .padding(30)
            .vSpacing(.top)
            
            Button{
                    dismiss()
            } label: {
                Text("Save Task")
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

//#Preview {
//    do{
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: TaskModel.self, configurations: config)
//        let example = TaskModel(title: "Teste", caption: "TesteTeste", date: Date(), endDate: Date(), tint: "taskColor5", isCompleted: false, isEditing: false, emoji: "😀")
//        return EditTask(Task: example)
//            .modelContainer(container)
//    }catch{
//        fatalError("Failed to create model container")
//    }
//}
