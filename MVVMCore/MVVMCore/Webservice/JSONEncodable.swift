//
//  JSONEncodable.swift
//

import Foundation

public typealias JSONDictionary = [String: Any]

public protocol JSONEncodable {
    var jsonDictionary: JSONDictionary? { get }
    var customJSONDictionary: JSONDictionary? { get }
}

public extension JSONEncodable {
    var jsonDictionary: JSONDictionary? {
        return nil
    }
    var customJSONDictionary: JSONDictionary? {
        return nil
    }
}

public struct EmptyJSONEncodable: JSONEncodable {
    public init() {
        
    }
}
