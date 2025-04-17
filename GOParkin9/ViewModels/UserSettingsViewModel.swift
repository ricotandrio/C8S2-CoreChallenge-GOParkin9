//
//  AppStorageViewModel.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 16/04/25.
//

import Foundation
import SwiftUI

class UserSettingsViewModel: ObservableObject {
    @AppStorage(Keys.daysBeforeAutomaticDelete.id) var daysBeforeAutomaticDelete: Int = 5
    @AppStorage(Keys.isFirstLaunch.id) var isFirstLaunch: Bool = true

    enum Keys {
        case daysBeforeAutomaticDelete
        case isFirstLaunch
        
        var id: String {
            "\(self)"
        }
    }
    
    func setDaysBeforeAutomaticDelete(to days: Int) {
        daysBeforeAutomaticDelete = days
    }
    
    func alreadyLaunched() {
        isFirstLaunch = false
    }
}
