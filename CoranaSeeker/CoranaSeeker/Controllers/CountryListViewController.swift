//
//  CountryListViewController.swift
//  CoranaSeeker
//
//  Created by Ashli Rankin on 3/29/20.
//  Copyright © 2020 Ashli Rankin. All rights reserved.
//

import UIKit

protocol CountryListViewControllerDelegate: AnyObject {
    func didSelectCountry(countryListViewController: CountryListViewController, country: Country)
}

class CountryListViewController: UIViewController {
    
    @IBOutlet weak var countryTableView: UITableView!
    
    private let countries: [Country]
    
    weak var delegate: CountryListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryTableView.dataSource = self
        countryTableView.delegate = self
        countryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CountryCell")
        countryTableView.reloadData()
    }
    
    init(countries: [Country]){
        self.countries = countries
        super.init(nibName: "CountryListViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension CountryListViewController: UITableViewDataSource {
    
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = countries[indexPath.row]
        delegate?.didSelectCountry(countryListViewController: self, country: country)
        dismiss(animated: true)
    }
}
