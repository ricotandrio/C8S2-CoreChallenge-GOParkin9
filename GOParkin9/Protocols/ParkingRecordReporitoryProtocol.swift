//
//  ParkingRecordReporitoryProtocol.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 20/04/25.
//

import Foundation

protocol ParkingRecordRepositoryProtocol {
    
    func setContext(_ context: ModelContext)
    
    func create(
        latitude: Double,
        longitude: Double,
        isHistory: Bool,
        floor: String,
        images: [ParkingImage]
    ) -> Result<ParkingRecord, RepositoryError>
    
    func update(
        parkingRecord: ParkingRecord,
        latitude: Double,
        longitude: Double,
        isPinned: Bool,
        isHistory: Bool,
        images: [ParkingImage],
        floor: String,
        completedAt: Date
    ) -> Result<ParkingRecord, RepositoryError>
    
    func delete(_ parkingRecord: ParkingRecord) -> Result<Void, RepositoryError>
    
    func getActiveParkingRecord() -> Result<ParkingRecord?, RepositoryError>
    
    func getAllHistories() -> Result<[ParkingRecord], RepositoryError>
    
    func deleteExpiredHistories(expirationDate: Date) -> Result<Void, RepositoryError>
}
