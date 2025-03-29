//
//  NavigationList.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 24/03/25.
//

import SwiftUI

struct NavigationButton: Identifiable {
    let id: UUID = UUID()
    let name: String
    let icon: String
}

struct NavigationList: View {
    @Binding var isCompassOpen: Bool
    
    @State var selectedNavigationName = ""
    
    let navigations = [
        NavigationButton(name: "Entry Gate", icon: "pedestrian.gate.open"),
        NavigationButton(name: "Exit Gate", icon: "pedestrian.gate.closed"),
        NavigationButton(name: "Charging Station", icon: "bolt.car"),
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Section(header:
                Text("Navigate to")
                    .font(.title3)
                    .fontWeight(.bold)
                    .opacity(0.6)
            ) {
                HStack(alignment: .top) {
                    ForEach(navigations) { navigation in
                        Button {
                            selectedNavigationName = navigation.name
                        } label: {
                            VStack {
                                Image(systemName: navigation.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.blue)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                    .frame(width: 60, height: 60)
                                
                                Text(navigation.name)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: 60)
                                    .padding(5)
                                    .foregroundStyle(Color.black)
                            }
                            .contentShape(Rectangle())
                        }
                        Spacer()
                            .frame(width: 20)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .onChange(of: selectedNavigationName) {
                    isCompassOpen.toggle()
                }
                .fullScreenCover(isPresented: $isCompassOpen) {
                    CompassView(
                        isCompassOpen: $isCompassOpen,
                        selectedLocation: selectedNavigationName,
                        longitude: 0,
                        latitude: 0
                    )
                }
            }
        }

    }
}

#Preview {
    ContentView()
}
