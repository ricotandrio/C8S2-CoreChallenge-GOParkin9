//
//  NavigationManager.swift
//  GOParkin9
//
//  Created by Rico Tandrio on 13/04/25.
//

import CoreLocation

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
        guard let from = self.location?.coordinate else { return 0.0 }
//        print(from)
                
        let lat1 = from.latitude.toRadians()
        let lon1 = from.longitude.toRadians()
        let lat2 = destination.latitude.toRadians()
        let lon2 = destination.longitude.toRadians()
        
        let dLat = lat2 - lat1
        let dLon = lon2 - lon1
        
        let a = sin(dLat / 2) * sin(dLat / 2) +
                cos(lat1) * cos(lat2) *
                sin(dLon / 2) * sin(dLon / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        
        let earthRadius = 6371.0 // Radius bumi dalam kilometer
        return earthRadius * c * 1000 // Jarak dalam meter
    }
}
