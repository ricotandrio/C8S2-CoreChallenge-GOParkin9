//
//  AddRecordView.swift
//  GOParkin9
//
//  Created by Regina Celine Adiwinata on 24/03/25.
//

import SwiftUI
import CoreLocation
import CoreLocationUI

//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private let manager = CLLocationManager()
//    
//    @Published var location: CLLocationCoordinate2D?
//    @Published var errorMessage: String?
//
//    override init() {
//        super.init()
//        manager.delegate = self
//        checkAuthorization() // Periksa izin saat pertama kali aplikasi dibuka
//        manager.pausesLocationUpdatesAutomatically=false
//    }
//
//    /// Mengecek status izin sebelum meminta lokasi
//    private func checkAuthorization() {
//        switch manager.authorizationStatus {
//        case .notDetermined:
//            manager.requestWhenInUseAuthorization() // Munculkan request izin
//        case .restricted, .denied:
//            DispatchQueue.main.async {
//                self.errorMessage = "Location access denied. Please enable it in settings."
//            }
//        case .authorizedWhenInUse, .authorizedAlways:
//            requestLocation() // Jika sudah diizinkan, langsung minta lokasi
//        @unknown default:
//            DispatchQueue.main.async {
//                self.errorMessage = "Unknown location authorization status."
//            }
//        }
//    }
//
//    /// Meminta lokasi hanya jika layanan lokasi aktif
//    func requestLocation() {
//        if CLLocationManager.locationServicesEnabled() {
//            if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
//                manager.requestLocation()
//            } else {
//                checkAuthorization() // Pastikan izin sudah diberikan
//            }
//        } else {
//            DispatchQueue.main.async {
//                self.errorMessage = "Location services are disabled."
//            }
//        }
//    }
//
//    /// Delegate method untuk menangani perubahan izin
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        checkAuthorization() // Periksa kembali izin setelah berubah
//    }
//
//    /// Delegate method untuk menerima lokasi terbaru
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let latestLocation = locations.last else { return }
//        if let coordinate = locations.first?.coordinate {
//            DispatchQueue.main.async {
//                self.location = latestLocation.coordinate
//                self.errorMessage = nil
//            }
//        }
//    }
//
//    /// Delegate method untuk menangani error
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        DispatchQueue.main.async {
//            self.errorMessage = "Failed to get location: \(error.localizedDescription)"
//        }
//    }
//}

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
    @State private var showingAlert = false
    @State private var showingAddButton = false
    let locationManager = NavigationManager()
    @State private var savedLocation: CLLocationCoordinate2D?
    @State private var selectedImage: UIImage?
    @State private var isImageFullscreen = false
    @State private var showingCamera = false
    @State private var images: [UIImage] = []
    @State private var newImage: UIImage? = nil
    
    var body: some View {
        
        VStack {
            HStack {
                Button("Dismiss") {
                    dismiss()
                }
                Spacer()
                Button("Done") { }
            }
            .padding()
            
            
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

