//
//  CaseDetailViewController.swift
//  CoranaSeeker
//
//  Created by Ashli Rankin on 3/30/20.
//  Copyright © 2020 Ashli Rankin. All rights reserved.
//

import UIKit

final class CaseDetailViewController: UIViewController {
  
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var countryNameLabel: UILabel!
    @IBOutlet private weak var caseNumberLabel: UILabel!
    
    private let countryCase: CountryCase
    
    init(countryCase: CountryCase) {
        self.countryCase = countryCase
        super.init(nibName: "CaseDetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.text = "\(countryCase.status.capitalized) Cases"
        countryNameLabel.text = countryCase.name
        caseNumberLabel.text = "\(countryCase.cases)"
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15.0
    }
}

