//
//  LoadingScreen.swift
//  TaskManager
//
//  Created by Vladuslav on 16.08.2024.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Color.secondary.opacity(0.2)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.black)
                Text("Welcome to MyApp")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .padding(.top, 20)
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
