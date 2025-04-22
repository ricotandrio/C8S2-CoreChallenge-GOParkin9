//
//  DetailRecordViewModel.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 22/04/25.
//

import Foundation

class DetailRecordViewModel: ObservableObject {
    @Published var selectedImageIndex = 0
    @Published var isPreviewOpen = false
    @Published var isCompassOpen: Bool = false
    
    @Published var isComplete: Bool = false
    
    @Published var activeParkingRecord: ParkingRecord?
    
    private var parkingRecordRepository: ParkingRecordRepositoryProtocol
    
    init(parkingRecordRepository: ParkingRecordRepositoryProtocol) {
        self.parkingRecordRepository = parkingRecordRepository
        
        self.activeParkingRecord = parkingRecordRepository.getActiveParkingRecord()
    }
    
    func synchronize() {
        self.activeParkingRecord = parkingRecordRepository.getActiveParkingRecord()
    }
    
    func complete() {
        if let record = self.activeParkingRecord {
            parkingRecordRepository.update(
                parkingRecord: record,
                latitude: record.latitude,
                longitude: record.longitude,
                isPinned: record.isPinned,
                isHistory: true,
                images: record.images,
                floor: record.floor,
                completedAt: Date.now
            )
        }
        
        synchronize()
    }
}
