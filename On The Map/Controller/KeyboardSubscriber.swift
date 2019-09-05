//
//  KeyboardSubscriber.swift
//  On The Map
//
//  Created by Hossameldien Hamada on 9/5/19.
//  Copyright © 2019 Hossameldien Hamada. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    //MARK:- Subscribe
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK:- Unsubscribe
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK:- Selectors
    @objc func keyboardWillShow(_ notification:Notification) {
        if !(UIApplication.shared.delegate as! AppDelegate).KeyboardShown{
            view.frame.origin.y -= getKeyboardHeight(notification)-25
            (UIApplication.shared.delegate as! AppDelegate).KeyboardShown = true
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        (UIApplication.shared.delegate as! AppDelegate).KeyboardShown = false
        view.frame.origin.y = 0
    }
    
    //MARK:- Calculate Keyboard Height
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}
