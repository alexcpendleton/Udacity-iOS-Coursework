//
//  ViewController.swift
//  UIKitFundamentals
//
//  Created by Alex Pendleton on 6/29/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var count = 0;
    var label:UILabel!;
    var otherLabel:UILabel!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label = UILabel();
        label.frame = CGRectMake(150, 150, 60, 60);
        otherLabel = UILabel();
        otherLabel.frame = CGRectMake(150, 210, 60, 60);
        updateLabelWithCurrentCount();
        
        self.view.addSubview(label);
        
        var incrementButton = UIButton();
        incrementButton.frame = CGRectMake(150, 250, 60, 60);
        incrementButton.setTitle("Increment", forState: .Normal);
        incrementButton.setTitleColor(UIColor.blueColor(), forState: .Normal);
        incrementButton.addTarget(self, action: "incrementCount", forControlEvents: UIControlEvents.TouchUpInside);
        incrementButton.sizeToFit();
        self.view.addSubview(incrementButton);
        
        var decrementButton = UIButton();
        decrementButton.frame = CGRectMake(150, 310, 60, 60);
        decrementButton.setTitle("Decrement", forState: .Normal);
        decrementButton.setTitleColor(UIColor.redColor(), forState: .Normal);
        decrementButton.addTarget(self, action: "decrementCount", forControlEvents: UIControlEvents.TouchUpInside);
        decrementButton.sizeToFit();
        self.view.addSubview(decrementButton);
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func decrementCount() {
        count--;
        updateLabelWithCurrentCount();
    }

    func incrementCount() {
        count++;
        updateLabelWithCurrentCount();
    }
    
    func changeBackgroundColor() {
        view.backgroundColor = UIColor(red:CGFloat(drand48()),
            green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha:1.0);
    }
    
    func updateLabelWithCurrentCount() {
        label.text = "\(self.count)";
        otherLabel.text = label.text;
        changeBackgroundColor();
    }

}

