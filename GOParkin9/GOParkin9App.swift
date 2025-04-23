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

    @StateObject private var userStartVM: UserStartViewModel = UserStartViewModel()
    @StateObject private var userSettingsVM: UserSettingsViewModel = UserSettingsViewModel()
    
    static let parkingRecordRepository: ParkingRecordRepositoryProtocol = ParkingRecordRepository()
    
    init() { }
    
    var body: some Scene {
        WindowGroup {
            if userStartVM.isSplashActive {
                SplashScreenView()
                    .onAppear {
                        userStartVM.startSplashTimer()
                    }
            } else {
                
                ContentView()
                    .modelContainer(userStartVM.sharedModelContainer)
                    .fullScreenCover(isPresented: $userSettingsVM.isFirstLaunch) {
                        WelcomeScreenView()
                    }
                    .onAppear() {
                        GOParkin9App.parkingRecordRepository.setContext(userStartVM.sharedModelContainer.mainContext)
                    }
            }
        }
        .environmentObject(userSettingsVM)
    }
}
