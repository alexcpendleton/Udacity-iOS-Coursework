//
//  SentMemesTabViewController.swift
//  MemeMe
//
//  Created by Alex Pendleton on 8/19/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit

public class SentMemesTabViewController : UITabBarController {
    
    public override func viewDidAppear(animated: Bool) {
        var addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "makeANewMeme")
        navigationItem.rightBarButtonItem = addButton
    }

    func makeANewMeme() {
        // Use a nil to use the "empty" version
        let toLoad: MemeModel? = nil
        PastMemesViewController.presentEditMeme(toLoad,
            storyboard: storyboard, navigationController: navigationController)
    }
    
    @IBAction func makeAMemePressed(sender:AnyObject!) {
        makeANewMeme()
    }
    
}