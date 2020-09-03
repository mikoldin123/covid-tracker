//
//  Country.swift
//  COVID Tracker
//
//  Created by Michael Dean Villanda on 9/2/20.
//  Copyright © 2020 Michael Dean Villanda. All rights reserved.
//

import Foundation

struct Country: Codable {
    let country: String
    let slug: String
    
    let code: String?
    let iso2: String?
    
    let newConfirmed: Int?
    let totalConfirmed: Int?
    let totalDeaths: Int?
    let newDeaths: Int?
    let newRecovered: Int?
    let totalRecovered: Int?
    
    enum CodingKeys: String, CodingKey {
        case country = "Country"
        case slug = "Slug"
        
        case code = "CountryCode"
        case iso2 = "ISO2"
        
        case newConfirmed = "NewConfirmed"
        case totalConfirmed = "TotalConfirmed"
        case newDeaths = "NewDeaths"
        case totalDeaths = "TotalDeaths"
        case newRecovered = "NewRecovered"
        case totalRecovered = "TotalRecovered"
    }
}
