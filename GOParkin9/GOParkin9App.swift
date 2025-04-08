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

    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    @State private var isSplashActive = true
    @AppStorage("openWelcomeView") var openWelcomeView: Bool = true

    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([ParkingRecord.self]) // Register your model
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try! ModelContainer(for: schema, configurations: [config])
    }()
    
    var body: some Scene {
        WindowGroup {
            if isSplashActive {
                SplashScreenView()
                    .onAppear {
                        // Hide splash screen after 3 seconds (adjust as needed)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            withAnimation {
                                isSplashActive = false
                            }
                        }
                    }
            } else {
//                if hasSeenWelcome {
//                    ContentView()
//                } else{
//                    ContentView()
//                        .modelContainer(sharedModelContainer)
//                }
                ContentView()
                    .modelContainer(sharedModelContainer)
                    .fullScreenCover(isPresented: $openWelcomeView) {

                        WelcomeScreenView()
                    }
            }
            //        .modelContainer(for: [ParkingRecord.self])
        }
    }
}
