//
//  AddRecordView.swift
//  GOParkin9
//
//  Created by Regina Celine Adiwinata on 24/03/25.
//

import SwiftUI
import CoreLocation
import CoreLocationUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var errorMessage: String?

    override init() {
        super.init()
        manager.delegate = self
        checkAuthorization() // Periksa izin saat pertama kali aplikasi dibuka
        manager.pausesLocationUpdatesAutomatically=false
    }

    /// Mengecek status izin sebelum meminta lokasi
    private func checkAuthorization() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization() // Munculkan request izin
        case .restricted, .denied:
            DispatchQueue.main.async {
                self.errorMessage = "Location access denied. Please enable it in settings."
            }
        case .authorizedWhenInUse, .authorizedAlways:
            requestLocation() // Jika sudah diizinkan, langsung minta lokasi
        @unknown default:
            DispatchQueue.main.async {
                self.errorMessage = "Unknown location authorization status."
            }
        }
    }

    /// Meminta lokasi hanya jika layanan lokasi aktif
    func requestLocation() {
        if CLLocationManager.locationServicesEnabled() {
            if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
                manager.requestLocation()
            } else {
                checkAuthorization() // Pastikan izin sudah diberikan
            }
        } else {
            DispatchQueue.main.async {
                self.errorMessage = "Location services are disabled."
            }
        }
    }

    /// Delegate method untuk menangani perubahan izin
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization() // Periksa kembali izin setelah berubah
    }

    /// Delegate method untuk menerima lokasi terbaru
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        if let coordinate = locations.first?.coordinate {
            DispatchQueue.main.async {
                self.location = latestLocation.coordinate
                self.errorMessage = nil
            }
        }
    }

    /// Delegate method untuk menangani error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = "Failed to get location: \(error.localizedDescription)"
        }
    }
}

struct TriggerPage:View {
    @State private var showingSheet = false
    var body: some View {
        NavigationView {
            VStack {
                Button("Show Sheet") {
                            showingSheet.toggle()
                        }
                        .sheet(isPresented: $showingSheet) {
                            ModalView()
                        }
            }
        }

    }

}

struct FullscreenImageView: View {
    var imageName: String
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Image(imageName)
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
    let photos = Array(repeating: "gambar", count: 3)
    @State private var showingAlert = false
    @State private var showingAddButton = false
    @StateObject var locationManager = LocationManager()
    @State private var savedLocation: CLLocationCoordinate2D?
    @State private var selectedImage: String? = nil
    @State private var isImageFullscreen = false
    
    var body: some View {
        VStack {
            HStack {
                Button("dismiss") {
                    dismiss()
                }
                Spacer()
                Button("done") { }
            }
            .padding()
            
            Text("Add up to 8 photos or videos of your parking area environment")
                .padding()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 10) {
                ForEach(photos.indices, id: \.self) { index in
                    Image(photos[index])
                        .resizable()
                        .aspectRatio(1, contentMode: .fit) // Memastikan rasio 1:1
                        .frame(width: 80, height: 80) // Mengisi lebar sel
                        .clipped() // Memotong bagian luar gambar agar pas
                        .onTapGesture {
                            selectedImage = photos[index]
                            isImageFullscreen = true
                        }
                        .overlay(
                            Button(action: {}) {
                                RoundedRectangle(cornerRadius: 30)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color.red)
                                    .overlay(
                                        Text("x").foregroundColor(.white).offset()
                                    )
                                
                            }
                                .offset(x:-35,y:-35)
                            
                        )
                }
                
                if photos.count < 8 {
                    Button(action:{}) {
                        Rectangle()
                            .frame(width: 80, height: 80)
                            .foregroundColor(Color.gray.opacity(0.5))
                            .overlay(
                                Text("+").foregroundColor(.blue)
                            )
                    }
                    
                }
            }
            .padding()
            
            VStack {
                if let location = savedLocation {
                    Text("Saved location: \(location.latitude), \(location.longitude)")
                        .padding()
                        .font(.title3)
                } else if let errorMessage = locationManager.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
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
                            locationManager.requestLocation()
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
        .onReceive(locationManager.$location) { newLocation in
            if let newLocation = newLocation {
                savedLocation = newLocation // Simpan lokasi saat didapatkan
            }
        }
    }
}

