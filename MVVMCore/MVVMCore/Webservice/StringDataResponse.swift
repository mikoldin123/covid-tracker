//
//  StringDataResponse.swift
//  Alamofire
//
//  Created by michael.p.siapno on 02/08/2019.
//

import Foundation

public struct StringDataResponse: Codable {
    public let message: String
}
public extension StringDataResponse {
    public init(_ string: String) {
        message = string
    }
}
