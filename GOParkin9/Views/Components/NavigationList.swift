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
    let navigations = [
        NavigationButton(name: "Entry Gate A", icon: "pedestrian.gate.open"),
        NavigationButton(name: "Exit Gate B", icon: "pedestrian.gate.closed"),
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
                HStack {
                    ForEach(navigations) { navigation in
                        VStack {
                            Button(action: {
                                print(navigation.name)
                            }) {
                                Image(systemName: navigation.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.blue)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                            }
                            .frame(width: 60, height: 60)
                            
                            Spacer()
                                .frame(height: 10)
                            
                            Text(navigation.name)
                                .font(.caption)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
