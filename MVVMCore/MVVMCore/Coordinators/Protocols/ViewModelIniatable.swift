//
//  ViewModelIniatable.swift
//

import UIKit
import RxSwift

public protocol ViewModelInitiable: class {
    var disposeBag: DisposeBag { get set }
    init(model: Any?)
    func dispose()
}

public extension ViewModelInitiable {
    func dispose() {
        disposeBag = DisposeBag()
    }
}
