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
    var image: UIImage
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    isPresented = false
                }
        }
    }
}

struct ModalView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showingAlert = false
    @State private var showingAlertSave = false
    @State private var showingCamera = false
    @State private var isImageFullscreen = false
    @State private var selectedImage: UIImage?
    @State private var selectedFloor = "Basement 1"
    @State private var floors = ["Basement 1", "Basement 2"]
    let dateTime = Date.now

    let locationManager = NavigationManager()
    @State private var savedLocation: CLLocationCoordinate2D?
    
    @Environment(\.modelContext) var context

    func addParkingRecord(latitude: Double, longitude: Double, images: [UIImage]) {
        let convertedImages = images.map { ParkingImage(image: $0) }
        
        let record = ParkingRecord(
            latitude: latitude,
            longitude: longitude,
            isHistory: false,
            floor: selectedFloor,
            createdAt: dateTime,
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
    
    @State private var images: [UIImage] = [] // State untuk menyimpan gambar

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button("Dismiss") {
                    dismiss()
                }
                Spacer()
                Button {
                    if let location = savedLocation {
                        print("Button clicked")
                        addParkingRecord(
                            latitude: location.latitude,
                            longitude: location.longitude,
                            images: images
                        )
                        dismiss()
                    } else {
                        showingAlertSave.toggle()
                    }
                    
                } label: {
                    Text("Done")
                }
                .alert("No Location Saved", isPresented: $showingAlertSave) {
                    Button("OK") {
                    }
                } message: {
                    Text("You haven't saved your parking location. Press the location button and make sure the position is accurate")
                }
            }
            .padding()
            
            if(images.isEmpty) {
                Text("Add up to 8 photos or videos of your parking area environment")
                    .padding()
            }
            
            
            GridView(images: $images, isImageFullscreen: $isImageFullscreen, selectedImage: $selectedImage)
            Grid {
                GridRow {
                    HStack {
                        Image(systemName: "calendar")
                        Text(dateTime, format: .dateTime.day().month().year())
                    }
                    
                    HStack {
                        Image(systemName: "clock")
                        Text(dateTime, format: .dateTime.hour().minute())
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
            }.padding()
            HStack {
                Image(systemName: "stairs")
                Picker("Floor", selection: $selectedFloor) {
                    ForEach(floors, id: \.self) { floor in
                        Text(floor)
                    }
                }
                .pickerStyle(.segmented)
            }.padding()
            

            VStack(alignment: .leading){
                if let location = savedLocation {
                    Text("Location Saved!")
                } else {
                    Text("Press the button to get your location.")
                        .padding()
                    Button {
                        showingAlert.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 15)
                            
                            Text("Save my parking location")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                    .alert("Save Location", isPresented: $showingAlert) {
                        Button("Save") {
                            savedLocation = locationManager.location?.coordinate
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("Once you save the location, you can't change it until you complete the navigation.")
                    }
                }
                Spacer()
            }.padding()
            
            Spacer()
        }
        .sheet(isPresented: $isImageFullscreen) {
            if let selectedImage = selectedImage {
                FullscreenImageView(image: selectedImage, isPresented: $isImageFullscreen)
            }
        }
    }
}

struct GridView: View {
    @Binding var images: [UIImage]
    @Binding var isImageFullscreen: Bool
    @Binding var selectedImage: UIImage?
    
    @State private var showingCamera = false
    @State private var newImage: UIImage?

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 10) {
            ForEach(images.indices, id: \.self) { img in
                Image(uiImage: images[img])
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipped()
                    .cornerRadius(8)
                    .onTapGesture {
                        selectedImage = images[img]
                        isImageFullscreen = true
                    }
                    .overlay(
                        Button(action: {
                            images.remove(at: img)
                        }) {
                            RoundedRectangle(cornerRadius: 30)
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.red)
                                .overlay(
                                    Text("x").foregroundColor(.white)
                                )
                        }
                        .offset(x: -35, y: -35)
                    )
            }
            
            if images.count < 8 {
                Button(action: {
                    showingCamera.toggle()
                }) {
                    Rectangle()
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color.gray.opacity(0.5))
                        .cornerRadius(8)
                        .overlay(
                            Text("+").foregroundColor(.blue)
                        )
                }
                .fullScreenCover(isPresented: $showingCamera) {
                    CameraView(image: $newImage)
                        .ignoresSafeArea()
                }
                .onChange(of: newImage) { newValue in
                    if let newImage = newValue {
                        images.append(newImage)
                        self.newImage = nil
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
