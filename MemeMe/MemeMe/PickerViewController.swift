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

    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var memeViewContainer: UIView!
    
    var memeView: MemeView!
    
    var repo: MemeRepository!

    var sourceMeme: MemeModel = {
        // Default to these values if not otherwise set
         return MemeModel(top: "TOP", bottom: "BOTTOM", original: nil, applied: nil)
    }()
    
    
    internal var isInEditMode:Bool = true
    
    
    internal func enterEditMode() {
        setToolbarVisibility(false)
        setTextFieldsEnabled(true)
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    internal func enterViewMode() {
        setToolbarVisibility(true)
        setTextFieldsEnabled(false)
        navigationItem.leftBarButtonItem = editButton
        navigationItem.rightBarButtonItem = nil
    }
    
    func setTextFieldsEnabled(enabled:Bool) {
        memeView.setEditable(enabled)
    }
    
    internal func loadMeme(toLoad:MemeModel) {
        memeView.load(toLoad)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // I'd much rather be injecting this somehow but this seems like
        // the more "standard" and less painful way to put dependencies
        // into ViewControllers in Swift. A much more comfortable way would
        // be to use constructor injection.
        navigationController?.navigationBarHidden = false
        repo = AppDelegate.defaultMemeRepository()
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        shareButton.enabled = false
        
        subscribeToKeyboardNotifications()
        // Default state is "edit" mode, but it can be also be changed by the caller

        if isInEditMode {
            enterEditMode()
        } else {
            enterViewMode()
        }
        loadMeme(sourceMeme)
        navigationItem.hidesBackButton = true
    }
    func setup() {
        memeView = loadViewFromNib()
        
        memeViewContainer.frame = memeView.bounds
        memeViewContainer.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        memeView.imageView?.addObserver(self, forKeyPath: "image", options: nil, context: nil)
        memeViewContainer.addSubview(memeView)
    }
    
    func loadViewFromNib() -> MemeView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: MemeView.nibName, bundle: bundle)
        let result = nib.instantiateWithOwner(self, options: nil)[0] as! MemeView
        
        return result
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
    
    @IBAction func editPressed(sender:AnyObject!) {
        enterEditMode()
    }
    
    func presentImageViewer(sourceType:UIImagePickerControllerSourceType) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = sourceType
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func showImage(image:UIImage) {
        var mainImageView = memeView.imageView!
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
        var activityController = UIActivityViewController(activityItems: [model.appliedImage!], applicationActivities: nil)
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
        sourceMeme.topText = memeView.topTextField.text
        sourceMeme.bottomText = memeView.bottomTextField.text
        sourceMeme.originalImage = memeView.imageView.image!
        sourceMeme.appliedImage = generateAppliedImage()
        return sourceMeme
    }
    
    func save(model:MemeModel) {
        repo.persist(model)
        presentPastMemes()
    }
    
    func presentPastMemes() {
        if let target = storyboard?.instantiateViewControllerWithIdentifier("PastMemesTabs") as? UIViewController {
            navigationController?.pushViewController(target, animated: true)
        }
    }
}
