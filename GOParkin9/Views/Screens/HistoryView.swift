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

    @State private var isReverse = false
    
    @State private var isSelecting = false
    @State private var selectedParkingRecords: Set<UUID> = []
    
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

    @Environment(\.modelContext) var context

    
    var body: some View {
        NavigationView {
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
                            deleteItem: { deleteItem(entry) },
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
                        Button {
                            isReverse.toggle()
                        } label: {
                            Text("Sort by Date")
                            Text("\(isReverse ? "Oldest First" : "Most Recent First")")
                                .font(.subheadline)
                            Image(systemName: "arrow.up.arrow.down")
                        }
                        
                        Button {
                            configureDeleteHistoryAfterInDay()
                        } label: {
                            Text("Delete Automatically")
                            Text("After \(deleteHistoryAfterInDay) Days \(deleteHistoryAfterInDay == 5 ? "(Default)" : "")")
                                .font(.subheadline)
                            Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                        }
                        
                        Button {
                            cancelSelection()
                        } label: {
                            Text(isSelecting ? "Cancel" : "Select")
                            Text(isSelecting ? "Cancel Selection" : "Select Multiple")
                                .font(.subheadline)
                            Image(systemName: isSelecting ? "checkmark.circle" : "checkmark.circle.fill")
                        }
                        
                        if isSelecting && !selectedParkingRecords.isEmpty {
                            Button {
                                deleteSelection()
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
        }
        .onAppear {
            let calendar = Calendar.current
            let expirationDate = calendar.date(byAdding: .day, value: -deleteHistoryAfterInDay, to: Date()) ?? Date()

            for entry in allParkingRecords {
                if entry.createdAt < expirationDate {
                    context.delete(entry)
                }
            }

            try? context.save()
        }
    }
    
    private func configureDeleteHistoryAfterInDay() {
        switch deleteHistoryAfterInDay {
        case 5:
            deleteHistoryAfterInDay = 7
        case 7:
            deleteHistoryAfterInDay = 14
        case 14:
            deleteHistoryAfterInDay = 30
        default:
            deleteHistoryAfterInDay = 5
        }
    }
    
    private func cancelSelection() {
        selectedParkingRecords.removeAll()
        isSelecting.toggle()
    }
    
    private func deleteSelection() {
        selectedParkingRecords.forEach { id in
            if let entry = allParkingRecords.first(where: { $0.id == id }) {
                deleteItem(entry)
            }
        }
        selectedParkingRecords.removeAll()
        isSelecting.toggle()
    }
    
    private func toggleSelection(_ entry: ParkingRecord) {
        withAnimation {
            print(entry)
            if selectedParkingRecords.contains(entry.id) {
                print("Removed")
                selectedParkingRecords.remove(entry.id)
            } else {
                print("Inserted")
                selectedParkingRecords.insert(entry.id)
            }
        }
    }

    private func pinItem(_ entry: ParkingRecord) {
        withAnimation {
            
            entry.isPinned.toggle()
            try? context.save()
        }
    }
    
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
        HStack {
            if isSelecting {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? Color.blue : Color.gray)
                    .onTapGesture {
                        toggleSelection()
                    }
            }
            
            if entry.images.isEmpty {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipped()
                    .padding(.trailing, 10)
            } else {
                Image(uiImage: entry.images[0].getImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipped()
                    .padding(.trailing, 10)
            }
           

            VStack(alignment: .leading) {
                Text(entry.createdAt, format: .dateTime.day().month().year())
                    .font(.headline)
                    .padding(.vertical, 5)

                HStack {
                    Image(systemName: "arrow.down.backward.circle")
                    Text(entry.createdAt, format: .dateTime.hour().minute())
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.forward.circle")
//                    if entry.completedAt.description.isEmpty {
//                        Text(entry.createdAt, format: .dateTime.hour().minute())
//                    } else {
                        Text(entry.completedAt, format: .dateTime.hour().minute())
//                    }
                }
            }

            if entry.isPinned {
                Image(systemName: "pin.fill")
                    .foregroundColor(.yellow)
            }
        }
        .padding(.vertical, 10)
        .onTapGesture {
            if isSelecting {
                toggleSelection()
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button {
                pinItem()
            } label: {
                if entry.isPinned {
                    Label("Unpin", systemImage: "pin.slash")
                } else {
                    Label("Pin", systemImage: "pin")
                }
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

#Preview {
    ContentView()
}
