//
//  TaskManagerApp.swift
//  TaskManager
//
//  Created by Vladuslav on 12.06.2024.
//

import SwiftUI

@main
struct TaskManagerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Task.self, Settings.self])
    }
}
