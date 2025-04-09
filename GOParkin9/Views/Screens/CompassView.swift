//
//  CompassView.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 25/03/25.
//

import SwiftUI
import CoreLocation
import SwiftData

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let label: String
    let coordinate: CLLocationCoordinate2D
}

struct CompassView: View {
    @StateObject var navigationManager = NavigationManager()
    @State var isSpeechEnabled = false
    
    @Binding var isCompassOpen: Bool
    
    @State var selectedLocation: String
    @State var longitude: Double
    @State var latitude: Double
    
    @Query(filter: #Predicate<ParkingRecord>{p in p.isHistory == false}) var parkingRecords: [ParkingRecord]

    var firstParkingRecord: ParkingRecord? {
        parkingRecords.first
    }
    
    @State var options = [
        Location(name: "Entry Gate B1", label: "Entry Gate Basement 1", coordinate: CLLocationCoordinate2D(latitude: -6.302254, longitude: 106.652554)),
        Location(name: "Exit Gate B1", label: "Exit Gate Basement 1", coordinate: CLLocationCoordinate2D(latitude: -6.302244, longitude: 106.652582)),
        Location(name: "Entry Gate B2", label: "Entry Gate Basement 2", coordinate: CLLocationCoordinate2D(latitude: -6.301891, longitude: 106.652777)),
        Location(name: "Exit Gate B2", label: "Exit Gate Basement 2", coordinate: CLLocationCoordinate2D(latitude: -6.301597, longitude: 106.652761)),
        Location(name: "Charging Station", label: "Charging Station", coordinate: CLLocationCoordinate2D(latitude: -6.302097, longitude: 106.652612))
    ]
    
    var speechUtteranceManager = SpeechUtteranceManager()
    
    var targetDestination: CLLocationCoordinate2D {

        options.first(where: { $0.name == selectedLocation })?.coordinate ??
            CLLocationCoordinate2D(latitude: 0, longitude: 0)

    }
    
    var currentAngle: Double {
        navigationManager.angle(to: targetDestination)
    }
    
    @State var previousAngle: Double = 0
    @State var displayedAngle: Double = 0
    
    private func updateDisplayedAngle(to newAngle: Double) {
        let normalizedNew = newAngle.truncatingRemainder(dividingBy: 360)
        let normalizedPrev = previousAngle.truncatingRemainder(dividingBy: 360)

        var delta = normalizedNew - normalizedPrev
        if delta > 180 {
            delta -= 360
        } else if delta < -180 {
            delta += 360
        }

        let smoothedAngle = displayedAngle + delta

        withAnimation(.easeInOut(duration: 0.4)) {
            displayedAngle = smoothedAngle
        }

        previousAngle = normalizedNew
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
    
    func appendLocationActiveParking() {
        if let record = firstParkingRecord {
            options.append(Location(name: "Parking Location", label: "Parking Location", coordinate: CLLocationCoordinate2D(latitude: record.latitude, longitude: record.longitude)))
        }
        
        if selectedLocation=="Parking Location History" {
            options.append(Location(name: selectedLocation, label: selectedLocation, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)))
        }
    }
    

    var formattedDistance: (String, Int) {
        let distance = navigationManager.distance(to: targetDestination)
        if distance > 999 {
            return (String(format: "%.2f km", distance / 1000), Int(distance))
        } else {
            return ("\(Int(distance)) m", Int(distance))
        }
    }
    
    @State private var isPulsing = false

    var body: some View {
        
        VStack {
            VStack {
                Text("Navigate to")
                    .font(.title3)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .opacity(0.7)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 10)
                
                Divider()
                    .frame(height: 1)
                    .background(Color.white.opacity(0.5))
                    .padding(.horizontal, 20)
                
                Picker("Select an option", selection: $selectedLocation) {
                    ForEach(options, id: \.name) { option in
                        Text(option.label)
                            .font(.title)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 130)

            }
            .padding()
            
            Spacer()
            
            ZStack {
                if formattedDistance.1 <= 5 {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 150, height: 150)
                        .scaleEffect(isPulsing ? 1.2 : 0.8)
                        .opacity(isPulsing ? 0.5 : 1.0)
                        .transition(.scale.combined(with: .opacity))
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                                isPulsing.toggle()
                            }
                            
                            if isSpeechEnabled {
                                speechUtteranceManager.speak(text: "You have arrived at \(selectedLocation)")
                            }
                        }
                } else {
                    Image(systemName: "arrow.up")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 200)
                        .foregroundColor(Color.white)
                        .rotationEffect(.degrees(displayedAngle))
//                        .animation(.easeInOut(duration: 0.5), value: currentAngle)
                        .onChange(of: navigationManager.angle(to: targetDestination)) { newRawAngle in
                            updateDisplayedAngle(to: newRawAngle)
                            
                        }
                        .onChange(of: clockDirection) {
                            speechUtteranceManager.stopSpeaking()
                            if isSpeechEnabled {
                                speechUtteranceManager.speak(text: "Turn to the \(clockDirection)")
                            }
                        }
                }
            }
            .animation(.easeInOut(duration: 0.5), value: formattedDistance.1)
            
            Spacer()

            if formattedDistance.1 <= 5 {
                Text("Check nearby vehicle in the area")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                Text("You have arrived at location")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                    .opacity(0.8)
                
            } else {
                Text("Turn to the \(clockDirection)")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                Text("\(formattedDistance.0) to location")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                    .opacity(0.8)
            }

            
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
                    if isSpeechEnabled {
                        speechUtteranceManager.stopSpeaking()
                    } else {
                        if formattedDistance.1 <= 5 {
                            speechUtteranceManager.speak(text: "You have arrived at \(selectedLocation)")
                        } else {
                            speechUtteranceManager.speak(text: "Turn to the \(clockDirection)")
                        }
                    }
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
                        .animation(nil, value: isSpeechEnabled)
                }

            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.secondary3)
        .onAppear {
//            appendLocation()
            appendLocationActiveParking()
        }
    }
}
