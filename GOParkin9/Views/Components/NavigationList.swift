//
//  NavigationList.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 24/03/25.
//

import SwiftUI

struct NavigationButton: Identifiable {
    let id: Int
    let name: String
    let icon: String
}

struct NavigationButtonList: View {
    let navigations: [NavigationButton]
    @Binding var selectedNavigation: Int
    
    var body: some View {
        HStack(alignment: .top, spacing: 30) {
            ForEach(navigations) { navigation in
                Button {
                    selectedNavigation = navigation.id
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
    @State var showCompassView: Bool = false
    @State var selectedNavigation:Int = 0

    let navigations = [
        NavigationButton(id:1, name: "Entry Gate Basement 1", icon: "pedestrian.gate.open"),
        NavigationButton(id:2, name: "Exit Gate Basement 1", icon: "pedestrian.gate.closed"),
        NavigationButton(id:3, name: "Charging Station", icon: "bolt.car"),
        NavigationButton(id:4, name: "Entry Gate Basement 2", icon: "pedestrian.gate.open"),
        NavigationButton(id:5, name: "Exit Gate Basement 2", icon: "pedestrian.gate.closed"),
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
                        selectedNavigation: $selectedNavigation
                    )
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .onChange(of: selectedNavigation) {
                    isCompassOpen.toggle()
                    showCompassView = false
                        
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showCompassView = true
                    }
                }
                .fullScreenCover(isPresented: $isCompassOpen) {
                    if showCompassView {
                        CompassView(
                            isCompassOpen: $isCompassOpen,
                            selectedLocation: selectedNavigation,
                            longitude: 0,
                            latitude: 0
                        )
                    } else {                        ProgressView("Loading...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black.opacity(0.4))
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
