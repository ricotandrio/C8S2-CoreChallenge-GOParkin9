//
//  UserSettingsProtocol.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 20/04/25.
//

import Foundation

protocol UserSettingsProtocol {
    func getDaysBeforeAutomaticDelete() -> Int
    func setDaysBeforeAutomaticDelete(to days: Int)
    
    func getIsFirstLaunch() -> Bool
    func markAppAsLaunched()
}
