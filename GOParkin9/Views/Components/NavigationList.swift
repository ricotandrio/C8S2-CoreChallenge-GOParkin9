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

struct NavigationButtonList: View {
    let navigations: [NavigationButton]
    @Binding var selectedNavigationName: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 30) {
            ForEach(navigations) { navigation in
                Button {
                    selectedNavigationName = navigation.name
                } label: {
                    VStack {
                        Image(systemName: navigation.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 40)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .frame(width: 60, height: 60)

                        Text(navigation.name)
                            .font(.caption)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: 80)
                            .padding(.top, 5)
                            .foregroundColor(Color.primary)

                    }
                    .contentShape(Rectangle())
                }
            }
        }
        .padding(.leading, 8)
        .padding(.vertical)
    }
}

struct NavigationList: View {

    @State var isCompassOpen: Bool = false
    
    @State var selectedNavigationName = ""

    let navigations = [
        NavigationButton(name: "Entry Gate Basement 1", icon: "pedestrian.gate.open"),
        NavigationButton(name: "Exit Gate Basemenet 1", icon: "pedestrian.gate.closed"),
        NavigationButton(name: "Charging Station", icon: "bolt.car"),
        NavigationButton(name: "Entry Gate Basement 2", icon: "pedestrian.gate.open"),
        NavigationButton(name: "Exit Gate Basement 2", icon: "pedestrian.gate.closed"),
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Section(header:
                VStack(alignment: .leading) {
                    Text("Navigate Around")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Where do you want to go?")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
            ) {
             
                ScrollView(.horizontal, showsIndicators: false) {
                    NavigationButtonList(
                        navigations: navigations,
                        selectedNavigationName: $selectedNavigationName
                    )
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
