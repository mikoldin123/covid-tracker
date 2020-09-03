//
//  Coordinatable.swift
//

import UIKit

public typealias CoordinatedInitiable = Coordinatable & ViewModelInitiable
public protocol Coordinatable: class {
    var coordinateDelegate: CoordinatorDelegate? { get set }
}

public struct ModalConfig {
    public let modalPresentationStyle: UIModalPresentationStyle
    public let modalTransitionStyle: UIModalTransitionStyle
    public let useTopParent: Bool
    
    public init(modalPresentationStyle: UIModalPresentationStyle,
                modalTransitionStyle: UIModalTransitionStyle,
                useTopParent: Bool) {
        self.modalPresentationStyle = modalPresentationStyle
        self.modalTransitionStyle = modalTransitionStyle
        self.useTopParent = useTopParent
    }
}
public extension ModalConfig {
    public init(modalPresentationStyle: UIModalPresentationStyle, modalTransitionStyle: UIModalTransitionStyle) {
        self.modalPresentationStyle = modalPresentationStyle
        self.modalTransitionStyle = modalTransitionStyle
        self.useTopParent = false
    }
}

public protocol CoordinatorDelegate: class {
    func present(screen: ScreenCoordinated, navigation: UINavigationController) -> CoordinatedInitiable?
    func presentModal(screen: ScreenCoordinated, config: ModalConfig, navigation: UINavigationController) -> CoordinatedInitiable?
    func navigateBack(removeTopController: Bool)
    @discardableResult
    func coordinate(to screen: ScreenCoordinated) -> CoordinatedInitiable?
    func navigateToRoot(animated: Bool, screen: ScreenCoordinated?)
    func set(screens: [ScreenCoordinated])
    func dismissPresented()
    func popTo(_ vcTarget: UIViewController.Type, push: ScreenCoordinated?)
    func dismissParent()
}
