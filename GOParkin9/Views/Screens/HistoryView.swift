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

    @AppStorage("deleteHistoryAfterInDay") var deleteHistoryAfterInDay: Int = 5

    @Environment(\.modelContext) var context

    // This variable belongs to sort the history feature
    @State private var isReverse: Bool = false
    
    // This variable belongs to the select to delete feature
    @State private var isSelecting: Bool = false
    @State private var selectedParkingRecords: Set<UUID> = []
    
    // This variable belongs to navigate to ConfigAutomaticDelete
    @State private var navigateToConfigAutomaticDelete: Bool = false
    
    // This variable belongs to alert
    @State private var showAlertHistoryEmpty: Bool = false
    @State private var showAlertDeleteSelection: Bool = false
    @State private var showAlertDeleteSingle: Bool = false
    @State private var selectedHistoryToBeDeleted: ParkingRecord?
    
    // This variable used to fetch all history data
    @Query(
        filter: #Predicate<ParkingRecord> { p in p.isHistory == true },
        sort: [SortDescriptor(\.createdAt)]
    ) var allParkingRecords: [ParkingRecord]
    
    var sortedParkingRecords: [ParkingRecord] {
        allParkingRecords.sorted {
            isReverse ? $0.createdAt < $1.createdAt : $0.createdAt > $1.createdAt
        }
    }
    
    var unpinnedParkingRecords: [ParkingRecord] {
        sortedParkingRecords.filter { !$0.isPinned }
    }

    var pinnedParkingRecords: [ParkingRecord] {
        sortedParkingRecords.filter { $0.isPinned }
    }
    
    var body: some View {
        NavigationStack {
            List {

                if allParkingRecords.isEmpty {
                    Text("No history yet")
                        .foregroundColor(.secondary)
                }
                
                if !pinnedParkingRecords.isEmpty {
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
                    
                    ForEach(pinnedParkingRecords) { entry in
                        HistoryComponent(
                            entry: entry,
                            pinItem: { pinItem(entry) },
                            deleteItem: { deleteItem(entry) },
                            isSelecting: isSelecting,
                            isSelected: selectedParkingRecords.contains(entry.id),
                            toggleSelection: { toggleSelection(entry) }
                        )
                    }
                }
                
                if !unpinnedParkingRecords.isEmpty {
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
                    
                    ForEach(unpinnedParkingRecords, id: \.id) { entry in
                        HistoryComponent(
                            entry: entry,
                            pinItem: { pinItem(entry) },
                            deleteItem: {
                                selectedHistoryToBeDeleted = entry
                                showAlertDeleteSingle.toggle()
                            },
                            isSelecting: isSelecting,
                            isSelected: selectedParkingRecords.contains(entry.id),
                            toggleSelection: { toggleSelection(entry) }
                        )
                    }

                }
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                 //error disini blum keubah
                        Button(action: {}) {
                            HStack{
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                VStack(alignment: .center) {
                                    Text("Sort by Date")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Text("Default (The Newest)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "arrow.up.arrow.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemGray6)) // Light background
                            .cornerRadius(10)
                        }
                        
                        Button {
                            navigateToConfigAutomaticDelete.toggle()
                        } label: {
                            Text("Delete Automatically")
                            Text("History will be deleted after \(deleteHistoryAfterInDay) days")
                                .font(.subheadline)
                            Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                        }
                        
                        // Button for cancel the selection
                        Button {
                            if !allParkingRecords.isEmpty {
                                cancelSelection()
                            } else {
                                showAlertHistoryEmpty.toggle()
                            }
                        } label: {
                            Text(isSelecting ? "Cancel" : "Select")
                            Text(isSelecting ? "Cancel Selection" : "Select Multiple")
                                .font(.subheadline)
                            Image(systemName: isSelecting ? "checkmark.circle" : "checkmark.circle.fill")
                        }
                        
                        // Button for delete the selected history only if the selection is active
                        if isSelecting && !selectedParkingRecords.isEmpty {
                            Button {
                                showAlertDeleteSelection.toggle()
                            } label: {
                                Text("Delete Selected")
                                Text("\(selectedParkingRecords.count) selected")
                                    .font(.subheadline)
                                Image(systemName: "trash")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToConfigAutomaticDelete) {
                ConfigAutomaticDeleteView()
            }
        }
        .onAppear {
            // This responsible for delete the history after certain days
            let calendar = Calendar.current
            let expirationDate = calendar.date(byAdding: .day, value: -deleteHistoryAfterInDay, to: Date()) ?? Date()


            for entry in allParkingRecords {
                if entry.createdAt < expirationDate && !entry.isPinned {
                    context.delete(entry)
                }
            }

            try? context.save()
        }
        .alertComponent(
            isPresented: $showAlertHistoryEmpty,
            title: "There's no history yet",
            message: "Please complete a parking first.",
            confirmButtonText: "OK"
        )
        .alertComponent(
            isPresented: $showAlertDeleteSelection,
            title: "Delete All Selected Records?",
            message: "This action cannot be undone.",
            confirmAction: deleteSelection,
            confirmButtonText: "Delete"
        )
        .alertComponent(
            isPresented: $showAlertDeleteSingle,
            title: "Delete This Record?",
            message: "This action cannot be undone.",
            confirmAction: {
                if let entry = selectedHistoryToBeDeleted {
                    deleteItem(entry)
                }
            },
            confirmButtonText: "Delete"
        )
    }
    
    // This function belongs to button for cancel the selection
    private func cancelSelection() {
        selectedParkingRecords.removeAll()
        isSelecting.toggle()
    }
    
    // This function belongs to button for delete the selected history only if the selection is active
    private func deleteSelection() {
        selectedParkingRecords.forEach { id in
            if let entry = allParkingRecords.first(where: { $0.id == id }) {
                deleteItem(entry)
            }
        }
        selectedParkingRecords.removeAll()
        isSelecting.toggle()
    }
    
    // This function belongs to button for check the selected history
    private func toggleSelection(_ entry: ParkingRecord) {
        withAnimation {
            if selectedParkingRecords.contains(entry.id) {
                selectedParkingRecords.remove(entry.id)
            } else {
                selectedParkingRecords.insert(entry.id)
            }
        }
    }

    // This function belongs to pin button that can be accessed by swipe history
    private func pinItem(_ entry: ParkingRecord) {
        withAnimation {
            entry.isPinned.toggle()
            try? context.save()
        }
    }
    
    // This function belongs to delete button that can be accessed by swipe history
    private func deleteItem(_ entry: ParkingRecord) {
        withAnimation {
            context.delete(entry)
            try? context.save()
        }

    }
}

struct HistoryComponent: View {
    let entry: ParkingRecord
    let pinItem: () -> Void
    let deleteItem: () -> Void
    
    let isSelecting: Bool
    let isSelected: Bool
    let toggleSelection: () -> Void
    
    var body: some View {
        //NavigationStack{
            List{
                ForEach(historyData) { entry in
                    HStack {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 60, height: 50)
                            .padding(.trailing, 10)
                        
                        VStack(alignment: .leading) {
                            Text(entry.date)
                                .font(.headline)
                                .padding(.vertical, 5)
                            
                            HStack {
                                Image(systemName: "arrow.down.backward.circle")
                                Text(entry.clockIn)
                                
                                Spacer()
                                
                                Image(systemName: "arrow.up.forward.circle")
                                Text(entry.clockOut)
                            }
                            
                        }
                        
                        if entry.isPinned {
                            Image(systemName: "pin.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                    .padding(.vertical, 10)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            pinItem()
                        } label: {
                            Label("Pin", systemImage: "pin")
                        }
                        .tint(.yellow)
                        
                        Button(role: .destructive) {
                            deleteItem()
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                    }
                }
            }
//        }
    }
}

#Preview {
    ContentView()
}
