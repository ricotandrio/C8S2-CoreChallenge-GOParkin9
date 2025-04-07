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

    @Query(filter: #Predicate<ParkingRecord>{p in p.isHistory == false}) var parkingRecords: [ParkingRecord]

    var firstParkingRecord: ParkingRecord? {
        parkingRecords.first
    }

    @Query var parkingRecordss: [ParkingRecord]
    
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
                        parkingRecord: record
                        
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
