//
//  ViewControllerModellable.swift
//

import UIKit

public protocol ViewControllerModellable: class {
    associatedtype ViewModel
    init(model: ViewModel)
}

public protocol ControllerModellable {
    var coordinatedModel: CoordinatedInitiable { get }
}
