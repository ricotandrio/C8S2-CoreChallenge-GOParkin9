//
//  HistoryView.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 23/03/25.
//  Edited by Chikmah on 26/03/25.
//

import SwiftUI

// Data Model
struct HistoryEntry: Identifiable {
    let id: UUID = UUID()
    let date: String
    let clockIn: String
    let clockOut: String
    var isPinned: Bool
}

struct HistoryView: View {
    @State private var historyData = [
        HistoryEntry(date: "18 March 2025", clockIn: "08:45 AM", clockOut: "04:56 PM", isPinned: false),
        HistoryEntry(date: "19 March 2025", clockIn: "09:00 AM", clockOut: "05:10 PM", isPinned: false),
        HistoryEntry(date: "20 March 2025", clockIn: "08:30 AM", clockOut: "04:45 PM", isPinned: false)
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(historyData) { entry in
                    HistoryComponent(entry: entry, pinItem: { pinItem(entry) }, deleteItem: { deleteItem(entry) })
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

    // Function to pin/unpin an item
    func pinItem(_ entry: HistoryEntry) {
        if let index = historyData.firstIndex(where: { $0.id == entry.id }) {
            historyData[index].isPinned.toggle()
        }
    }

    // Function to delete an item
    func deleteItem(_ entry: HistoryEntry) {
        historyData.removeAll { $0.id == entry.id }
    }
}

struct HistoryComponent: View {
    let entry: HistoryEntry
    let pinItem: () -> Void
    let deleteItem: () -> Void
    let historyData: [HistoryEntry] = [
            HistoryEntry(date: "2025-03-30", clockIn: "08:00", clockOut: "17:00", isPinned: false),
            HistoryEntry(date: "2025-03-29", clockIn: "08:10", clockOut: "17:05", isPinned: true),
            HistoryEntry(date: "2025-03-28", clockIn: "08:15", clockOut: "16:55", isPinned: false)
        ]

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
