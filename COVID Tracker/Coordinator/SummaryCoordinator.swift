//
//  SummaryCoordinator.swift
//  COVID Tracker
//
//  Created by Michael Dean Villanda on 9/2/20.
//  Copyright © 2020 Michael Dean Villanda. All rights reserved.
//

import Foundation
import UIKit
import MVVMCore

final class SummaryCoordinator: Coordinator {
    fileprivate let window: UIWindow?
    
    @discardableResult
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let nav = UINavigationController()
        nav.navigationBar.barStyle = .black
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.isOpaque = true
        nav.navigationBar.prefersLargeTitles = true
        let startController = ViewCoordinator(singleScreen: MainScreens.summary, navController: nav)
        self.window?.rootViewController = startController.navController
    }
}
