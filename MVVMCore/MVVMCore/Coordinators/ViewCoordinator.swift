//
//  ViewCoordinator.swift
//
//  Created by macgyver.s.villanda on 07/06/2019.
//

import UIKit

public final class ViewCoordinator: ChildCoordinator, CoordinatorDelegate {
    public var controller: UIViewController?
    public var navController: UINavigationController?
    var coordinators: [ViewCoordinator] = []
    var viewModel: CoordinatedInitiable?
    public init(navController: UINavigationController?, controller: UIViewController) {
        self.controller = controller
        self.navController = navController
        coordinators.append(self)
        if let screenCoordinatable = controller as? ControllerModellable {
            screenCoordinatable.coordinatedModel.coordinateDelegate = self
        }
    }
    public convenience init<NavigationController: UINavigationController>(screen: ScreenCoordinated,
                                                         navController: NavigationController) {
        let screenModelController = screen.controllerModel
        let screenController = screenModelController.viewController
        self.init(navController: NavigationController(), controller: screenController)
        self.viewModel = screenModelController.model
        self.navController?.tabBarItem = screen.tabItem
    }
    public convenience init<NavigationController: UINavigationController>(singleScreen: ScreenCoordinated,
                                                                          navController: NavigationController) {
        let screenModelController = singleScreen.controllerModel
        let screenController = screenModelController.viewController
        let navController = NavigationController(rootViewController: screenController)
        self.init(navController: navController, controller: screenController)
        self.viewModel = screenModelController.model
    }
}

public extension CoordinatorDelegate where Self: ViewCoordinator {
    
    func present(screen: ScreenCoordinated, navigation: UINavigationController) -> CoordinatedInitiable? {
        let screenModel = screen.controllerModel
        let screenCoordinator = ViewCoordinator(singleScreen: screen, navController: navigation)
        
        guard let screenController = screenCoordinator.controller,
            let screenControllerNav = screenCoordinator.navController else {
            fatalError("Unable to create screen")
        }
        screenControllerNav.modalPresentationStyle = .fullScreen
        if #available(iOS 13.0, *) {
            screenControllerNav.isModalInPresentation = true
        }
        // default is hidden.. just unhide using the controllers configuation
        screenControllerNav.isNavigationBarHidden = true
        if let navigationController = self.navController {
            navigationController.present(screenControllerNav, animated: true, completion: nil)
            return screenCoordinator.viewModel
        }
        fatalError("Unable to proceed...")
    }
    func presentModal(screen: ScreenCoordinated, config: ModalConfig, navigation: UINavigationController) -> CoordinatedInitiable? {
        let screenModel = screen.controllerModel
        let screenCoordinator = ViewCoordinator(singleScreen: screen, navController: navigation)
        
        guard let screenController = screenCoordinator.controller,
            let screenControllerNav = screenCoordinator.navController else {
            fatalError("Unable to create screen")
        }
        
        screenControllerNav.providesPresentationContextTransitionStyle = true
        screenControllerNav.definesPresentationContext = true
        screenControllerNav.modalPresentationStyle = config.modalPresentationStyle
        screenControllerNav.modalTransitionStyle = config.modalTransitionStyle
        // default is hidden.. just unhide using the controllers configuation
        screenControllerNav.isNavigationBarHidden = true
        if config.useTopParent {
            if let window = UIApplication.shared.keyWindow,
                let tabController = window.rootViewController as? UITabBarController {
                tabController.present(screenControllerNav, animated: true, completion: nil)
                return screenCoordinator.viewModel
            }
        }
        if let navigationController = self.navController {
            navigationController.present(screenControllerNav, animated: true, completion: nil)
            return screenCoordinator.viewModel
        }
        fatalError("Unable to proceed...")
    }
    
    func navigateBack(removeTopController: Bool) {
        if let navigationController = self.navController {
            _ = self.coordinators.popLast()
            if removeTopController {
                navigationController.popViewController(animated: true)
            }
            return
        }
        fatalError("Unable to proceed...")
    }
    @discardableResult
    func coordinate(to screen: ScreenCoordinated) -> CoordinatedInitiable? {
        let screenModel = screen.controllerModel
        let screenCoordinator = ViewCoordinator(navController: self.navController,
                                                controller: screenModel.viewController)
        
        guard let screen = screenCoordinator.controller else {
            fatalError("Unable to create screen")
        }
        
        if let navigationController = self.navController {
            addCoordinator(screenCoordinator)
            navigationController.pushViewController(screen, animated: true)
            return screenModel.model
        }
        fatalError("Unable to proceed..public .")
    }
    func navigateToRoot(animated: Bool = true, screen: ScreenCoordinated? = nil) {
        if let navigationController = self.navController {
            if navigationController.viewControllers.count == 1 {
                return
            }
            if let rootCoordinator = self.coordinators.first {
                self.coordinators.removeAll()
                self.coordinators.append(rootCoordinator)
            }
            navigationController.popToRootViewController(animated: animated)
            if let screen = screen {
                coordinate(to: screen)
            }
            return
        }
    }
    func set(screens: [ScreenCoordinated]) {
        if let navigationController = self.navController {
            //self.coordinators.removeAll()
            let screenControllers: [UIViewController] = screens.compactMap { screen in
                let screenCoordinator = ViewCoordinator(navController: navigationController,
                                                        controller: screen.controllerModel.viewController)
                addCoordinator(screenCoordinator)
                return screenCoordinator.controller
            }
            navigationController.setViewControllers(screenControllers, animated: true)
        }
    }
    
    fileprivate func addCoordinator(_ viewCoordinator: ViewCoordinator) {
        if let coordinatorController = viewCoordinator.controller as? ControllerModellable {
            coordinatorController.coordinatedModel.coordinateDelegate = self
        }
        self.coordinators.append(viewCoordinator)
    }
    func dismissPresented() {
        if let presented = controller?.presentedViewController {
            presented.dismiss(animated: true, completion: nil)
        } else if let navPresented = navController?.presentedViewController {
            navPresented.dismiss(animated: true, completion: nil)
        } else if let tabPresented = navController?.tabBarController?.presentedViewController {
            tabPresented.dismiss(animated: true, completion: nil)
        } else {
            dismissParent()
        }
    }
    
    func dismissParent() {
        navController?.dismiss(animated: true, completion: nil)
    }
    
    func popTo(_ vcTarget: UIViewController.Type, push: ScreenCoordinated?) {
        if let navigationController = self.navController {
            for vController in navigationController.viewControllers {
                if type(of: vController) == vcTarget {
                    navigationController.popToViewController(vController, animated: false)
                    if let newScreen = push {
                        coordinate(to: newScreen)
                    }
                    return
                } else {
                    coordinators.removeLast()
                }
            }
            
        }
        fatalError("Unable to proceed...")
    }
    
    fileprivate func topMostController() -> UIViewController? {
        guard let window = UIApplication.shared.keyWindow,
            let menuController = window.rootViewController as? UINavigationController else {
                return nil
        }
        return activeTopController(menuController: menuController)
    }
    
    fileprivate func activeTopController(menuController: UINavigationController) -> UIViewController {
        if let topController = menuController.topViewController {
            return topController
        }
        fatalError("Unable to find top controller")
    }
}


