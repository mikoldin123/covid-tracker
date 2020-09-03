//
//  TaskWaitable.swift
//

import RxSwift

public enum WaitState {
    case idle
    case working
    case noOp
    case done
}

public protocol TaskWaitable {
    var waitState: Variable<WaitState> { get }
}
