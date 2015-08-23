//
//  ViewController.swift
//  FlickFinder
//
//  Created by Alex Pendleton on 8/23/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import UIKit

class FlickFinderViewController: UIViewController {

    @IBOutlet weak var displayedImage: UIImageView!
    @IBOutlet weak var termsField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    @IBOutlet weak var searchByTermsButton: UIButton!
    @IBOutlet weak var searchByLocationButton: UIButton!
    @IBOutlet weak var resultsDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func searchByTermsPressed(sender: AnyObject) {
    }
    
    @IBAction func searchByLocationPressed(sender: AnyObject) {
    }
    
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    func adjustFrameForKeyboardForCertainResponders(notification: NSNotification, modifier: CGFloat) {
        adjustFrameForKeyboard(notification, modifier: modifier)
    }
    
    func adjustFrameForKeyboard(notification: NSNotification, modifier: CGFloat) {
        self.view.frame.origin.y += (getKeyboardHeight(notification) * modifier)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        adjustFrameForKeyboardForCertainResponders(notification, modifier: -1)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        adjustFrameForKeyboardForCertainResponders(notification, modifier: +1)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

}

