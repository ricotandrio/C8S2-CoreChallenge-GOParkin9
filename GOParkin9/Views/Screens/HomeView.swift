//
//  HomeView.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 21/03/25.
//

import SwiftUI

struct HomeView: View {
    @State private var isCompassOpen: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    NavigationList(
                        isCompassOpen: $isCompassOpen
                    )
                    
                    DetailRecord(
                        isCompassOpen: $isCompassOpen
                    )
                }
                .navigationTitle("GOParkin9")
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
