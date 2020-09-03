//
//  CoordinateEventListener.swift
//  MVVMCore
//
//  Created by Macgyver Villanda on 11/18/19.
//

import Foundation

public class CoordinateEvent {
    enum Event {
        case none
        case present(screen: ScreenCoordinated)
        case presentModal(screen: ScreenCoordinated)
        case navigateBack
        case coordinate(screen: ScreenCoordinated)
        case navigateToRoot(screen: ScreenCoordinated?)
        case set(screens: [ScreenCoordinated])
        case dismissPresented
        case popTo(_ vcTarget: UIViewController.Type, push: ScreenCoordinated?)
    }
    
    var event = Event.none
}

public class CoordinateEventListener: Coordinatable {
    public var coordinateDelegate: CoordinatorDelegate?
    public var coordinateEvent = CoordinateEvent()
    init() {
        coordinateDelegate = self
    }
}

extension CoordinateEventListener: CoordinatorDelegate {
    public func present(screen: ScreenCoordinated, navigation: UINavigationController) -> CoordinatedInitiable? {
        coordinateEvent.event = CoordinateEvent.Event.present(screen: screen)
        return nil
    }
    
    public func presentModal(screen: ScreenCoordinated, config: ModalConfig, navigation: UINavigationController) -> CoordinatedInitiable? {
        coordinateEvent.event = CoordinateEvent.Event.presentModal(screen: screen)
        return nil
    }
    
    public func navigateBack(removeTopController: Bool) {
        coordinateEvent.event = CoordinateEvent.Event.navigateBack
    }
    
    public func coordinate(to screen: ScreenCoordinated) -> CoordinatedInitiable? {
        coordinateEvent.event = CoordinateEvent.Event.coordinate(screen: screen)
        return nil
    }
    
    public func navigateToRoot(animated: Bool, screen: ScreenCoordinated?) {
        coordinateEvent.event = CoordinateEvent.Event.navigateToRoot(screen: screen)
    }
    
    public func set(screens: [ScreenCoordinated]) {
        coordinateEvent.event = CoordinateEvent.Event.set(screens: screens)
    }
    
    public func dismissPresented() {
        coordinateEvent.event = CoordinateEvent.Event.dismissPresented
    }
    
    public func popTo(_ vcTarget: UIViewController.Type, push: ScreenCoordinated?) {
        coordinateEvent.event = CoordinateEvent.Event.popTo(vcTarget, push: push)
    }
    public func dismissParent() {
        coordinateEvent.event = CoordinateEvent.Event.dismissPresented
    }
}
