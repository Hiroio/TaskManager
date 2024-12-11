//
//  ContentView.swift
//  TaskManager
//
//  Created by Vladuslav on 12.06.2024.
//

import SwiftUI


struct ContentView: View {
    @State private var isLoading = false
    
    var body: some View{
        if isLoading{
            SplashScreen()
                .onAppear {
                    // Затримка на 2 секунди для показу екрану завантаження
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            self.isLoading = false
                        }
                    }
                }
        }else{
            Home()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.mint.opacity(0.1))
                .preferredColorScheme(.light)
        }
    }
}

#Preview {
    ContentView()
}
