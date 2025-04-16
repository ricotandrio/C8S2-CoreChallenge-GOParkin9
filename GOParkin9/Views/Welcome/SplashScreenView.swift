//
//  DetailHistoryView.swift
//  GOParkin9
//
//  Created by Chikmah on 08/04/25.
//

import SwiftUI

//extension Color {
//    static let backgroundColor = Color(red: 246/255, green: 247/255, blue: 237/255) //Praxeti White
//    static let mainColor = Color(red: 0/255, green: 31/255, blue: 63/255) //Midnight Mirage
//    static let highligthColor = Color(red: 219/255, green: 230/255, blue: 76/255) //First Color of Spring
//    static let secondaryColor1 = Color(red: 30/255, green: 72/255, blue: 143/255) //Nuit Blache
//    static let secondaryColor2 = Color(red: 0/255, green: 128/255, blue: 76/255) //Picture Book Green
//    static let secondaryColor3 = Color(red: 116/255, green: 195/255, blue: 101/255) //Mantis
//}

struct SplashScreenView: View {
    @State private var animateToCenter = false
    @State private var scaleDown = false
    @State private var showText = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                // MARK: 2 PNGs Merge
                ZStack {
                    Image("logo3-P")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .offset(x: animateToCenter ? 0 : -50)
                    
                    Image("logo3-A")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .offset(y: animateToCenter ? 0 : 50)
                }
                .scaleEffect(scaleDown ? 1.5 : 2)
                .animation(.easeInOut(duration: 0.5), value: animateToCenter)
                .animation(.easeInOut(duration: 0.5), value: scaleDown)

                // MARK: Text "GOParkin9"
                    Text("GOParkin9")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color.main)
                        .offset(y: showText ? 0 : -30)
                        .opacity(showText ? 1 : 0)
                        .animation(.easeInOut(duration: 0.6), value: showText)
                        .padding(.top, 30)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                animateToCenter = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                scaleDown = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                showText = true
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
