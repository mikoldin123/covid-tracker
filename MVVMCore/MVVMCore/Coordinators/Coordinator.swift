//
//  Coordinator.swift
//

import UIKit

public protocol Coordinator {
    func start()
}

public protocol ChildCoordinator: Coordinator {
    var controller: UIViewController? { get }
    var navController: UINavigationController? { get }
    init(navController: UINavigationController?, controller: UIViewController)
    //func addCoordinator(screen: CoordinatedScreen) -> UIViewController
}

public extension ChildCoordinator {
    func start() {
        if let navigationController = navController,
            let viewController = controller {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
