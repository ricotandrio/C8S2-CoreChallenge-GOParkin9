//
//  HomeView.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 21/03/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    NavigationList()
                    
                    DetailRecord()
                }
                .navigationTitle("GOParkin9")
                .padding()
            }
        }
    }
}

#Preview {
    HomeView()
}
