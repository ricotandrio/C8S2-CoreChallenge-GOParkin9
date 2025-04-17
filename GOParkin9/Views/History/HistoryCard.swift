//
//  HistoryCard.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 16/04/25.
//

import SwiftUI
import SwiftData
import Foundation

struct HistoryCard: View {
    let entry: ParkingRecord
    let pinItem: () -> Void
    let deleteItem: () -> Void
    let isSelecting: Bool
    let isSelected: Bool
    let toggleSelection: () -> Void
    
    var body: some View {
        NavigationLink(destination: DetailHistoryView(
            parkingRecord: entry
        )) {
            HStack {
                
                if isSelecting {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isSelected ? Color.blue : Color.gray)
                        .onTapGesture {
                            toggleSelection()
                        }
                        .cornerRadius(5)
                }
                
                if entry.images.isEmpty {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .cornerRadius(5)
                        .clipped()
                        .padding(.trailing, 10)
                } else {
                    Image(uiImage: entry.images[0].getImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .cornerRadius(5)
                        .clipped()
                        .padding(.trailing, 10)
                }
                
                
                VStack(alignment: .leading) {
                    Text(entry.createdAt, format: .dateTime.day().month().year())
                        .font(.headline)
                        .padding(.vertical, 8)
                    
                    HStack() {
                        HStack {
                            Image(systemName: "arrow.down.backward.circle")
                            Text(entry.createdAt, format: .dateTime.hour().minute())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            Image(systemName: "arrow.up.forward.circle")
                            //                    if entry.completedAt.description.isEmpty {
                            //                        Text(entry.createdAt, format: .dateTime.hour().minute())
                            //                    } else {
                            Text(entry.completedAt, format: .dateTime.hour().minute())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
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
                
                Button {
                    deleteItem()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .tint(.red)
            }
        }

    }
}
