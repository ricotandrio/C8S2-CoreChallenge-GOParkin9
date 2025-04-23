//
//  HistoryViewModel.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 20/04/25.
//

import Foundation
import SwiftUI
import CoreLocation
import SwiftData

class HistoryViewModel: ObservableObject {
    // This variable belongs to sort the history feature
    @Published var isDescending: Bool = true
    
    // This variable belongs to the select to delete feature
    @Published var isSelecting: Bool = false
    @Published var selectedParkingRecords: Set<UUID> = []
    
    // This variable belongs to navigate to ConfigAutomaticDelete
    @Published var navigateToConfigAutomaticDelete: Bool = false
    
    // This variable belongs to alert
    @Published var showAlertHistoryEmpty: Bool = false
    @Published var showAlertDeleteSelection: Bool = false
    @Published var showAlertDeleteSingle: Bool = false
    @Published var selectedHistoryToBeDeleted: ParkingRecord?
    
    // This variable used to fetch all history data
    @Published var histories: [ParkingRecord] = []
    
    @Published var errorMessage: String?
    
    init() {
        self.synchronize()
    }
    
    func synchronize() {
        // Call the getAllHistories method from the singleton repository
        switch GOParkin9App.parkingRecordRepository.getAllHistories() {
        case .success(let parkingRecords):
            // Successfully fetched parking records, update the histories
            self.histories = parkingRecords
        case .failure(let error):
            // Handle failure case and show an error message
            self.errorMessage = "Error fetching parking records: \(error)"
        }
    }
    
    func getAllPinnedHistories() -> [ParkingRecord] {
        return self.histories
            .filter({ $0.isPinned })
            .sorted(by: { isDescending ? $0.createdAt > $1.createdAt : $0.createdAt < $1.createdAt })
    }
    
    func getAllUnpinnedHistories() -> [ParkingRecord] {
        return self.histories
            .filter({ !$0.isPinned })
            .sorted(by: { isDescending ? $0.createdAt > $1.createdAt : $0.createdAt < $1.createdAt })
    }
    
    func automaticDeleteHistoryAfter(_ daysBeforeAutomaticDelete: Int) {
        let expirationDate = Calendar.current.date(byAdding: .day, value: -daysBeforeAutomaticDelete, to: Date()) ?? Date()
        
        switch GOParkin9App.parkingRecordRepository.deleteExpiredHistories(expirationDate: expirationDate) {
        case .success():
            // Successfully deleted expired histories
            print("Expired histories deleted successfully.")
        case .failure(let error):
            // Handle failure case and show an error message
            print("Error deleting expired histories: \(error)")
        }
        
        self.synchronize()
    }

    // This function belongs to button for cancel the selection
    func cancelSelection() {
        self.selectedParkingRecords.removeAll()
        self.isSelecting.toggle()
    }
    
    // This function belongs to button for delete the selected history only if the selection is active
    func deleteSelection() {
        let result = GOParkin9App.parkingRecordRepository.getAllHistories()
        
        switch result {
        case .success(let parkingRecords):
            for id in selectedParkingRecords {
                if let entry = parkingRecords.first(where: { $0.id == id }) {
                    _ = GOParkin9App.parkingRecordRepository.delete(entry)
                }
            }
            selectedParkingRecords.removeAll()
            isSelecting.toggle()
            
        case .failure(let error):
            print("Error fetching parking records: \(error)")
        }
    }
    
    // This function belongs to button for check the selected history
    func toggleSelection(_ entry: ParkingRecord) {
        withAnimation {
            if self.selectedParkingRecords.contains(entry.id) {
                self.selectedParkingRecords.remove(entry.id)
            } else {
                self.selectedParkingRecords.insert(entry.id)
            }
        }
    }

    // This function belongs to pin button that can be accessed by swipe history
    func pinItem(_ entry: ParkingRecord) {
        
        switch GOParkin9App.parkingRecordRepository.update(
            parkingRecord: entry,
            latitude: entry.latitude,
            longitude: entry.longitude,
            isPinned: entry.isPinned ? false : true,
            isHistory: entry.isHistory,
            images: entry.images,
            floor: entry.floor,
            completedAt: entry.completedAt
        ) {
        case .success(let updatedEntry):
            
            print("Parking record updated successfully: \(updatedEntry)")
        case .failure(let error):
            
            print("Error updating parking record: \(error)")
        }
        
        self.synchronize()
    }
    
    // This function belongs to delete button that can be accessed by swipe history
    func deleteItem(_ entry: ParkingRecord) {
        switch GOParkin9App.parkingRecordRepository.delete(entry) {
        case .success():
            print("Parking record deleted successfully.")
        case .failure(let error):
            print("Error deleting parking record: \(error)")
        }
        
        self.synchronize()
    }
}
