//
//  AppData.swift
//  Jokes
//
//  Created by macbook on 05/04/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit
import SVProgressHUD

class AppData: NSObject {
    
    var greenColor = UIColor(red: 0/255, green: 104/255, blue: 56/255, alpha: 1)
    var fcm_token = String()
    var token = String()
    var kid_token = String()
    var child_code = String()
    
    class var sharedInstance : AppData {
        
        struct Static {
            static let instance : AppData = AppData()
        }
        return Static.instance
    }
    
    func isValidEmail(testStr:String) -> Bool {     
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidatePresence(string: String) -> Bool {
        let trimmed: String = string.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty
    }
    
    func isValidPhoneNumber(string: String) -> Bool {
        let PHONE_REGEX = "^\\d{10}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        return  phoneTest.evaluate(with: string)
    }
    
    func isValidPhoneNumber1(value: String) -> Bool {
        let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        
        return result
    }
    
    func isOnlyNumber(string: String) -> Bool {
        let PHONE_REGEX = "^[0-9]*"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        return  phoneTest.evaluate(with: string)
    }
    
    func isValidPhoneNumberWithCode(string: String) -> Bool {
        let PHONE_REGEX = "^\\+?91?\\s*\\(?-*\\.*(\\d{3})\\)?\\.*-*\\s*(\\d{3})\\.*-*\\s*(\\d{4})$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        return  phoneTest.evaluate(with: string)
    }
    
    func showAlert(title: String, message: String, viewController : UIViewController)->Void {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let action1 = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) { (dd) -> Void in
            }
            alert.addAction(action1)
            viewController.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func showLoader() {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
    }

    func dismissLoader() {
        if(SVProgressHUD.isVisible()) {
            SVProgressHUD.dismiss()
        }
    }
    
}
extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}
public extension UINavigationController {

    /**
     Pop current view controller to previous view controller.

     - parameter type:     transition animation type.
     - parameter duration: transition animation duration.
     */
    func pop(transitionType type: String = CATransitionType.fade.rawValue, duration: CFTimeInterval = 1.0) {
        self.addTransition(transitionType: type, duration: duration)
        self.popViewController(animated: false)
    }

    /**
     Push a new view controller on the view controllers's stack.

     - parameter vc:       view controller to push.
     - parameter type:     transition animation type.
     - parameter duration: transition animation duration.
     */
    func push(viewController vc: UIViewController, transitionType type: String = CATransitionType.fade.rawValue, duration: CFTimeInterval = 1.0) {
        self.addTransition(transitionType: type, duration: duration)
        self.pushViewController(vc, animated: false)
    }
    
    func popToView(viewController vc: UIViewController, transitionType type: String = CATransitionType.fade.rawValue, duration: CFTimeInterval = 1.0) {
        self.addTransition(transitionType: type, duration: duration)
        self.popToViewController(vc, animated: false)
    }

    private func addTransition(transitionType type: String = CATransitionType.fade.rawValue, duration: CFTimeInterval = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType(rawValue: type)
        self.view.layer.add(transition, forKey: nil)
    }
    
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
      if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
        popToView(viewController: vc)
      }
    }
}
