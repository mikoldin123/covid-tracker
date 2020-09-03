//
//  ProcessInfo+Port.swift
//  WhiteLabel
//
//  Created by Macgyver Villanda on 10/31/19.
//  Copyright © 2019 Accenture. All rights reserved.
//

import Foundation

public extension ProcessInfo {
    static func infoValue(for key: String) -> String? {
        let arguments = self.processInfo.arguments
        let filtered = arguments.filter {
            return $0.hasPrefix("\(key):")
        }
        guard let argument = filtered.first else {
            return nil
        }
        let values = argument.split(separator: ":")
        guard values.count > 0 else {
            return nil
        }
        return String(values[1])
    }

}
