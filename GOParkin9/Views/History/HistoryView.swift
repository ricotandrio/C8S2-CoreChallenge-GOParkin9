//
//  HistoryView.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 23/03/25.
//  Edited by Chikmah on 26/03/25.
//

import SwiftUI
import SwiftData


struct HistoryView: View {
    @ObservedObject private var historyVM: HistoryViewModel
    
    @EnvironmentObject private var userSettingsVM: UserSettingsViewModel

    init(historyVM: HistoryViewModel) {
        self.historyVM = historyVM
    }
    
    var body: some View {
        NavigationStack {
            List {

                if historyVM.histories.isEmpty {
                    Text("No history yet")
                        .foregroundColor(.secondary)
                }
                
                Group {
                    if !historyVM.getAllPinnedHistories().isEmpty {
                        HStack {
                            Image(systemName: "pin")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .padding(.trailing, 10)
                            
                            
                            Text("Pinned")
                                .font(.headline)
                                .fontWeight(.bold)
                                .opacity(0.6)
                        }
                        
                        ForEach(historyVM.getAllPinnedHistories()) { entry in
                            HistoryCard(
                                entry: entry,
                                pinItem: { historyVM.pinItem(entry) },
                                deleteItem: {
                                    historyVM.selectedHistoryToBeDeleted = entry
                                    historyVM.showAlertDeleteSingle.toggle()
                                },
                                isSelecting: historyVM.isSelecting,
                                isSelected: historyVM.selectedParkingRecords.contains(entry.id),
                                toggleSelection: { historyVM.toggleSelection(entry) }
                            )
                        }
                    }
                }
                
                Group {
                    if !historyVM.getAllUnpinnedHistories().isEmpty {
                        HStack {
                            Image(systemName: "clock.arrow.circlepath")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .padding(.trailing, 10)
                            
                            
                            Text("All History")
                                .font(.headline)
                                .fontWeight(.bold)
                                .opacity(0.6)
                        }
                        
                        ForEach(historyVM.getAllUnpinnedHistories(), id: \.id) { entry in
                            HistoryCard(
                                entry: entry,
                                pinItem: { historyVM.pinItem(entry) },
                                deleteItem: {
                                    historyVM.selectedHistoryToBeDeleted = entry
                                    historyVM.showAlertDeleteSingle.toggle()
                                },
                                isSelecting: historyVM.isSelecting,
                                isSelected: historyVM.selectedParkingRecords.contains(entry.id),
                                toggleSelection: { historyVM.toggleSelection(entry) }
                            )
                        }
                        
                    }
                }
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {

                        // Button for sort the history by date
                        Button {
                            historyVM.isDescending.toggle()
                        } label: {
                            Text("Sort by Date")
                            Text("\(historyVM.isDescending ? "Most Recent First" : "Oldest First")")
                                .font(.subheadline)
                            Image(systemName: "arrow.up.arrow.down")
                        }
                        
                        Button {
                            historyVM.navigateToConfigAutomaticDelete.toggle()
                        } label: {
                            Text("Delete Automatically")
                            Text("History will be deleted after \(userSettingsVM.daysBeforeAutomaticDelete) days")
                                .font(.subheadline)
                            Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                        }
                        
                        // Button for cancel the selection
                        Button {
                            if !historyVM.histories.isEmpty {
                                historyVM.cancelSelection()
                            } else {
                                historyVM.showAlertHistoryEmpty.toggle()
                            }
                        } label: {
                            Text(historyVM.isSelecting ? "Cancel" : "Select")
                            Text(historyVM.isSelecting ? "Cancel Selection" : "Select Multiple")
                                .font(.subheadline)
                            Image(systemName: historyVM.isSelecting ? "checkmark.circle" : "checkmark.circle.fill")
                        }
                        
                        // Button for delete the selected history only if the selection is active
                        if historyVM.isSelecting && !historyVM.selectedParkingRecords.isEmpty {
                            Button {
                                historyVM.showAlertDeleteSelection.toggle()
                            } label: {
                                Text("Delete Selected")
                                Text("\(historyVM.selectedParkingRecords.count) selected")
                                    .font(.subheadline)
                                Image(systemName: "trash")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .navigationDestination(isPresented: $historyVM.navigateToConfigAutomaticDelete) {
                ConfigAutomaticDeleteView()
            }
        }
        .onAppear {
            // This responsible for delete the history after certain days
            historyVM.automaticDeleteHistoryAfter(
                userSettingsVM.daysBeforeAutomaticDelete
            )
            
            // This responsible for synchronize the history
            historyVM.synchronize()
        }
        .alertComponent(
            isPresented: $historyVM.showAlertHistoryEmpty,
            title: "There's no history yet",
            message: "Please complete a parking first.",
            confirmButtonText: "OK"
        )
        .alertComponent(
            isPresented: $historyVM.showAlertDeleteSelection,
            title: "Delete All Selected Records?",
            message: "This action cannot be undone.",
            confirmAction: historyVM.deleteSelection,
            confirmButtonText: "Delete",
            confirmButtonRole: .destructive
        )
        .alertComponent(
            isPresented: $historyVM.showAlertDeleteSingle,
            title: "Delete This Record?",
            message: "This action cannot be undone.",
            confirmAction: {
                if let entry = historyVM.selectedHistoryToBeDeleted {
                    historyVM.deleteItem(entry)
                }
            },
            confirmButtonText: "Delete",
            confirmButtonRole: .destructive
        )
    }
}

#Preview {
    ContentView()
}
