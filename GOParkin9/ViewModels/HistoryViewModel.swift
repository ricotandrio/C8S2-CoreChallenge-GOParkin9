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
        
        parkingRecordRepository.deleteExpiredHistories(expirationDate: expirationDate)
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
        let allParkingRecords = parkingRecordRepository.getAllHistories()
        
        self.selectedParkingRecords.forEach { id in
            if let entry = allParkingRecords.first(where: { $0.id == id }) {
                deleteItem(entry)
            }
        }
        self.selectedParkingRecords.removeAll()
        self.isSelecting.toggle()
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
        withAnimation {
            parkingRecordRepository.update(
                parkingRecord: entry,
                latitude: entry.latitude,
                longitude: entry.longitude,
                isPinned: entry.isPinned ? false : true,
                isHistory: entry.isHistory,
                images: entry.images,
                floor: entry.floor,
                completedAt: entry.completedAt
            )
        }
        
        self.synchronize()
    }
    
    // This function belongs to delete button that can be accessed by swipe history
    func deleteItem(_ entry: ParkingRecord) {
        withAnimation {
            parkingRecordRepository.delete(entry)
        }
        
        self.synchronize()
    }
}
