//
//  DetailHistoryView.swift
//  GOParkin9
//
//  Created by Chikmah on 07/04/25.
//

import SwiftUI

struct DetailHistoryView: View {
    
    let parkingRecord: ParkingRecord
    
    @State var isPreviewOpen: Bool = false
    @State var selectedImageIndex: Int = 0
    @State var isCompassOpen: Bool = false
    @Environment(\.dismiss) var dismiss
    
    @State var isDeleteConfirmationAlertOpen: Bool = false
    
    @Environment(\.modelContext) var context
    
    // This function belongs to delete button
    private func deleteItem(_ entry: ParkingRecord) {
        withAnimation {
            context.delete(entry)
            try? context.save()
        }

    }
    
    // This function belongs to pin button
    private func pinItem(_ entry: ParkingRecord) {
        withAnimation {
            entry.isPinned.toggle()
            try? context.save()
        }
    }
    
    @State private var selectedHistoryToBeDeleted: ParkingRecord?
    @State private var selectedHistoryToBePinned: ParkingRecord?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Image Slider
                ZStack {
                    
                    // Image Carousel with Swipe
                    if parkingRecord.images.isEmpty {
                        Text("There's no image")
                            .foregroundColor(.red)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else {
                        
                        TabView(selection: $selectedImageIndex) {
                            ForEach(0..<parkingRecord.images.count, id: \.self) { index in
                                Image(uiImage: parkingRecord.images[index].getImage())
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxHeight: 350)
                                    .clipped()
                                    .cornerRadius(10)
                                    .tag(index)
                                    .onTapGesture {
                                        isPreviewOpen = true
                                    }
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                        .frame(height: 350)
                    }
                }
            }
                Spacer()
                    .frame(height: 20)
            
                //Details
                Grid {
                    GridRow {
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "calendar")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .opacity(0.6)
                                
                                Text("Date")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .opacity(0.6)
                                
                            }
                            
                            Text(parkingRecord.createdAt, format: .dateTime.day().month().year())
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "map")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .opacity(0.6)
                                
                                Text("Location")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .opacity(0.6)
                                
                            }
                            
                            Text("GOP 9, \(parkingRecord.floor)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
            
                Spacer()
                    .frame(height: 20)
            
                Grid {
                    GridRow {
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "arrow.down.backward.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .opacity(0.6)
                                
                                Text("Clock in")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .opacity(0.6)
                                
                            }
                            
                            Text(parkingRecord.createdAt, format: .dateTime.hour().minute())
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "arrow.up.forward.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .opacity(0.6)
                                
                                Text("Clock out")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .opacity(0.6)
                                
                            }
                            
                            Text(parkingRecord.completedAt, format: .dateTime.hour().minute())
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                    .frame(height: 20)
            
                // Button
                Button {
                    print("Navigate Back")
                    isCompassOpen.toggle()
                } label: {
                    HStack {
                        Image(systemName: "figure.walk")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 15)
                        
                        Text("Navigate Back")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                Spacer()
                    .frame(height: 15)
            
                HStack {
                    Button(action: {
                        selectedHistoryToBeDeleted = parkingRecord
                        isDeleteConfirmationAlertOpen.toggle()
                    }) {
                        HStack {
                            Image(systemName: "trash")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 15)
                            
                            Text("Delete")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    Spacer()
                        .frame(width: 15)
                    
                    Button(action: {
                        pinItem(parkingRecord)
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: parkingRecord.isPinned ? "pin.slash" : "pin")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 15)
                            
                            Text(parkingRecord.isPinned ? "Unpin History" : "Pin History")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
            }
            .padding()
            .navigationTitle("\(parkingRecord.createdAt, format: .dateTime.day().month().year())")
            .navigationBarTitleDisplayMode(.inline)
            .alertComponent(
                isPresented: $isDeleteConfirmationAlertOpen,
                title: "Delete This Record?",
                message: "This action cannot be undone.",
                confirmAction: {
                    if let record = selectedHistoryToBeDeleted {
                        deleteItem(record)
                        dismiss()
                    }
                },
                confirmButtonText: "Delete",
                confirmButtonRole: .destructive
            )
            .fullScreenCover(isPresented: $isPreviewOpen) {
                
                ImagePreviewView(
                    imageName: parkingRecord.images[selectedImageIndex].getImage(),
                    isPresented: $isPreviewOpen
                )
                
            }
            Spacer()
                .fullScreenCover(isPresented: $isCompassOpen) {
                    CompassView(
                        isCompassOpen: $isCompassOpen,
                        selectedLocation: 7,
                        longitude: parkingRecord.longitude,
                        latitude: parkingRecord.latitude
                    )
                    
                }
        }
    }


//
//struct HistoryDetailView: View {
//    var body: some View {
//        NavigationStack {
//            NavigationLink("History Detail") {
//                HistoryDetail()
//            }
//            .navigationTitle("History")
//        }
//    }
//}
