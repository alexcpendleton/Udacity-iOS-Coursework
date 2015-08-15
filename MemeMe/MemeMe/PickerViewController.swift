//
//  ViewController.swift
//  MemeMe
//
//  Created by Alex Pendleton on 8/10/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var pickerButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var persister: SharedMemePersister!
    
    let pickerDelegate:UITextFieldDelegate = MemeTextFieldDelegate()
    let cameraDelegate:UITextFieldDelegate = MemeTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // I'd much rather be injecting this somehow but this seems like
        // the more "standard" and less painful way to put dependencies
        // into ViewControllers in Swift. A much more comfortable way would
        // be to use constructor injection.
        navigationController?.navigationBarHidden = false
        persister = SharedMemePersister.defaultPersister()
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        shareButton.enabled = false
        
        // Each has its own "edited" state, thus the separate instances
        // and not implementing the delegate here in the VC
        topTextField.delegate = pickerDelegate
        bottomTextField.delegate = cameraDelegate
        
        setAppearanceOfTextField(topTextField)
        setAppearanceOfTextField(bottomTextField)
        
        subscribeToKeyboardNotifications()
        
        mainImageView.addObserver(self, forKeyPath: "image", options: nil, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "image" {
            shareButton.enabled = true
        }
    }
    
    func notificationCenter() -> NSNotificationCenter {
        return NSNotificationCenter.defaultCenter()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        notificationCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    func adjustFrameForKeyboard(notification: NSNotification, modifier: CGFloat) {
        self.view.frame.origin.y += (getKeyboardHeight(notification) * modifier)
    }
    
    func setToolbarVisibility(hidden: Bool) {
        toolbar.hidden = hidden
    }
    
    func setVisibilityOfTertiaryElements(hidden: Bool) {
        setToolbarVisibility(hidden)
        navigationController?.navigationBarHidden = hidden
    }
    
    func keyboardWillShow(notification: NSNotification) {
        adjustFrameForKeyboard(notification, modifier: -1)
        setToolbarVisibility(true)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        adjustFrameForKeyboard(notification, modifier: +1)
        setToolbarVisibility(false)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func setAppearanceOfTextField(field:UITextField) {
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : 4.0,
        ]
        field.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        field.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        //field.textAlignment = NSTextAlignment.Center
        field.defaultTextAttributes = memeTextAttributes
    }

    @IBAction func pickerPressed(sender:AnyObject!) {
        // Question for reviewer (or later research):
        // A lot of apps these days have an image picker that includes the photo 
        // library and the camera in one. Is this a built-in thing that isn't
        // covered by this course, or do individual app devs write their own
        // custom view controllers? Google+, Instagram, and Facebook all have
        // something like this.
        presentImageViewer(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func cameraPressed(sender:AnyObject!) {
        presentImageViewer(UIImagePickerControllerSourceType.Camera)
    }
    
    @IBAction func cancelPressed(sender:AnyObject!) {
        presentPastMemes()
    }

    func presentImageViewer(sourceType:UIImagePickerControllerSourceType) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = sourceType
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func showImage(image:UIImage) {
        mainImageView.contentMode = UIViewContentMode.ScaleAspectFit
        mainImageView.image = image
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            showImage(image)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    internal func generateAppliedImage() -> UIImage {
        setVisibilityOfTertiaryElements(true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let result : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        setVisibilityOfTertiaryElements(false)
        return result
    }
    
    @IBAction func sharePressed(sender: AnyObject!) {
        let model = buildModelFromScreen()
        var activityController = UIActivityViewController(activityItems: [model.appliedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.save(model)
            }
        }
        // The completion handler passed to presentViewController gets called 
        // before the view is dismissed, unlike the documentation suggests.
        // Using the completionWithItemsHandler works much better.
        presentViewController(activityController, animated: true, completion:nil)
    }
    
    func buildModelFromScreen() -> MemeModel {
        return MemeModel(top: topTextField.text!, bottom:bottomTextField.text!,
            original: mainImageView.image!, applied: generateAppliedImage())
    }
    
    func save(model:MemeModel) {
        persister.persist(model)
        presentPastMemes()
    }
    
    func presentPastMemes() {
        if let target = storyboard?.instantiateViewControllerWithIdentifier("PastMemes") as? PastMemesViewController {
            navigationController?.pushViewController(target, animated: true)
        }
    }
}
