//
//  AddRecordView.swift
//  GOParkin9
//
//  Created by Regina Celine Adiwinata on 24/03/25.
//

import SwiftUI
import CoreLocation
import CoreLocationUI
import SwiftData

struct FullscreenImageView: View {
    var imageName: UIImage
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Image(uiImage: imageName)
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    isPresented = false // Tutup fullscreen saat diklik
                }
        }
    }
}

struct ModalView: View {
    @Environment(\.dismiss) var dismiss
    @State var showingAlert = false
    @State var showingAddButton = false
    let locationManager = NavigationManager()
    @State var savedLocation: CLLocationCoordinate2D?
    @State var selectedImage: UIImage?
    @State var isImageFullscreen = false
    @State var showingCamera = false
    @State var images: [UIImage] = []
    @State var newImage: UIImage? = nil
    
    @Environment(\.modelContext) var context
    
    func addParkingRecord(latitude: Double, longitude: Double, images: [UIImage]) {
        let convertedImages = images.map { ParkingImage(image: $0) }
        
        let record = ParkingRecord(
            latitude: latitude,
            longitude: longitude,
            images: convertedImages
        )
        
        context.insert(record)
        
        do {
            try context.save()
            print("Record added successfully!")
        } catch {
            print("Failed to save record: \(error)")
        }
    }
    
    @Query var parkingRecords: [ParkingRecord]
    
    var body: some View {
        
        VStack {
            HStack {
                Button("Dismiss") {
                    dismiss()
                }
                Spacer()
                Button {
                    if let location = savedLocation {
                        print("button clicked")
                        addParkingRecord(
                            latitude: location.latitude,
                            longitude: location.longitude,
                            images: images
                        )
                    }
                } label: {
                    Text("Done")
                }
            }
            .padding()
            
            
            List(parkingRecords) { record in
                Text("imaegs: \(String(describing: record.images))")
                Text("latitude \(record.longitude)")
                Text("longitude \(record.latitude)")
            }
                
            
            Text("Add up to 8 photos or videos of your parking area environment")
                .padding()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 10) {
                ForEach(images.indices, id: \.self) { index in
                    Image(uiImage: images[index])
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(1, contentMode: .fit) // Memastikan rasio 1:1
                        .frame(width: 80, height: 80) // Mengisi lebar sel
                        .clipped() // Memotong bagian luar gambar agar pas
                        .onTapGesture {
                            selectedImage = images[index]
                            isImageFullscreen = true
                        }
                        .overlay(
                            Button(action: {
                                images.remove(at: index)
                            }) {
                                RoundedRectangle(cornerRadius: 30)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color.red)
                                    .overlay(
                                        Text("x").foregroundColor(.white)
                                    )
                                
                            }
                                .offset(x:-35,y:-35)
                            
                        )
                }
                
                if images.count < 8 {
                    Button(action:{
                        showingCamera.toggle()
                    }) {
                        Rectangle()
                            .frame(width: 80, height: 80)
                            .foregroundColor(Color.gray.opacity(0.5))
                            .overlay(
                                Text("+").foregroundColor(.blue)
                            )
                    }
                    .fullScreenCover(isPresented: $showingCamera) {
                        CameraView(image: $newImage)
                    }
//                    if newImage != nil {
//                        images.append(newImage)
//                        newImage = nil
//                    }
                    .onChange(of: newImage) { newValue in
                        if let newImage = newValue {
                            images.append(newImage)
                            self.newImage = nil
                        }
                    }
                }
            }
            .padding()
            
            VStack {
                if let location = savedLocation {
                    Text("Location: \(String(describing: locationManager.location))")
                    
                    Text("Latitude: \(locationManager.location?.coordinate.latitude)")
                } else {
                    Text("Press the button to get your location.")
                        .padding()
                }
                
                if savedLocation == nil {
                    Button("Save my parking location") {
                        showingAlert = true
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .alert("Important message", isPresented: $showingAlert) {
                        Button("Save") {
                            savedLocation = locationManager.location?.coordinate
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("Once you save the location you can't change it until it's complete")
                    }
//                    .frame(height: 50)
                    .padding()
                }
                Spacer()
            }.padding()
            
            Spacer()
        }
        .sheet(isPresented: $isImageFullscreen) {
            if let selectedImage = selectedImage {
                FullscreenImageView(imageName: selectedImage, isPresented: $isImageFullscreen)
            }
        }
//        .onReceive(locationManager.$location) { newLocation in
//            if let newLocation = newLocation {
//                savedLocation = newLocation.coordinate // Simpan lokasi saat didapatkan
//            }
//        }
    }
}
