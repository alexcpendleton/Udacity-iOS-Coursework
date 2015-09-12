//
//  LoginViewController.swift
//  MyFavoriteMovies
//
//  Created by Alex Pendleton on 9/9/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit
import SwiftValidator

public class LoginViewController : UIViewController {
    var formValidator:Validator!
    // TODO: Constructor injection
    var loginService:LoginServiceProtocol = {
        return AppDelegate.defaultLoginService()
    }()
    
    @IBOutlet public weak var usernameField: UITextField!
    @IBOutlet public weak var passwordField: UITextField!
    @IBOutlet public weak var submitButton: UIButton!
    
    public override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = true
        
        formValidator = Validator()
        formValidator.registerField(passwordField, rules: [RequiredRuleWithMessage(message: "Password is required")])
        formValidator.registerField(usernameField, rules: [RequiredRuleWithMessage(message: "Username is required"),
            AuthenticatesRule(loginService: loginService, controller: self)])
        
        super.viewWillAppear(animated)
        
    }
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    class AuthenticatesRule : Rule {
        var loginService:LoginServiceProtocol!
        var controller:LoginViewController!
        
        init(loginService:LoginServiceProtocol, controller:LoginViewController) {
            self.loginService = loginService
            self.controller = controller
        }
        
        func validate(value: String) -> Bool {
            return loginService.AuthorizeCredentials(value, password: controller.passwordField.text)
        }
        
        func errorMessage() -> String {
            return "An account with that username and password combination was not found."
        }
    }
    
    @IBAction func loginTouchUpInside(sender: AnyObject) {
        attemptLogin(usernameField.text, password: passwordField.text)
    }
    
    func showAlert(message:String) {
        var alert = UIAlertController(title: "Validation Problems", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func makeAlertMessage(errors:[ValidationError]) -> String {
        let messages = errors.map { $0.errorMessage }
        return "\n".join(messages)
    }
    
    func attemptLogin(username:String, password:String) {
        var validates = false
        var message = ""
        formValidator.validate { (errors) -> Void in
            message = self.makeAlertMessage(errors.values.array)
            validates = errors.count == 0
        }
        
        if validates {
            performLogin(username)
        } else {
            showAlert(message)
        }
    }
    
    func performLogin(username:String) {
        showAlert("Logged in!")
    }
    
    func notifyOfFailedLogin(message:String) {
        showAlert(message)
    }
}

public class RequiredRuleWithMessage : RequiredRule {
    let customMessage:String?
    public init(message:String?) {
        customMessage = message
        super.init()
    }
    
    public override func errorMessage() -> String {
        if customMessage != nil {
            return customMessage!
        } else {
            return super.errorMessage()
        }
    }
}