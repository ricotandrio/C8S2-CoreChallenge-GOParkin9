//
//  WelcomeScreenView.swift
//  GOParkin9
//
//  Created by Chikmah on 08/04/25.
//

import SwiftUI

struct WelcomeScreenView: View {
    @EnvironmentObject private var userSettingsVM: UserSettingsViewModel
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 30) {
                // Welcome Text
                Text("Welcome to")
                    .foregroundStyle(Color.secondary1)
                    .font(.title)
                    .fontWeight(.bold)

                // App Logo
                Image("GOParkin9-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)

                // App Name
                Text("GOParkin9")
                    .foregroundStyle(Color.main)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, -20)

                // Tagline
                Text("Your smart assistant to save and find your parking spot! Park with ease and speed ✨")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // Feature Icons Row
                HStack(spacing: 30) {
                    FeatureCircleView(icon: "figure.walk", caption: "Navigate in parking area")
                    FeatureCircleView(icon: "mappin.and.ellipse", caption: "Save your location")
                    FeatureCircleView(icon: "car.fill", caption: "Find vehicle easily")
                }
                .padding()

                // Get Started Button
                Button(action: {
                    userSettingsVM.markAppAsLaunched()
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}

#Preview {
    WelcomeScreenView()
}
