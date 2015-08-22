//
//  MemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Alex Pendleton on 8/10/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit

public class MemeTextFieldDelegate : NSObject, UITextFieldDelegate {
    var hasChanged:Bool = false
    public var capitalizeAfterEdit = true
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        if(!hasChanged) {
            textField.text = "";
            hasChanged = true
        }
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        if capitalizeAfterEdit {
            textField.text = textField.text.uppercaseString
        }
    }
}