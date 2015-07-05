//
//  ViewController.swift
//  ExistingVCPresenter
//
//  Created by Alex Pendleton on 7/2/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var presenter: UIButton!

    @IBAction func presenterClicked(sender:UIButton!) {
        presentPicker();
    }
    
    func presentPicker() {
        var picker = UIImagePickerController()
        presentViewController(picker, animated: true, completion: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

