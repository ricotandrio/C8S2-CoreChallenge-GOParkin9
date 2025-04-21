//
//  CompassViewModel.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 20/04/25.
//

import Foundation
import SwiftUI
import CoreLocation
import SwiftData

struct Location: Identifiable {
    let id: Int
    let name: String
    let label: String
    let coordinate: CLLocationCoordinate2D
}

class CompassViewModel: ObservableObject {
    private var parkingRecordRepository: ParkingRecordRepositoryProtocol
    private var speechUtteranceManager: SpeechUtteranceManager = SpeechUtteranceManager()
    
    @Published var options = [
        Location(id:1, name: "Entry Gate B1", label: "Entry Gate Basement 1", coordinate: CLLocationCoordinate2D(latitude: -6.302254, longitude: 106.652554)),
        Location(id:2, name: "Exit Gate B1", label: "Exit Gate Basement 1", coordinate: CLLocationCoordinate2D(latitude: -6.302244, longitude: 106.652582)),
        Location(id:3, name: "Charging Station", label: "Charging Station", coordinate: CLLocationCoordinate2D(latitude: -6.302097, longitude: 106.652612)),
        Location(id:4, name: "Entry Gate B2", label: "Entry Gate Basement 2", coordinate: CLLocationCoordinate2D(latitude: -6.301891, longitude: 106.652777)),
        Location(id:5, name: "Exit Gate B2", label: "Exit Gate Basement 2", coordinate: CLLocationCoordinate2D(latitude: -6.301597, longitude: 106.652761))
    ]
    
    init(parkingRecordRepository: ParkingRecordRepositoryProtocol) {
        self.parkingRecordRepository = parkingRecordRepository
    
//        updateOptions()
    }
    
//    func updateOptions() {
//        let activeParkingRecord: ParkingRecord? = parkingRecordRepository.getActiveParkingRecord()
//        
//        if let record = activeParkingRecord {
//            options.append(Location(id: 6, name: "Parking Location", label: "Parking Location", coordinate: CLLocationCoordinate2D(latitude: record.latitude, longitude: record.longitude)))
//        }
//        
//        if selectedLocation==7 {
//            options.append(Location(id: 7, name: "Parking Location History", label: "Parking Location History", coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)))
//        }
//    }
}
