//
//  DetailRecord.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 24/03/25.
//

import SwiftUI
import SwiftData

struct DetailRecord: View {
    @State private var selectedImageIndex = 0
    @State private var isPreviewOpen = false
    @State var isCompassOpen: Bool = false
    
    @State var isComplete: Bool = false

    @Query(filter: #Predicate<ParkingRecord>{p in p.isHistory == false}) var parkingRecords: [ParkingRecord]

    var firstParkingRecord: ParkingRecord? {
        parkingRecords.first
    }

    @Query var parkingRecordss: [ParkingRecord]
    @Environment(\.modelContext) var context
    
    func complete() {
        firstParkingRecord?.isHistory.toggle()
        firstParkingRecord?.completedAt = Date.now
        try? context.save()
        print("Complete")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Section {
//                Text(String(describing: parkingRecordss))
                
                if let record = firstParkingRecord {
                    DetailRecordActive(
                        isPreviewOpen: $isPreviewOpen,
                        isCompassOpen: $isCompassOpen,
                        selectedImageIndex: $selectedImageIndex,
                        dateTime: record.createdAt,
                        parkingRecord: record,
                        isComplete: $isComplete
                        
                    )
                } else {
                    DetailRecordInactive()
                }

            } header: {
                Text("Detail Record")
                    .font(.title3)
                    .fontWeight(.bold)
                    .opacity(0.6)
            }
            .alertComponent(
                isPresented: $isComplete,
                title: "Complete this record?",
                message: "This action cannot be undone.",
                confirmAction: complete,
                confirmButtonText: "Complete"
            )
            .fullScreenCover(isPresented: $isPreviewOpen) {
                if let image = firstParkingRecord?.images[selectedImageIndex].getImage() {
                    ImagePreviewView(imageName: image, isPresented: $isPreviewOpen)
                }
            }
            .fullScreenCover(isPresented: $isCompassOpen) {

                if let record = firstParkingRecord {
                    CompassView(
                        isCompassOpen: $isCompassOpen,
                        selectedLocation: "Parking Location",
                        longitude: record.longitude,
                        latitude: record.latitude
                    )
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
