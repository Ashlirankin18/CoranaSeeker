//
//  LocationManager.swift
//  CoranaSeeker
//
//  Created by Ashli Rankin on 3/29/20.
//  Copyright © 2020 Ashli Rankin. All rights reserved.
//

import Foundation
import CoreLocation

/// Manages the location logic.
final class LocationManager: NSObject {
    
    private lazy var locationManager = CLLocationManager()
    
    /// The user's location.
    var userLocation: CLLocation? {
        return locationManager.location
    }
    var authorizationStatusDidChange: ((CLAuthorizationStatus, CLLocation?) -> Void)?
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
}
extension LocationManager: CLLocationManagerDelegate {
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatusDidChange?(status,manager.location)
    }
}
