//
//  LocationManager.swift
//  CoranaSeeker
//
//  Created by Ashli Rankin on 3/29/20.
//  Copyright © 2020 Ashli Rankin. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject {
    
    private lazy var locationManager = CLLocationManager()
    
    var userLocation: CLLocation? {
        return locationManager.location
    }
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
}
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined         : print("notDetermined")
        case .authorizedWhenInUse   : print("authorizedWhenInUse")
        case .authorizedAlways      : print("authorizedAlways")
        case .restricted            : print("restricted")
        case .denied                : print("denied")
        @unknown default:
            print("An unknown case was not handled.")
        }
    }
}
