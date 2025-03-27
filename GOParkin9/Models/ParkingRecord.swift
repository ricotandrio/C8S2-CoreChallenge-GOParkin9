//
//  ParkingRecord.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 21/03/25.
//

import Foundation
import SwiftData
import CoreLocation

@Model
class ParkingRecord: Identifiable {
    var id: UUID = UUID()
    var latitude: Double
    var longitude: Double
    var isHistory: Bool
    var isPinned: Bool
    var createdAt: Date
    
    @Relationship(deleteRule: .cascade) var images: [ParkingImage] = []
    
    init (
        latitude: Double,
        longitude: Double,
        images: [ParkingImage]
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.isHistory = false
        self.isPinned = false
        self.createdAt = Date()
        self.images = images
    }
}
