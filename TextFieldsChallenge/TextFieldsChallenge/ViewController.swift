//
//  ViewController.swift
//  TextFieldsChallenge
//
//  Created by Alex Pendleton on 7/4/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var zip: UITextField!
    @IBOutlet weak var cash: UITextField!
    @IBOutlet weak var lockable: UITextField!
    @IBOutlet weak var locker: UISwitch!
    
    var zipDelegate: ZipCodeDelegate?;
    var cashDelegate: UITextFieldDelegate?;
    var lockableDelegate: UITextFieldDelegate?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        zipDelegate = ZipCodeDelegate();
        cashDelegate = CurrencyFormatDelegate();
        lockableDelegate = LockableDelegate(locker: locker);
        
        zip.delegate = zipDelegate;
        cash.delegate = cashDelegate;
        lockable.delegate = lockableDelegate;
        cash.delegate!.textField!(cash, shouldChangeCharactersInRange: NSRange(location: 0, length: 0), replacementString: "0")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

public class ZipCodeDelegate : NSObject, UITextFieldDelegate {
    public override init() {
        charsetDelegate = CharsetRestrictedDelegate(charset: CharsetRestrictedDelegate.digitsCharset)
        maxLengthDelegate = MaxLengthDelegate()
    }
    
    var charsetDelegate:CharsetRestrictedDelegate;
    var maxLengthDelegate:MaxLengthDelegate;
    
    public func textField(textField: UITextField,
        shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool {
            return maxLengthDelegate.textField(textField, shouldChangeCharactersInRange: range, replacementString: string)
                && charsetDelegate.textField(textField, shouldChangeCharactersInRange: range, replacementString: string);
    }
}


public class CharsetRestrictedDelegate : NSObject, UITextFieldDelegate {
    public init(charset:NSCharacterSet) {
        self.charset = charset;
    }
    public let charset: NSCharacterSet;
    
    static let digitsCharset = NSCharacterSet(charactersInString:"0123456789");
    
    public func textField(textField: UITextField,
        shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool {
            //http://stackoverflow.com/questions/27215495/limit-uitextfield-input-to-numbers-in-swift
            // Create an `NSCharacterSet` set which includes everything *but* the digits
            let inverseSet = charset.invertedSet
            
            // At every character in this "inverseSet" contained in the string,
            // split the string up into components which exclude the characters
            // in this inverse set
            let components = string.componentsSeparatedByCharactersInSet(inverseSet)
            
            // Rejoin these components
            let filtered = join("", components)
            
            // If the original string is equal to the filtered string, i.e. if no
            // inverse characters were present to be eliminated, the input is valid
            // and the statement returns true; else it returns false
            return string == filtered
            
    }
}

public class MaxLengthDelegate : NSObject, UITextFieldDelegate {
    
    override public init() {
        
    }
    
    public var maxLength:Int = 5;

    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return range.location < maxLength
    }
    
}

public class CurrencyFormatDelegate : NSObject, UITextFieldDelegate {
    
    override public init() {
        var chars = NSMutableCharacterSet(charactersInString: "$.0123456789")
        //chars.formUnionWithCharacterSet("$.0123456789");
        charsetDelegate = CharsetRestrictedDelegate(charset: chars)
    }
    
    var charsetDelegate:CharsetRestrictedDelegate;
    var numberValue:Double = 0;
    
    public func textField(textField: UITextField,
        shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool {
            let allValid = charsetDelegate.textField(textField, shouldChangeCharactersInRange: range, replacementString: string);
            if(allValid) {
                var defaultValue = "$0.00"
                var reader = NSNumberFormatter()
                reader.numberStyle = .CurrencyStyle
                
                var currentText = textField.text as String
                if (count(currentText) == 0) {
                    currentText = defaultValue
                }
                // Turn it into an int, we don't care about the $ or decimals
                var currentAsInt = reader.numberFromString(currentText)!.integerValue
                var currentIntAsString = currentAsInt.description as String
                var outputString = ""
                // We want to take the next digit and append it to the end of the string
                // Or if it was a backspace then chop off the last digit
                // (Backspace will have an empty replacement string)
                
                
                let appending:Bool = count(string) > 0;
                if (appending) {
                    let nextDigit = string;
                    outputString = currentIntAsString + nextDigit;
                } else {
                    outputString = currentIntAsString.substringToIndex(currentIntAsString.endIndex.predecessor())
                }
                if(count(outputString) == 0) {
                    outputString = "0"
                }
                
                var normalReader = NSNumberFormatter()
                normalReader.numberStyle = .NoStyle
                // Here we're just reading an int, not a formatted currency
                if let outputNumber = normalReader.numberFromString(outputString) {                    var writer = NSNumberFormatter()
                    writer.numberStyle = .CurrencyStyle
                    
                    let outputText = writer.stringFromNumber(outputNumber)
                    textField.text = outputText
                }
                
                /*
                var massaged = currentText.stringByReplacingCharactersInRange(range, withString: string) as NSString
                
                var currencyReader = NSNumberFormatter();
                currencyReader.numberStyle = .CurrencyStyle;
                
                if let outputNumber = reader.numberFromString(massaged as String) {                    var writer = NSNumberFormatter()
                    writer.numberStyle = .CurrencyStyle
                    
                    let outputText = writer.stringFromNumber(otherNumber)
                    textField.text = outputText
                }
*/
            }
            return false;
    }
    
    
}

public class LockableDelegate : NSObject, UITextFieldDelegate {
    public init(locker:UISwitch) {
        self.locker = locker;
    }
    public var locker:UISwitch;
    
    public func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return locker.on;
    }
}




