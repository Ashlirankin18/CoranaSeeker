//
//  Country.swift
//  CoranaSeeker
//
//  Created by Ashli Rankin on 3/29/20.
//  Copyright © 2020 Ashli Rankin. All rights reserved.
//

import Foundation

struct Country: Codable {
    
    let name: String
    /// The identifier of the country.
    let slug: String
    
    
    private enum CodingKeys: String, CodingKey {
        case name = "Country"
        case slug = "Slug"
    }
}

struct CountryCase: Codable {
    let name: String
    let lat: Double
    let long: Double
    let date: Date
    let cases: Int
    let status: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "Country"
        case lat = "Lat"
        case long = "Long"
        case date = "Date"
        case cases = "Cases"
        case status = "Status"
        
    }
}
