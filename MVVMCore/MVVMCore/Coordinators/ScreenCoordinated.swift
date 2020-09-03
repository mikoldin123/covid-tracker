//
//  ScreenCoordinated.swift
//

import UIKit

public enum ScreenPresentationStyle {
    case none
    case modal
}
public struct ControllerModel {
    public let viewController: UIViewController
    public let model: CoordinatedInitiable
}

public protocol ScreenCoordinated {
    var tabItem: UITabBarItem? { get }
    var title: String? { get }
    var tabTitle: String? { get }
    var configuration: ControllerConfiguration { get }
    var controllerModel: ControllerModel { get }
    
    func build<ViewController: ViewControllerModellable,
        ViewModel: CoordinatedInitiable>(_ controllerType: ViewController.Type,
                                   modelType: ViewModel.Type,
                                   object: Any?) -> ControllerModel
}

public extension ScreenCoordinated {
    
    func build<ViewController: ViewControllerModellable,
        ViewModel: CoordinatedInitiable>(_ controllerType: ViewController.Type,
                                   modelType: ViewModel.Type,
                                   object: Any? = nil) -> ControllerModel {
        let originalModel = ViewModel(model: object)
        if let model = originalModel as? ViewController.ViewModel {
            let controller = ViewController(model: model)
            if let newController = controller as? UIViewController {
                newController.navigationItem.title = title
                newController.tabBarItem.title = tabTitle
                newController.configuration = configuration
                return ControllerModel(viewController: newController, model: originalModel)
            }
        }
        fatalError("unable to create view controller")
    }
}
