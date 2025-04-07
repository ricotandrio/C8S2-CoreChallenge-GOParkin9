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
    var body: some View {
//        Text(String(describing: parkingRecord.images))
        
        if parkingRecord.images.isEmpty {
            Text("There's no image")
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical)
                .foregroundStyle(Color.red)
                .fontWeight(.bold)
            
        } else {
            ZStack {
                Image(uiImage: parkingRecord.images[selectedImageIndex].getImage())
                    .resizable()
                    .scaledToFill()
                    .frame(maxHeight: 200)
                    .animation(.easeInOut, value: selectedImageIndex)
                    .clipped()
                
                HStack{
                    Color
                        .clear
                        .frame(width: UIScreen.main.bounds.width / 3, height: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                selectedImageIndex = (selectedImageIndex - 1) == -1 ? parkingRecord.images.count - 1 : selectedImageIndex - 1
                            }
                        }
                    
                    Color
                        .clear
                        .frame(height: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            isPreviewOpen.toggle()
                        }
                    
                    Color
                        .clear
                        .frame(width: UIScreen.main.bounds.width / 3, height: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                selectedImageIndex = (selectedImageIndex + 1) % parkingRecord.images.count
                            }
                        }
                }
            }
        }
        
        HStack {
            ForEach(0..<parkingRecord.images.count, id: \.self) { index in
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(index == selectedImageIndex ? .blue : .gray.opacity(0.6))
                    .onTapGesture {
                        selectedImageIndex = index
                    }
            }
            
            
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 8)
        
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
                parkingRecord.isHistory.toggle()
                parkingRecord.completedAt = Date.now
                try? context.save()
                print("Complete")
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
