//
//  ScreenGroupCoordinated.swift
//

import UIKit

public protocol ScreenGroupCoordinated {
    var screens: [ScreenCoordinated] { get }
    var title: String { get }
    var tabItem: UITabBarItem? { get }
    var configuration: ControllerConfiguration { get }
}
