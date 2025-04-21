//
//  NavigationManager.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 24/03/25.
//

import Foundation
import CoreLocation

class CoreLocationManager: NSObject, CLLocationManagerDelegate {
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    private var location: CLLocation?
    private var heading: CLHeading?
    private var isUpdating: Bool = false
    
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
