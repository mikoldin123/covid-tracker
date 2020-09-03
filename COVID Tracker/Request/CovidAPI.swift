//
//  CovidAPI.swift
//  COVID Tracker
//
//  Created by Michael Dean Villanda on 9/2/20.
//  Copyright © 2020 Michael Dean Villanda. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import MVVMCore

enum CovidAPI {
    case summary
    case countries
}

extension CovidAPI: APIWebservice {
    var baseURL: String {
        return Covid.API.baseURL
    }
    
    var endpoint: String {
        switch self {
        case .summary:
            return "summary"
        default:
            return "countries"
        }
    }
    
    var params: [String : Any]? {
        return nil
    }
    
    var method: HTTPMethod {
        return .get
    }
}
