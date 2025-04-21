//
//  ContentView.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 20/03/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var context

    var body: some View {
        VStack {
            TabView {
                HomeView()
                   .tabItem {
                       Label("Menu", systemImage: "house")
                   }

                HistoryView(
                    historyVM: HistoryViewModel(
                        parkingRecordRepository: ParkingRecordRepository(context: context)
                    )
                )
                   .tabItem {
                       Label("History", systemImage: "clock")
                   }
            }
        }
        .ignoresSafeArea(.keyboard)
        .environment(\.sizeCategory, .large)
    }
}

#Preview {
    ContentView()
}
