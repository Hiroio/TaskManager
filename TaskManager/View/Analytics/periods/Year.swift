//
//  Year.swift
//  TaskManager
//
//  Created by Vladuslav on 01.09.2024.
//

import SwiftUI
import Charts

struct Year: View {
    @Bindable var tasks: Task
    
    var body: some View {
        Chart{
            AreaMark(
                x: .value(<#T##labelKey: LocalizedStringKey##LocalizedStringKey#>, <#T##value: Plottable##Plottable#>), y: <#T##PlottableValue<Plottable>#>
            )
        }
    }
}

#Preview {
    Year()
}
