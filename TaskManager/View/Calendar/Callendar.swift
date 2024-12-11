//
//  Callendar.swift
//  TaskManager
//
//  Created by Vladuslav on 19.08.2024.
//

import SwiftUI

struct Callendar: View {
    @State var currentDate: Date = .init()
    var body: some View {
        NavigationStack{
            VStack{
                //Date picker
                CustomDatePicker(currentDate: $currentDate)
                    .frame(maxWidth: .infinity)
                
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .vSpacing(.top)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.secondary.opacity(0.1))
            .preferredColorScheme(.light)
            
        }
    }
}

#Preview {
    Callendar()
}
