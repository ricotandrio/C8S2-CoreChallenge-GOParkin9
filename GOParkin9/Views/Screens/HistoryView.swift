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
    
    @Query(
        filter: #Predicate<ParkingRecord> { p in p.isHistory == true },
        sort: [SortDescriptor(\.createdAt, order: .reverse)]
    ) var allParkingRecords: [ParkingRecord]

    var unpinnedParkingRecords: [ParkingRecord] {
        allParkingRecords.filter { !$0.isPinned }
    }

    var pinnedParkingRecords: [ParkingRecord] {
        allParkingRecords.filter { $0.isPinned }
    }

    @Environment(\.modelContext) var context

    
    var body: some View {
        NavigationView {
            List {
                
                HStack {
                    Image(systemName: "pin")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 10)
                    
                    
                    Text("Pinned")
                        .font(.title3)
                        .fontWeight(.bold)
                        .opacity(0.6)
                }
                
                if pinnedParkingRecords.isEmpty {
                    Text("No pinned item")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(pinnedParkingRecords) { entry in
                        HistoryComponent(entry: entry, pinItem: { pinItem(entry) }, deleteItem: { deleteItem(entry) })
                    }
                }
                
                HStack {
                    Image(systemName: "clock.arrow.circlepath")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 10)
                    
                    
                    Text("All History")
                        .font(.title3)
                        .fontWeight(.bold)
                        .opacity(0.6)
                }
                
                if unpinnedParkingRecords.isEmpty {
                    Text("No history item")
                        .foregroundColor(.secondary)
                } else {
                    
                    ForEach(unpinnedParkingRecords) { entry in
                        HistoryComponent(entry: entry, pinItem: { pinItem(entry) }, deleteItem: { deleteItem(entry) })
                    }
                }
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {}) {
                            Text("Sort by Date")
                            Text("Default (The Newest)")
                                .font(.subheadline)
                            Image(systemName: "arrow.up.arrow.down")
                        }
                        Button(action: {}) {
                            Text("Delete Automatically")
                            Text("Default (5 Days)")
                                .font(.subheadline)
                            Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                        }
                        Button(action:{}) {
                            Text("Select")
                            Image(systemName: "checkmark.circle")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
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

    var body: some View {
        HStack {
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
