//
//  MapViewController.swift
//  CoranaSeeker
//
//  Created by Ashli Rankin on 3/29/20.
//  Copyright © 2020 Ashli Rankin. All rights reserved.
//

import UIKit
import MapKit

/// `UIViewController` subclass which displays a map.
final class MapViewController: UIViewController {
    
    @IBOutlet private weak var countryDisplayMapView: MKMapView!
    
    private lazy var networkHelper = NetworkHelper()
    
    private lazy var dataManager = DataManager(networkHelper: networkHelper)
    
    private lazy var locationManager = LocationManager()
    
    private var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  retrieveCountries()
        getLocation()
    }
    private func retrieveCountries() {
        dataManager.retrieveCountries(urlEndPointString: "https://api.covid19api.com/countries") { (result) in
            switch result {
            case let .failure(error):
                print(error)
            case let .success(countries):
                self.countries = countries
            }
        }
    }
    
    
    private func getLocation() {

        locationManager.getLocation(forPlaceCalled: "Ghana") { (location) in
            if let lattitude = location?.coordinate.latitude, let longitude = location?.coordinate.longitude {
                let center =  CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
                self.countryDisplayMapView.setRegion(region, animated: true)
                self.addAndShowAnnotation(lattitude: center.latitude, longitude: center.longitude)
            }
        }
        
        
    }
    private func checksForExistingAnnotations(lattitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        if !countryDisplayMapView.annotations.isEmpty {
            countryDisplayMapView.removeAnnotations(countryDisplayMapView.annotations)
        }
        addAndShowAnnotation(lattitude: lattitude, longitude: lattitude)
    }
    
    private func addAndShowAnnotation(lattitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let locationAnnotation = MKPointAnnotation()
        locationAnnotation.coordinate = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
        locationAnnotation.isAccessibilityElement = true
        countryDisplayMapView.addAnnotation(locationAnnotation)
        countryDisplayMapView.showAnnotations([locationAnnotation], animated: false)
    }
}

