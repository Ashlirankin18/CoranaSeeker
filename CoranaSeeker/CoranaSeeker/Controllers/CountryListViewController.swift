//
//  CountryListViewController.swift
//  CoranaSeeker
//
//  Created by Ashli Rankin on 3/29/20.
//  Copyright © 2020 Ashli Rankin. All rights reserved.
//

import UIKit

/// `Confrom to this protocolto be notified about when a user changes the country.
protocol CountryListViewControllerDelegate: AnyObject {
    
    /// This is called when a country is selected.
    /// - Parameters:
    ///   - countryListViewController: The countryListViewController.
    ///   - country: The selected country.
    func didSelectCountry(countryListViewController: CountryListViewController, country: Country)
}

/// `UIViewController` subclass which displays a list of all the countroes of the world.
final class CountryListViewController: UIViewController {
    
    @IBOutlet weak var countryTableView: UITableView!
    
    private let countries: [Country]
    
    /// The countryListViewControllerdelegate
    weak var delegate: CountryListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    /// Creates a new instance of  `CountryListViewController`.
    /// - Parameter countries: The countries of the world.
    init(countries: [Country]){
        self.countries = countries
        super.init(nibName: "CountryListViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTableView() {
        countryTableView.dataSource = self
        countryTableView.delegate = self
        countryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CountryCell")
        countryTableView.reloadData()
    }
    
}

extension CountryListViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country = countries[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CountryCell")
        cell.textLabel?.text = country.name
        return cell
    }
}

extension CountryListViewController: UITableViewDelegate {
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = countries[indexPath.row]
        delegate?.didSelectCountry(countryListViewController: self, country: country)
        dismiss(animated: true)
    }
}
