//
//  DetailRecordActive.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 24/03/25.
//

import SwiftUI
import SwiftData

struct DetailRecordActive: View {
    @Binding var isPreviewOpen: Bool
    @Binding var isCompassOpen: Bool
    @Binding var selectedImageIndex: Int
    @State var dateTime: Date
    @State var parkingRecord: ParkingRecord
    @Environment(\.modelContext) var context
    
    @Binding var isComplete: Bool
    
    var body: some View {
//        Text(String(describing: parkingRecord.images))
        
        if parkingRecord.images.isEmpty {
            Text("There's no image")
                .foregroundColor(.red)
                .font(.headline)
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
                    
                    Text(dateTime, format: .dateTime.day().month().year())
                        .font(.subheadline)
                        .fontWeight(.bold)
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
                    
                    Text(dateTime, format: .dateTime.hour().minute())
                        .font(.subheadline)
                        .fontWeight(.bold)
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
            
            Text("GOP 9, \(parkingRecord.floor)")
                .font(.subheadline)
                .fontWeight(.bold)
        }
        
        Spacer()
            .frame(height: 20)
        
        HStack(spacing: 16) {
            Button {
                print("Navigate")
                isCompassOpen.toggle()
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
            .buttonStyle(.bordered)
            .background(Color.blue)
            .foregroundStyle(Color.white)
            .cornerRadius(8)
            .frame(maxWidth: .infinity)
            
            Button {
                isComplete.toggle()
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
            .buttonStyle(.bordered)
            .background(Color.green)
            .foregroundStyle(Color.white)
            .cornerRadius(8)
            .frame(maxWidth: .infinity)
        }
    }
}
