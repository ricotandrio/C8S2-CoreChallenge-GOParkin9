//
//  DetailRecordActive.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 24/03/25.
//

import SwiftUI

struct DetailRecordActive: View {
    @Binding var isPreviewOpen: Bool
    @Binding var selectedImageIndex: Int
    
    let images: [String]
    
    var body: some View {
        ZStack {
            Image(images[selectedImageIndex])
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
                            selectedImageIndex = (selectedImageIndex - 1) == -1 ? images.count - 1 : selectedImageIndex - 1
                        }
                    }
                
                Color
                    .clear
                    .frame(height: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isPreviewOpen = true
                    }
                
                Color
                    .clear
                    .frame(width: UIScreen.main.bounds.width / 3, height: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            selectedImageIndex = (selectedImageIndex + 1) % images.count
                        }
                    }
            }
        }
        HStack {
            ForEach(0..<images.count, id: \.self) { index in
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
            
            Text("25 Dec 2024 at 12:00 p.m.")
                .font(.subheadline)
                .fontWeight(.bold)
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
            
            Text("(87.2321, 123.1231)")
                .font(.subheadline)
                .fontWeight(.bold)
        }
        
        Spacer()
            .frame(height: 20)
        
        HStack(spacing: 16) {
            Button {
                print("Navigate")
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
