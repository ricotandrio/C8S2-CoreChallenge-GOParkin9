//
//  CompassView.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 25/03/25.
//

import SwiftUI
import CoreLocation

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct CompassView: View {
    @StateObject var navigationManager = NavigationManager()
    @State var isSpeechEnabled = true
    
    @Binding var isCompassOpen: Bool
    
    @State var selectedLocation: String
    @State var longitude: Double
    @State var latitude: Double
    
    @State var options = [
        Location(name: "Entry Gate", coordinate: CLLocationCoordinate2D(latitude: -6.2963229765925615, longitude: 106.64088135638036)),
        Location(name: "Exit Gate", coordinate: CLLocationCoordinate2D(latitude: -6.2963229765925615, longitude: 106.64088135638036)),
        Location(name: "Charging Station", coordinate: CLLocationCoordinate2D(latitude: -16.2963229765925615, longitude: 66.64088135638036))
    ]
    
    var speechUtteranceManager = SpeechUtteranceManager()
    
    var targetDestination: CLLocationCoordinate2D {
        options.first(where:
            { $0.name == selectedLocation })?.coordinate ??
        CLLocationCoordinate2D(latitude: 0, longitude: 0
        )
    }
    
    var currentAngle: Double {
        navigationManager.angle(to: targetDestination)
    }
    
    var clockDirection: String {
        switch currentAngle {
        case 0..<15, 345...360:
            return "12 o'clock"
        case 15..<45:
            return "1 o'clock"
        case 45..<75:
            return "2 o'clock"
        case 75..<105:
            return "3 o'clock"
        case 105..<135:
            return "4 o'clock"
        case 135..<165:
            return "5 o'clock"
        case 165..<195:
            return "6 o'clock"
        case 195..<225:
            return "7 o'clock"
        case 225..<255:
            return "8 o'clock"
        case 255..<285:
            return "9 o'clock"
        case 285..<315:
            return "10 o'clock"
        case 315..<345:
            return "11 o'clock"
        default:
            return "Unknown direction"
        }
    }

    
    func speak(_ text: String) {
        if isSpeechEnabled {
            speechUtteranceManager.stopSpeaking()
            speechUtteranceManager.speak(text: text)
        }
    }
    
    func appendLocation() {
        if selectedLocation=="Parking Location" {
            options.append(Location(name: selectedLocation, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)))
        }
    }
    
    var formattedDistance: String {
        let distance = navigationManager.distance(to: targetDestination)
        if distance > 999 {
            return String(format: "%.2f km", distance / 1000)
        } else {
            return "\(Int(distance)) m"
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
                    ForEach(options, id: \.name) { option in
                        Text(option.name)
                            .font(.title)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 80)
                .padding(.leading, -10)
//                Text("\(option)")
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
                    speak("Turn to the \(clockDirection)")
                }
            
            Spacer()
            
            Text("Turn to the \(clockDirection)")
                .font(.headline)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .onTapGesture {
                    speak("Turn to the \(clockDirection)")
                }
            
            Text("\(formattedDistance) to \(selectedLocation)")
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
        .onAppear {
            print(selectedLocation)
            appendLocation()
        }
    }
}
