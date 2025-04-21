//
//  UserSettingsManager.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 16/04/25.
//

import Foundation
import SwiftUI

class UserSettingsManager: UserSettingsProtocol {
    @AppStorage(Keys.daysBeforeAutomaticDelete.id) private var daysBeforeAutomaticDelete: Int = 5
    @AppStorage(Keys.isFirstLaunch.id) private var isFirstLaunch: Bool = true

    enum Keys {
        case daysBeforeAutomaticDelete
        case isFirstLaunch
        
        var id: String {
            "\(self)"
        }
        
    }
    
    func getDaysBeforeAutomaticDelete() -> Int {
        return daysBeforeAutomaticDelete
    }
    
    func setDaysBeforeAutomaticDelete(to days: Int) {
        daysBeforeAutomaticDelete = days
    }
    
    func getIsFirstLaunch() -> Bool {
        return isFirstLaunch
    }
    
    func markAppAsLaunched() {
        isFirstLaunch = false
    }
}
