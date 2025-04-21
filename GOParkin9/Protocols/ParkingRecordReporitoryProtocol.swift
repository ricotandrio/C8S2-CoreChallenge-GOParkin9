//
//  ParkingRecordReporitoryProtocol.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 20/04/25.
//

import Foundation

protocol ParkingRecordRepositoryProtocol {
    func create(
        latitude: Double,
        longitude: Double,
        isHistory: Bool,
        floor: String,
        images: [ParkingImage]
    ) -> ParkingRecord
    func update(
        parkingRecord: ParkingRecord,
        latitude: Double,
        longitude: Double,
        isPinned: Bool,
        isHistory: Bool,
        images: [ParkingImage],
        floor: String
    )
    func delete(_ parkingRecord: ParkingRecord)
    func getActiveParkingRecord() -> ParkingRecord?
    func getAllHistories() -> [ParkingRecord]
    func getAllPinnedHistories() -> [ParkingRecord]
    func getAllUnpinnedHistories() -> [ParkingRecord]
    func deleteExpiredHistories(expirationDate: Date) 
}
