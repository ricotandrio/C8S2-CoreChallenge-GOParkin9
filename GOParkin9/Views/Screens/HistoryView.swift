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
    
    @Query(filter: #Predicate<ParkingRecord>{p in p.isHistory == true}) var parkingRecords: [ParkingRecord]
    
    @Environment(\.modelContext) var context

    
    var body: some View {
        NavigationView {
            List {
                ForEach(parkingRecords) { entry in
                    HistoryComponent(entry: entry, pinItem: { pinItem(entry) }, deleteItem: { deleteItem(entry) })
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
        entry.isPinned.toggle()
        try? context.save()
    }
    
    private func deleteItem(_ entry: ParkingRecord) {
        context.delete(entry)
        try? context.save()
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

#Preview {
    ContentView()
}
