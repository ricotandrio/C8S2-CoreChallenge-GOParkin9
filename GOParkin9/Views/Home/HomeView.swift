//
//  HomeView.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 21/03/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var userSettingsVM: UserSettingsViewModel
    @Environment(\.modelContext) var context

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    NavigationList()

                    DetailRecord(
                        detailRecordVM: DetailRecordViewModel(
                            parkingRecordRepository: ParkingRecordRepository(context: context)
                        )
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
