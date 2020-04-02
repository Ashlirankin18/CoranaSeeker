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
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet private var caseButtons: [UIButton]!
    private lazy var networkHelper = NetworkHelper()
    
    private lazy var dataManager = DataManager(networkHelper: networkHelper)
    
    private lazy var locationManager = LocationManager()
    
    private lazy var transitionDelegate = CardPresentationManager()
    
    private var country: Country?
    
    private var countries = [Country]() {
        didSet {
            DispatchQueue.main.async {
                self.getCurrentyInfo(with: self.countries)
            }
        }
    }
    
    private var tintColor: UIColor {
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            return .black
        case .dark:
            return .white
        @unknown default:
            assertionFailure("An unknown case was not handled")
            return .black
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        adaptToTraitCollection()
        configureNavigationBar()
        countryDisplayMapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveCountries()
    }
    
    private func adaptToTraitCollection() {
        navigationItem.rightBarButtonItem?.tintColor = tintColor
        caseButtons.forEach({$0.tintColor = tintColor})
    }

    
    private func configureNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
    private func getCurrentyInfo(with countries: [Country]) {
        locationManager.authorizationStatusDidChange = { status, location in
            
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                guard let location = location else {
                    return
                }
                self.locationManager.getPlace(for: location) { [weak self] (placemark) in
                    guard let countryName = placemark?.country else {
                        return
                    }
                    
                    if countryName == "United States" {
                        let name = "US"
                        if let currentCountry = self?.countries.first(where: { $0.name == name }) {
                            self?.country = currentCountry
                            self?.addAndShowAnnotation(lattitude: location.coordinate.latitude, longitude: location.coordinate.longitude, countryName: countryName)
                        }
                    }
                }
            default:
                print("here")
            }
        }
    }
    
    private func retrieveCoranaCasesStatistices(countryCode: String, status: String) {
        dataManager.retrieveCountryStatistics(urlEndPointString: "https://api.covid19api.com/total/country/\(countryCode)/status/\(status)") { [weak self] (result) in
            switch result {
            case let .success(cases):
                guard let newCase = cases.last else {
                    return
                }
                DispatchQueue.main.async {
                    self?.presentDetailledController(with: newCase)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    private func presentDetailledController(with countryCase: CountryCase) {
        let detailledController = CaseDetailViewController(countryCase: countryCase)
        detailledController.transitioningDelegate = transitionDelegate
        detailledController.modalPresentationStyle = .custom
        transitionDelegate.presentationDirection = .bottom
        present(detailledController, animated: true)
    }
    
    private func retrieveCountries() {
        dataManager.retrieveCountries(urlEndPointString: "https://api.covid19api.com/countries") { [weak self] (result) in
            switch result {
            case let .failure(error):
                print(error)
            case var .success(newCountries):
                newCountries.removeFirst()
                self?.countries = newCountries
            }
        }
    }
    
    private func retrieveNewArticles() {
        dataManager.retrieveNewsArticles(urlEndPointString: "https://newsapi.org/v2/top-headlines?q=coronavirus&apiKey=\(APIKeys.newskey)") { [weak self] (result) in
            switch result {
            case let .failure(error):
                print(error)
            case let .success(articles):
                let newViewController = NewsViewController(articles: articles)
                self?.present(newViewController, animated: true)
            }
        }
    }
    
    private func getLocation(countryName: String) {
        locationManager.getLocation(forPlaceCalled: countryName) { [weak self] (location) in
            if let location = location?.coordinate {
                self?.addAndShowAnnotation(lattitude: location.latitude, longitude: location.longitude, countryName: countryName)
            }
        }
    }
    
    private func addAndShowAnnotation(lattitude: CLLocationDegrees, longitude: CLLocationDegrees, countryName: String) {
        let locationAnnotation = MKPointAnnotation()
        locationAnnotation.coordinate = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
        locationAnnotation.isAccessibilityElement = true
        locationAnnotation.title = countryName
        countryDisplayMapView.centerCoordinate =  CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
        countryDisplayMapView.addAnnotation(locationAnnotation)
        countryDisplayMapView.camera.altitude = 500_000
        
    }
    
    @IBAction func listButtonTapped(_ sender: UIBarButtonItem) {
        let listViewController = CountryListViewController(countries: countries, dataManager: dataManager)
        let listNavigationController = UINavigationController(rootViewController: listViewController)
        listNavigationController.transitioningDelegate = transitionDelegate
        transitionDelegate.presentationDirection = .center
        listNavigationController.modalPresentationStyle = .custom
        listViewController.delegate = self
        present(listNavigationController, animated: true)
    }
    
    @IBAction private func confirmButtonTapped(_ sender: UIButton) {
        if let country = country {
            self.retrieveCoranaCasesStatistices(countryCode: country.slug, status: "confirmed")
        }
    }
    
    @IBAction private func deathsButtonTapped(_ sender: UIButton) {
        if let country = country {
            self.retrieveCoranaCasesStatistices(countryCode: country.slug, status: "deaths")
        }
    }
    
    @IBAction private func recoveredButtonTapped(_ sender: UIButton) {
        if let country = country {
            self.retrieveCoranaCasesStatistices(countryCode: country.slug, status: "recovered")
        }
    }
    
    @IBAction private func newsButtonTapped(_ sender: UIButton) {
        retrieveNewArticles()
    }
}

extension MapViewController: MKMapViewDelegate {
    
    // MARK : - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        
        annotationView.pinTintColor = tintColor
        annotationView.canShowCallout = true
        return annotationView
    }
}

extension MapViewController: CountryListViewControllerDelegate {
    
    // MARK : - CountryListViewControllerDelegate
    
    func didSelectCountry(countryListViewController: CountryListViewController, country: Country) {
        getLocation(countryName: country.name)
        self.country = country
    }
}
