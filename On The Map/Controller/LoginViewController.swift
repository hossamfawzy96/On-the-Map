//
//  ViewController.swift
//  On The Map
//
//  Created by Hossameldien Hamada on 8/31/19.
//  Copyright © 2019 Hossameldien Hamada. All rights reserved.
//

import UIKit
import MapKit

class LoginViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    
    //MARK:- Properties
    var keyboardShowm = false
    let textFieldDelegate = TextFieldDelegate()
    
    //MARK:- LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.delegate = textFieldDelegate
        password.delegate = textFieldDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    //MARK:- Actions
    @IBAction func login(_ sender: Any) {
        
        checkInput {
            let spinner = SpinnerViewController()
            spinner.createSpinnerView(parent: self)
            
            self.updateUI(enabled: false)
            
            UdacityClient.sharedInstance().authenticateUser(userName: self.userName.text!, password: self.password.text!){ (success, error) in
                performUIUpdatesOnMain {
                    
                    spinner.removeSpinnerView()
                    self.updateUI(enabled: true)
                    
                    if success {
                        self.completeLogin()
                    }else{
                        self.loginFailed(message: error!)
                    }
                    
                }
            }
        }
    }
    
    @IBAction func signup(_ sender: Any) {
        UdacityClient.sharedInstance().DirectToSignup()
    }
    
    //MARK:- Functions
    
    // checkInput checks that both the username and the password are provided bu the user
    private func checkInput(completionHandlerForCheckInput: @escaping() -> Void){
        
        // guard for username checkong
        guard (userName.text! != "") else{
            AlertViewController().showError(title: "Missing Credentials", message: "Please enter you username; ex:account@domain.com", parent: self)
            return
        }
        
        // guard for password checking
        guard(password.text! != "") else{
            AlertViewController().showError(title: "Missing Credentials", message: "Please enter password", parent: self)
            return
        }
        
        completionHandlerForCheckInput()
    }
    
    // reset text of textfields, disable and enable login button
    private func updateUI(enabled: Bool){
        
        if(enabled){
            userName.text = ""
            password.text = ""
            
            userName.resignFirstResponder()
            password.resignFirstResponder()
        }
        
        login.isEnabled = enabled
        
    }
    
    // Present the tabbed view of both the mao view and the table view
    private func completeLogin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "TabbedView")
        present(controller, animated: true, completion: nil)
    }
    
    // presents Alert in case of login failed
    private func loginFailed(message: String){
        AlertViewController().showError(title: "Login Failed",message: message, parent: self)
    }
}

