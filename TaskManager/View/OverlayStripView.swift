//
//  Line for buttons.swift
//  TaskManager
//
//  Created by Vladuslav on 16.08.2024.
//

import SwiftUI
import SwiftData

struct OverlayStripView: View {
    @Query var settings: [Settings] // Для отримання даних з SwiftData
    @Environment(\.modelContext) private var context // Доступ до контексту SwiftData
    @State private var isStripVisible: Bool = true
    @State private var isButtonVisible = true
    @State private var animationCondition = true
    @State private var fakeBool: Bool = false
    
    var body: some View {
        HStack{
            if isStripVisible{
                if isButtonVisible{
                    Button(action: {
                        withAnimation {
                            self.isStripVisible.toggle()
                            isButtonVisible.toggle()
                            animationCondition.toggle()
                            
                        }
                    }, label: {
                        Text("<")
                            .offset(x: -10)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 60, height: 90)
                            .background(.gray.opacity(0.8))
                            .cornerRadius(40)
                            .padding()
                    })
                    .offset(x: 45)
                }
            }else{
                HStack(spacing: 45){
                    Button{ sleepForButton(); withAnimation(.bouncy){ animationCondition.toggle()}} label: {
                        Text(">")
                            .font(.title.bold())
                            .foregroundStyle(.white)
                    }
                    NavigationLink(destination: Callendar()){
                        Image(systemName: "calendar")
                            .font(.title)
                            .foregroundStyle(.white)
                    }
                    .offset(x: -18, y: 2)
                    NavigationLink(destination: MainAnalytics()){                        Image(systemName: "chart.bar.xaxis")
                            .font(.title)
                            .foregroundStyle(.white)
                    }
                    .offset(x: -25)
                    NavigationLink(destination: MainSettings(currentSettings: settings.first ?? isertSettings())){
                        Image(systemName: "gearshape.fill")
                            .font(.title)
                            .foregroundStyle(.white)
                    }
                    .offset(x: -35, y: 2)
                    
                }
                
                .transition(.move(edge: .trailing))
                .animation(.bouncy, value: isStripVisible)
                .frame(height: 60)
                .padding()
                .background(.gray.opacity(0.8))
                .cornerRadius(40)
                .offset(x: animationCondition ? 240 : 35, y: -15)
                
            }
        }
    }
    func isertSettings() -> Settings{
        let defaultSettings = Settings( morningTime: Date())
        context.insert(defaultSettings)
        return settings.first ?? Settings(morningTime: Date())
    }
    
    func sleepForButton() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            isButtonVisible.toggle()
            isStripVisible.toggle()
            
                    }
    }
}


#Preview {
    ContentView()
}
