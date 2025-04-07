//
//  GOParkin9App.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 20/03/25.
//

import SwiftUI
import SwiftData

@main
struct GOParkin9App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([ParkingRecord.self]) // Register your model
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try! ModelContainer(for: schema, configurations: [config])
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
        }
//        .modelContainer(for: [ParkingRecord.self])
    }
}


//@main
//struct GOParkin9App: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([ParkingRecord.self]) // Register your model
//        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//        return try! ModelContainer(for: schema, configurations: [config])
//    }()
//
//    var body: some Scene {
//        WindowGroup {
//            DetailRecord()
//                .modelContainer(sharedModelContainer) // Attach model container
//        }
//    }
//}
