//
//  ParkingRecordView.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 09/04/25.
//

import SwiftUI

struct ParkingRecordImageView: View {
    let parkingRecordImage: [ParkingImage]
    
    @Binding var isPreviewOpen: Bool
    @Binding var selectedImageIndex: Int
    
    var body: some View {
        if parkingRecordImage.isEmpty {
            Text("There's no image")
                .foregroundColor(.red)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
        } else {
            
            TabView(selection: $selectedImageIndex) {
                ForEach(0..<parkingRecordImage.count, id: \.self) { index in
                    Image(uiImage: parkingRecordImage[index].getImage())
                        .resizable()
                        .scaledToFill()
                        .frame(maxHeight: 250)
                        .clipped()
                        .cornerRadius(10)
                        .tag(index)
                        .onTapGesture {
                            isPreviewOpen = true
                        }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(height: 250)
        }
    }
}
