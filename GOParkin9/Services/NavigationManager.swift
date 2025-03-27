//
//  NavigationManager.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 24/03/25.
//

import Foundation
import CoreLocation

extension Double {
    func toRadians() -> Double { return self * .pi / 180 }
    func toDegrees() -> Double { return self * 180 / .pi }
}

class NavigationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager: CLLocationManager = CLLocationManager()
    
    @Published var location: CLLocation?
    @Published var heading: CLHeading?
    @Published var isUpdating: Bool = false
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        if CLLocationManager.headingAvailable() {
            locationManager.headingFilter = 1
            locationManager.startUpdatingHeading()
        }
        
        checkAuthorization()
    }
    
    private func checkAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            startLocationUpdates()
        case .restricted, .denied:
            print("Location access denied or restricted.")
        @unknown default:
            print("Unknown authorization status.")
        }
    }
    
    private func startLocationUpdates() {
        isUpdating = true
        locationManager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        DispatchQueue.main.async {
            self.location = latestLocation
            self.isUpdating = false
//            print("Updated location: \(latestLocation.coordinate.latitude), \(latestLocation.coordinate.longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        DispatchQueue.main.async {
            self.heading = newHeading
//            print("Heading: \(newHeading.magneticHeading), \(newHeading.trueHeading)")
        }
    }
}

extension NavigationManager {
    func angle(to destination: CLLocationCoordinate2D) -> Double {
        guard let from = self.location?.coordinate else { return 0 }
        
        let lat1 = from.latitude.toRadians()
        let lon1 = from.longitude.toRadians()
        let lat2 = destination.latitude.toRadians()
        let lon2 = destination.longitude.toRadians()
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        
        var bearing = atan2(y, x).toDegrees()
        if bearing < 0 { bearing += 360 }
        
        // Get the current phone heading (trueHeading); if not available, use 0.
        let phoneHeading = self.locationManager.heading?.magneticHeading ?? 0
        
        // Compute the relative angle so that if phone is pointing north (0°) it equals the bearing.
        let relativeAngle = (bearing - phoneHeading + 360).truncatingRemainder(dividingBy: 360)
        
        return relativeAngle
    }
    
    func distance(to destination: CLLocationCoordinate2D) -> Double {
        
        return 0.0
    }
    
//    func getLongitude() -> Double {
//        return Double(self.location.coordinate.latitude ?? 0.0)
//    }
}
