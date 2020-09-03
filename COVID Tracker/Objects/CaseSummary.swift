//
//  CaseSummary.swift
//  COVID Tracker
//
//  Created by Michael Dean Villanda on 9/2/20.
//  Copyright © 2020 Michael Dean Villanda. All rights reserved.
//

import Foundation

struct CovidSummary: Codable {
    let global: GlobalSummary
    let countries: [Country]
    
    enum CodingKeys: String, CodingKey {
        case global = "Global"
        case countries = "Countries"
    }
}

struct GlobalSummary: Codable {
    let newConfirmed: Int
    let totalConfirmed: Int
    let totalDeaths: Int
    let newDeaths: Int
    let newRecovered: Int
    let totalRecovered: Int
    
    enum CodingKeys: String, CodingKey {
        case newConfirmed = "NewConfirmed"
        case totalConfirmed = "TotalConfirmed"
        case newDeaths = "NewDeaths"
        case totalDeaths = "TotalDeaths"
        case newRecovered = "NewRecovered"
        case totalRecovered = "TotalRecovered"
    }
}
