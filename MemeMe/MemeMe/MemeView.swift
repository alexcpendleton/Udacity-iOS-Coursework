//
//  MemeView.swift
//  MemeMe
//
//  Created by Alex Pendleton on 8/20/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit

public class MemeView : UIView {
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomTextField: UITextField!
    
    var container:UIView!
    public static var nibName = "MemeView"
    
    override init(frame: CGRect) {
        // properties
        super.init(frame: frame)
        
        // Set anything that uses the view or visible bounds
        setup()
    }
    
    required public init(coder aDecoder: NSCoder) {
        // properties
        super.init(coder: aDecoder)
        
        // Setup
        setup()
    }

    func setup() {
        
    }
    var topTextFieldDelegate = MemeTextFieldDelegate()
    var bottomTextFieldDelegate = MemeTextFieldDelegate()
    
    public override func drawRect(rect: CGRect) {
        
        // Each has its own "edited" state, thus the separate instances
        // and not implementing the delegate here in the VC
        topTextField.delegate = topTextFieldDelegate
        bottomTextField.delegate = bottomTextFieldDelegate
        super.drawRect(rect)
    }
    
    
    public func load(toLoad:MemeModel) {
        load(toLoad.topText, bottomText: toLoad.bottomText, image: toLoad.originalImage)
    }
    
    public func setEditable(editable:Bool) {
        topTextField.enabled = editable
        bottomTextField.enabled = editable
    }
    
    public func load(topText:String, bottomText:String, image:UIImage?) {
        topTextField.text = topText
        bottomTextField.text = bottomText
        imageView.image = image
    }
    
    func setAppearanceOfTextField(field:UITextField) {
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            //NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : 4.0,
        ]
        //field.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        //field.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        //field.textAlignment = NSTextAlignment.Center
        field.defaultTextAttributes = memeTextAttributes
    }
}