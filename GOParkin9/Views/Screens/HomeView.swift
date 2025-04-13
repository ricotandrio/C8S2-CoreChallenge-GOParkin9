//
//  HomeView.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 21/03/25.
//

import SwiftUI

struct HomeView: View {
    @State private var showAlert = true
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    NavigationList()

                    DetailRecord()

                }
                .navigationTitle("GOParkin9")
                .padding()
            }
        }
        .alertComponent(
            isPresented: $showAlert,
            title: "Thanks for trying GOParkin9!",
            message: "Due to Core Location accuracy limits, the navigation feature will detect you as \"arrived\" when your device is within 5 meters of your parked vehicle.",
            hideCancelButton: true,
            confirmButtonText: "Got it"
        )
            
    }
}

#Preview {
    ContentView()
}
