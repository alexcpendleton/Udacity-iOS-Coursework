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
    let pickerDelegate:UITextFieldDelegate = MemeTextFieldDelegate()
    let cameraDelegate:UITextFieldDelegate = MemeTextFieldDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        // Each has its own "edited" state, thus the separate instances
        // and not implementing the delegate here in the VC
        topTextField.delegate = pickerDelegate
        bottomTextField.delegate = cameraDelegate
        setAppearanceOfTextField(topTextField)
        setAppearanceOfTextField(bottomTextField)
    }
    
    func setAppearanceOfTextField(field:UITextField) {
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : 4.0
        ]
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
}