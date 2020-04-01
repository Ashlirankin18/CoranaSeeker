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

    private lazy var cancelButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "multiply") ?? UIImage() , style: .plain, target: self, action: #selector(cancelButtonPressed(_:)))
        barButtonItem.tintColor = .white
        return barButtonItem
    }()
   
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = .white
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.backgroundColor = .clear
        searchController.isAccessibilityElement = true
        searchController.searchBar.isAccessibilityElement = true
        searchController.searchBar.accessibilityLabel = NSLocalizedString(  "Search Bar", comment: "Indicates to the user that this object is a search bar")
        searchController.accessibilityLabel = NSLocalizedString( "Search Controller", comment: "Indicates to the user that this object is a search controller")
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    private var countries: [Country] {
        didSet {
            DispatchQueue.main.async {
                self.countryTableView.reloadData()
            }
        }
    }
    
    private let dataManager: DataManager
    
    /// The countryListViewControllerdelegate
    weak var delegate: CountryListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Countries"
        configureNavigationItemProperties()
        configureTableView()
        addKeyboardNotificationObservers()
    }
    
    /// Creates a new instance of  `CountryListViewController`.
    /// - Parameter countries: The countries of the world.
    init(countries: [Country], dataManager: DataManager){
        self.countries = countries
        self.dataManager = dataManager
        super.init(nibName: "CountryListViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNavigationItemProperties() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    private func configureTableView() {
        countryTableView.dataSource = self
        countryTableView.delegate = self
        countryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CountryCell")
        countryTableView.reloadData()
    }
    
    private func retrieveCountries() {
        dataManager.retrieveCountries(urlEndPointString: "https://api.covid19api.com/countries") { (result) in
            switch result {
            case let .failure(error):
                print(error)
            case var .success(newCountries):
                newCountries.removeFirst()
                self.countries = newCountries
            }
        }
    }
    
    private func addKeyboardNotificationObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(willHideKeyboard(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(willShowKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc private func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc func willHideKeyboard(notification: Notification) {
        self.countryTableView.scrollIndicatorInsets = .zero
        self.countryTableView.contentInset = .zero
    }
    
    @objc func willShowKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        countryTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        countryTableView.scrollIndicatorInsets = countryTableView.contentInset
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
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

extension CountryListViewController: UISearchResultsUpdating {
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text.count > 0 {
            let filteredCountries = countries.filter({$0.name.contains(text)})
            self.countries = filteredCountries
        } else if countries.isEmpty || searchController.searchBar.text?.isEmpty ?? true {
            retrieveCountries()
        }
    }
}
extension CountryListViewController: UISearchBarDelegate {
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
