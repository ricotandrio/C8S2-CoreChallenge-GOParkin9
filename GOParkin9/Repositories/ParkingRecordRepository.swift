//
//  ParkingRecordRepository.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 20/04/25.
//

import Foundation
import SwiftUI
import SwiftData

final class ParkingRecordRepository: ParkingRecordRepositoryProtocol {
    static let shared = ParkingRecordRepository()
    
    var context: ModelContext?
    
    init() { }
    
    func setContext(_ context: ModelContext) {
        self.context = context
    }
    
    func create(
        latitude: Double,
        longitude: Double,
        isHistory: Bool,
        floor: String,
        images: [ParkingImage]
    ) -> Result<ParkingRecord, RepositoryError> {
        guard let context = context else { return .failure(.contextNotFound) }
        
        let parkingRecord = ParkingRecord(
            latitude: latitude,
            longitude: longitude,
            images: images,
            floor: floor
        )
        
        do {
            context.insert(parkingRecord)
            try context.save()
            
            return .success(parkingRecord)
        } catch {
            
            print("Error creating parking record: \(error)")
            return .failure(.createFailed)
        }
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
    ) -> Result<ParkingRecord, RepositoryError> {
        guard let context = context else { return .failure(.contextNotFound) }
        
        do {
            parkingRecord.latitude = latitude
            parkingRecord.longitude = longitude
            parkingRecord.isPinned = isPinned
            parkingRecord.isHistory = isHistory
            parkingRecord.images = images
            parkingRecord.floor = floor
            parkingRecord.completedAt = completedAt
            
            try context.save()
            return .success(parkingRecord)
        } catch {
            
            print("Error updating parking record: \(error)")
            return .failure(.updateFailed)
        }
    }
    
    func delete(_ parkingRecord: ParkingRecord) -> Result<Void, RepositoryError> {
        guard let context = context else { return .failure(.contextNotFound) }
        
        do {
            context.delete(parkingRecord)
            try context.save()
            
            return .success(())
        } catch {
            
            print("Error deleting parking record: \(error)")
            return .failure(.deleteFailed)
        }
    }
        
    
    func getActiveParkingRecord() -> Result<ParkingRecord?, RepositoryError> {
        guard let context = context else { return .failure(.contextNotFound) }
        
        let fetchDescriptor = FetchDescriptor<ParkingRecord>(
            predicate: #Predicate<ParkingRecord> { p in
                p.isHistory == false
            }
        )
        
        if fetchDescriptor.predicate == nil {
            return .failure(.invalidData)
        }
        
        do {
            let parkingRecords = try context.fetch(fetchDescriptor)
            
            if parkingRecords.isEmpty {
                return .success(nil)
            }
            
            return .success(parkingRecords.first)
        } catch {
            print("Error query parking records: \(error)")
            return .failure(.queryFailed)
        }
    }
    
    
    func getAllHistories() -> Result<[ParkingRecord], RepositoryError> {
        guard let context = context else { return .failure(.contextNotFound) }
        
        let fetchDescriptor = FetchDescriptor<ParkingRecord>(
            predicate: #Predicate<ParkingRecord> { p in
                p.isHistory == true
            }
        )
        do {
    
            let parkRecord = try context.fetch(fetchDescriptor)
            
            return .success(parkRecord)
        } catch {
            print("Error fetching parking records: \(error)")
            return .failure(.queryFailed)
        }
//        do {
//            let parkingRecords = try context.fetch(fetchDescriptor)
//            
//            return .success(parkingRecords)
//        } catch {
//            print("Error fetching parking records: \(error)")
//            return .failure(.queryFailed)
//        }
    }
    
    func deleteExpiredHistories(expirationDate: Date) -> Result<Void, RepositoryError> {
        guard let context = context else { return .failure(.contextNotFound) }
        
        var allHistories: [ParkingRecord] = []
        
        switch self.getAllHistories() {
            case .success(let histories):
                allHistories = histories
            case .failure(let error):
                print("Error fetching all histories: \(error)")
                return .failure(.queryFailed) 
        }
        
        for entry in allHistories {
            if entry.createdAt < expirationDate && !entry.isPinned {
                do {
                    context.delete(entry)
                    try context.save()
                } catch {
                    print("Error deleting expired history: \(error)")
                    return .failure(.deleteFailed)
                }
            }
        }
        
        return .success(())
    }
}
