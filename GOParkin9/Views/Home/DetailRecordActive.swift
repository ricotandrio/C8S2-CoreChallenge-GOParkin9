//
//  DetailRecordActive.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 24/03/25.
//

import SwiftUI
import SwiftData

struct DetailRecordActive: View {
    @ObservedObject var detailRecordVM: DetailRecordViewModel
    
    var body: some View {
        
        ParkingRecordImageView(
            parkingRecordImage: detailRecordVM.activeParkingRecord!.images,
            isPreviewOpen: $detailRecordVM.isPreviewOpen,
            selectedImageIndex: $detailRecordVM.selectedImageIndex
        )
        
        Spacer()
            .frame(height: 20)
    
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
                    
                    Text(detailRecordVM.activeParkingRecord!.createdAt, format: .dateTime.day().month().year())
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "clock")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .opacity(0.6)
                        
                        Text("Clock in")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .opacity(0.6)
                        
                    }
                    
                    Text(detailRecordVM.activeParkingRecord!.createdAt, format: .dateTime.hour().minute())
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
        
        
        Spacer()
            .frame(height: 20)
        
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
            
            Text("GOP 9, \(detailRecordVM.activeParkingRecord!.floor)")
                .font(.subheadline)
                .fontWeight(.medium)
        }
        
        Spacer()
            .frame(height: 20)
        
        HStack(spacing: 16) {
            Button {
                detailRecordVM.isCompassOpen.toggle()
            } label: {
                HStack {
                    Image(systemName: "figure.walk")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 15)
                    
                    Text("Navigate")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .background(Color.blue)
            .foregroundStyle(Color.white)
            .cornerRadius(10)
            .frame(maxWidth: .infinity)
            
            Button {
                detailRecordVM.isComplete.toggle()
            } label: {
                HStack {
                    Image(systemName: "car")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 15)
                    
                    Text("Complete")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .background(Color.green)
            .foregroundStyle(Color.white)
            .cornerRadius(10)
            .frame(maxWidth: .infinity)
        }
    }
}
