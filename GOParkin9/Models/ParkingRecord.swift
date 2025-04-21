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
    var completedAt: Date
    var floor: String
    
    @Relationship(deleteRule: .cascade) var images: [ParkingImage] = []
    
    init (
        latitude: Double,
        longitude: Double,
        images: [ParkingImage],
        floor: String
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.isHistory = false
        self.isPinned = false
        self.createdAt = Date()
        self.completedAt = Date()
        self.images = images
        self.floor = floor
    }
}
