//
//  MainScreens.swift
//  COVID Tracker
//
//  Created by Michael Dean Villanda on 9/2/20.
//  Copyright © 2020 Michael Dean Villanda. All rights reserved.
//

import Foundation
import MVVMCore

enum MainScreens {
    case summary
    case countries
}

extension MainScreens: ScreenCoordinated {
    var tabItem: UITabBarItem? {
        return nil
    }
    
    var title: String? {
        switch self {
        case .summary:
            return "Summary"
        default:
            return "Countries"
        }
    }
    
    var tabTitle: String? {
        return nil
    }
    
    var configuration: ControllerConfiguration {
        var config = ControllerConfiguration()
        config.isNavHidden = true
        return config
    }
    
    var controllerModel: ControllerModel {
        return build(SummaryViewController.self, modelType: SummaryViewModel.self)
    }
}
