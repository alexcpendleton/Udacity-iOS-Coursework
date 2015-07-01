//
//  ViewController.swift
//  Color Sliders
//
//  Created by Alex Pendleton on 6/30/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var colorView:UIView!;
    @IBOutlet var redSlider:UISlider!;
    @IBOutlet var greenSlider:UISlider!;
    @IBOutlet var blueSlider:UISlider!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        colorView.layer.borderWidth = 5;
        colorView.layer.borderColor = UIColor.blackColor().CGColor;
        
        // Load it up for the first time
        setColorViewToSliderValues();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func sliderChanged() {
        setColorViewToSliderValues();
    }

    func cgf(sender:UISlider!) -> CGFloat {
        return CGFloat(sender.value);
    }
    func setColorViewToSliderValues() {
        colorView.backgroundColor = UIColor(red: cgf(redSlider), green: cgf(greenSlider), blue: cgf(blueSlider), alpha: 1.0)
    }

}

