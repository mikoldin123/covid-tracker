//
//  UIViewController+Configuration.swift
//

import UIKit
import LocalAuthentication

public struct ControllerConfiguration {
    public enum LeftButtonType {
        case `default`
        case menu
        case back
        case none
        case empty
        case customBack(String)
    }
    
    public enum RightButtonType {
        case `default`
        case profile
        case none
        case custom(barItem: UIBarButtonItem, screen: ScreenCoordinated)
        case text(String)
    }
    
    public var leftButton: LeftButtonType = LeftButtonType.default
    public var rightButton: RightButtonType = RightButtonType.none
    public var hideBottomBarWhenPushed: Bool = false
    public var isNavHidden: Bool = false

    public init() {
        leftButton = LeftButtonType.none
        rightButton = RightButtonType.none
    }
}

fileprivate var controllerAssocKey: UInt8 = 11

public extension UIViewController {
    
    var configuration: ControllerConfiguration {
        get {
            return (objc_getAssociatedObject(self,
                                             &controllerAssocKey)
                as? ControllerConfiguration) ?? ControllerConfiguration()
        }
        set(newValue) {
            objc_setAssociatedObject(self, &controllerAssocKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func authenticateUserUsingBiometrics(completion: @escaping (Bool, Error?) -> Void) {
        
        let context = LAContext()
        var error: NSError?
        
        context.localizedFallbackTitle = ""
        
            if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &error) {
                
                if error == nil {
                    
                    context.evaluatePolicy( LAPolicy.deviceOwnerAuthentication,
                    localizedReason: "Please authenticate to proceed",
                    reply: { (isSuccess, error) in
                        print("RESULT::", isSuccess)
                        DispatchQueue.main.async {
                            completion(isSuccess, error)
                        }
                    })
                } else {
                    
                    if let isError = error as? LAError {
                        displayBiometricErrorMessage(error: isError, completion: nil)
                    }
                }
                
            } else {
                displayBiometricErrorMessage(error: .init(.biometryNotEnrolled), completion: nil)
            }
    
        completion(false, nil)
    }
    
    func displayBiometricErrorMessage(error: LAError, completion: ((Bool) -> Void)? = nil) {
        
        var message: String = String()
        
        switch error.code {
        case LAError.authenticationFailed:
            message = "Authentication Failed."
        case LAError.userCancel:
            message = "Authentication Cancelled."
        case LAError.userFallback:
            message = "Fallback authentication mechanism selected."
        case LAError.passcodeNotSet:
            message = "Passcode is not set on the device."
        case LAError.systemCancel:
            message = "System Cancelled."
        default:
            message = "\"\(error.localizedDescription)\" Please enable it in device settings."
        }
    
        let alert = UIAlertController(title: "",
                                      message: message,
                                      preferredStyle: .alert)
    
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            (true ?? nil)
        })
        
        alert.addAction(okButton)
        
        self.present(alert, animated: false, completion: nil)
        
    }
    
}
