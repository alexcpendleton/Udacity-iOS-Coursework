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
    @IBOutlet var label:UILabel!;
    @IBOutlet var otherLabel:UILabel!;
    @IBOutlet var incrementButton:UIButton!;
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabelWithCurrentCount();
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func decrementCount() {
        count--;
        updateLabelWithCurrentCount();
    }

    @IBAction func incrementCount() {
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

