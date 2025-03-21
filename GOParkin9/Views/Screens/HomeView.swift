//
//  HomeView.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 21/03/25.
//

import SwiftUI


struct DestinationButton: Identifiable {
    let id: UUID = UUID()
    let name: String
    let icon: String
}

struct DestinationView: View {
    let destinations = [
        DestinationButton(name: "Entry Gate A", icon: "pedestrian.gate.closed"),
        DestinationButton(name: "Entry Gate B", icon: "car"),
        DestinationButton(name: "Charging Station", icon: "ev.charger"),
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Section(header: Text("Destination").font(.title3).fontWeight(.bold).opacity(0.6)) {
                HStack {
                    ForEach(destinations) { destination in
                        VStack {
                            Button(action: {
                                print(destination.name)
                            }) {
                                Image(systemName: destination.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.blue)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                            }
                            .frame(width: 60, height: 60)
                            
                            Spacer()
                                .frame(height: 10)
                            
                            Text(destination.name)
                                .font(.caption)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct DetailRecord: View {
    @State private var selectedImageIndex = 0
    @State private var isPreviewOpen = false
    
    let images = [
        "3CF9C512-DE75-4C62-B038-553BFBCED56A_1_105_c",
        "BAE36E3B-F571-4CAB-A27D-333964AC4452_1_105_c",
        "4D6A4712-F6CD-4E23-A454-8CF3FD2B12B4_1_105_c",
        
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Section(header: Text("Detail Record")
                .font(.title3)
                .fontWeight(.bold)
                .opacity(0.6)
            ) {
                
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
        }
        .fullScreenCover(isPresented: $isPreviewOpen) {
            ImagePreviewView(imageName: images[selectedImageIndex], isPresented: $isPreviewOpen)
        }
    }
}

struct HomeView: View {
    var body: some View {
        VStack {
            Text("GOParkin9")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
                .frame(height: 20)
            
            DestinationView()
            
            Spacer()
                .frame(height: 40)
            
            DetailRecord()
            
            TabView {
                Tab("Home", systemImage: "house") {
                    
                }
                .badge(2)


                Tab("History", systemImage: "clock") {
                    
                }
                .badge(5)
            }
            
            Spacer()
            
            
        }
        .frame(maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    HomeView()
}
