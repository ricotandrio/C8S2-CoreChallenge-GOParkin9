//
//  CompassView.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 25/03/25.
//

import SwiftUI
import CoreLocation

struct CompassView: View {
    @StateObject var navigationManager = NavigationManager()
    @State var isSpeechEnabled = true
    
    @Binding var isCompassOpen: Bool
    
    @State var selectedLocation: String = "Vehicle Charging Station"
    
    let options = ["Vehicle Charging Station", "Parking Area"]
    
    var speechUtteranceManager = SpeechUtteranceManager()
    
    let targetDestination = CLLocationCoordinate2D(latitude: -6.2963229765925615, longitude: 106.64088135638036)
    
    var currentAngle: Double {
        navigationManager.angle(to: targetDestination)
    }
    
    func speak(_ text: String) {
        if isSpeechEnabled {
            speechUtteranceManager.stopSpeaking()
            speechUtteranceManager.speak(text: text)
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                Text("NAVIGATE TO")
                    .font(.headline)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .opacity(0.7)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, -10)
                
                Picker("Select an option", selection: $selectedLocation) {
                            ForEach(options, id: \.self) { option in
                                Text(option)
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 80)
                    .padding(.leading, -10)
            }
            .padding()
            
            Spacer()

            Image(systemName: "arrow.up")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 200)
                .foregroundColor(Color.white)
                .rotationEffect(.degrees(currentAngle))
                .animation(.easeInOut(duration: 0.5), value: currentAngle)
                .onTapGesture {
                    speak("Turn \(currentAngle) degree")
                }
            
            Spacer()
            
            Text("Turn \(currentAngle) degree")
                .font(.headline)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .onTapGesture {
                    speak("Turn \(currentAngle) degree")
                }
            
            Text("300m to Vehicle Charging Station")
                .font(.headline)
                .foregroundColor(.white)
                .fontWeight(.medium)
                .opacity(0.8)
            
            Spacer()
                .frame(height: 20)
            
            HStack {
                
                
                Button {
                    isCompassOpen.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                        .padding(25)
                        .background(Color.gray.opacity(0.5))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Button {
                    speechUtteranceManager.stopSpeaking()
                    isSpeechEnabled.toggle()
                } label: {
                    Image(systemName: isSpeechEnabled ? "speaker.wave.2" : "speaker.slash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                        .padding(20)
                        .background(Color.gray.opacity(0.5))
                        .clipShape(Circle())
                }

            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.green)
        
    }
}

#Preview {
    CompassView(isCompassOpen: .constant(true))
}
