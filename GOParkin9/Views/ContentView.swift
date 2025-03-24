//
//  ContentView.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 20/03/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = "Home"

    var body: some View {
        VStack {
            ScrollView {
                switch selectedTab {
                case "Home":
                    HomeView()
                case "History":
                    tiew()
                default:
                    Text("Unknown Tab")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Divider()

            TabView(selection: $selectedTab) {
                Text("")
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag("Home")
                    .badge(1)

                Text("")
                    .tabItem {
                        Label("History", systemImage: "clock")
                    }
                    .tag("History")
                    .badge(2)
            }
            .frame(height: 60)
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    ContentView()
}
