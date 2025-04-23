//
//  UserStartViewModel.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 20/04/25.
//

import SwiftUI
import SwiftData

class UserStartViewModel: ObservableObject {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    @Published var isSplashActive = true
    
    var sharedModelContainer: ModelContainer
    
    init() {
        // Initialize the shared ModelContainer
        self.sharedModelContainer = {
            let schema = Schema([ParkingRecord.self]) // Register your model
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            return try! ModelContainer(for: schema, configurations: [config])
        }()
    }
    
    func startSplashTimer() {
        Task {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            withAnimation {
                self.isSplashActive = false
            }
        }
    }
}
