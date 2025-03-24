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
            TabView(selection: $selectedTab) {
                HomeView()
                   .tabItem {
                       Label("Menu", systemImage: "house")
                   }

                HistoryView()
                   .tabItem {
                       Label("History", systemImage: "clock")
                   }
                   .badge(2)
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    ContentView()
}
