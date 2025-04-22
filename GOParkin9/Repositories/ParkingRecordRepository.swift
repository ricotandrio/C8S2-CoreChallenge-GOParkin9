//
//  ParkingRecordRepository.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 20/04/25.
//

import Foundation
import SwiftUI
import SwiftData

class ParkingRecordRepository: ParkingRecordRepositoryProtocol {
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func create(
        latitude: Double,
        longitude: Double,
        isHistory: Bool,
        floor: String,
        images: [ParkingImage]
    ) -> ParkingRecord {
        let parkingRecord = ParkingRecord(
            latitude: latitude,
            longitude: longitude,
            images: images,
            floor: floor
        )
        
        do {
            context.insert(parkingRecord)
            try context.save()
        } catch {
            print("Error creating parking record: \(error)")
        }
        
        return parkingRecord
    }
    
    func update(
        parkingRecord: ParkingRecord,
        latitude: Double,
        longitude: Double,
        isPinned: Bool,
        isHistory: Bool,
        images: [ParkingImage],
        floor: String,
        completedAt: Date
    ) {
        do {
            parkingRecord.latitude = latitude
            parkingRecord.longitude = longitude
            parkingRecord.isPinned = isPinned
            parkingRecord.isHistory = isHistory
            parkingRecord.images = images
            parkingRecord.floor = floor
            parkingRecord.completedAt = completedAt
            
            try context.save()
        } catch {
            print("Error updating parking record: \(error)")
        }
    }
    
    func delete(_ parkingRecord: ParkingRecord) {
        do {
            context.delete(parkingRecord)
            try context.save()
        } catch {
            print("Error deleting parking record: \(error)")
        }
    }
        
    
    func getActiveParkingRecord() -> ParkingRecord? {
        let fetchDescriptor = FetchDescriptor<ParkingRecord>(
            predicate: #Predicate<ParkingRecord> { p in
                p.isHistory == false
            }
        )
        
        do {
            let parkingRecords = try context.fetch(fetchDescriptor)
            
            return parkingRecords.isEmpty ? nil : parkingRecords.first
        } catch {
            print("Error fetching parking records: \(error)")
            return nil
        }
    }
    
    func getAllHistories() -> [ParkingRecord] {
        let fetchDescriptor = FetchDescriptor<ParkingRecord>(
            predicate: #Predicate<ParkingRecord> { p in
                p.isHistory == true
            }
        )
        
        do {
            let parkingRecords = try context.fetch(fetchDescriptor)
            
            return parkingRecords
        } catch {
            print("Error fetching parking records: \(error)")
            return []
        }
    }
    
    func deleteExpiredHistories(expirationDate: Date) {
        for entry in self.getAllHistories() {
            if entry.createdAt < expirationDate && !entry.isPinned {
                context.delete(entry)
            }
        }

        try? context.save()
        
    }
}
