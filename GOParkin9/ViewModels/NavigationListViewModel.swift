//
//  NavigationListViewModel.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 22/04/25.
//

import Foundation

struct NavigationButton: Identifiable {
    let id: Int
    let name: String
    let icon: String
}

class NavigationListViewModel: ObservableObject {
    @Published var isCompassOpen: Bool = false
    @Published var showCompassView: Bool = false
    @Published var selectedNavigation:Int = 0
    
    let navigations: [NavigationButton] = [
        NavigationButton(id:1, name: "Entry Gate Basement 1", icon: "pedestrian.gate.open"),
        NavigationButton(id:2, name: "Exit Gate Basement 1", icon: "pedestrian.gate.closed"),
        NavigationButton(id:3, name: "Charging Station", icon: "bolt.car"),
        NavigationButton(id:4, name: "Entry Gate Basement 2", icon: "pedestrian.gate.open"),
        NavigationButton(id:5, name: "Exit Gate Basement 2", icon: "pedestrian.gate.closed"),
    ]
    
    init() { }
    
    func setSelectedNavigation(to id: Int) {
        self.selectedNavigation = id
    }
}
