//
//  DetailRecord.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 24/03/25.
//

import SwiftUI

struct DetailRecord: View {
    @State private var selectedImageIndex = 0
    @State private var isPreviewOpen = false
    @State var isCompassOpen = false
    
    let images = [
        "3CF9C512-DE75-4C62-B038-553BFBCED56A_1_105_c",
        "BAE36E3B-F571-4CAB-A27D-333964AC4452_1_105_c",
        "4D6A4712-F6CD-4E23-A454-8CF3FD2B12B4_1_105_c",
    ]
    
    let condition = true
    
    var body: some View {
        VStack(alignment: .leading) {
            Section(header: Text("Detail Record")
                .font(.title3)
                .fontWeight(.bold)
                .opacity(0.6)
            ) {
                
                if condition {
                    DetailRecordActive(
                        isPreviewOpen: $isPreviewOpen,
                        isCompassOpen: $isCompassOpen,
                        selectedImageIndex: $selectedImageIndex,
                        images: images
                    )
                } else {
                    DetailRecordInactive()
                }
            }
            .fullScreenCover(isPresented: $isPreviewOpen) {
                ImagePreviewView(imageName: images[selectedImageIndex], isPresented: $isPreviewOpen)
            }
            .fullScreenCover(isPresented: $isCompassOpen) {
                CompassView(
                    isCompassOpen: $isCompassOpen
                )
            }
        }
    }
}
