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
    
    init() {
        self.synchronize()
    }
    
    func synchronize() {
        switch GOParkin9App.parkingRecordRepository.getActiveParkingRecord() {
        case .success(let record):
            self.activeParkingRecord = record
        case .failure(let error):
            print("Error fetching active parking record: \(error)")
        }
    }
    
    func complete() {
        guard let record = activeParkingRecord else { return }
        
        switch GOParkin9App.parkingRecordRepository.update(
            parkingRecord: record,
            latitude: record.latitude,
            longitude: record.longitude,
            isPinned: record.isPinned,
            isHistory: true,
            images: record.images,
            floor: record.floor,
            completedAt: Date.now
        ) {
        case .success(let updatedEntry):
            
            print("Parking record updated successfully: \(updatedEntry)")
        case .failure(let error):
            
            print("Error updating parking record: \(error)")
        }
        
        self.synchronize()
    }
}
