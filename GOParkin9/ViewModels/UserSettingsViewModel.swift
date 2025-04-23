//
//  AppStorageViewModel.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 16/04/25.
//

import Foundation

class UserSettingsViewModel: ObservableObject {
    private var manager: UserSettingsProtocol
    
    @Published var daysBeforeAutomaticDelete: Int = 5 {
        didSet {
            manager.setDaysBeforeAutomaticDelete(to: daysBeforeAutomaticDelete)
        }
    }
    
    @Published var isFirstLaunch: Bool = true {
        didSet {
            manager.markAppAsLaunched()
        }
    }
    
    init(manager: UserSettingsProtocol = UserSettingsManager()) {
        self.manager = manager
        
        loadManager()
    }
    
    func loadManager() {
        self.daysBeforeAutomaticDelete = manager.getDaysBeforeAutomaticDelete()
        self.isFirstLaunch = manager.getIsFirstLaunch()
    }
    
    func markAppAsLaunched() {
        self.isFirstLaunch = false
    }
    
    func setDaysBeforeAutomaticDelete(to days: Int) {
        self.daysBeforeAutomaticDelete = days
    }
}


