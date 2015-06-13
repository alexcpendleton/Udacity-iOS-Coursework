//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Alex Pendleton on 6/9/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recordingInitiator: UIButton!
    @IBOutlet weak var recordingIndicator: UILabel!
    @IBOutlet weak var recordingStopper: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        setToDefaultViewState();
    }
    
    func setToDefaultViewState() {
        hideStopButton();
        hideRecordingIndicator();
        enableRecordingButton();
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func stopRecording(sender: UIButton) {
        enableRecordingButton();
        hideStopButton();
        hideRecordingIndicator();
        //performSegueWithIdentifier(<#identifier: String?#>, sender: <#AnyObject?#>)
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        // TODO: record the user's voice
        println("Record button pressed");
        startRecording();
    }
    
    func disableRecordingButton() {
        recordingInitiator.enabled = false;
    }
    
    func startRecording(){
        disableRecordingButton();
        showRecordingIndicator();
        showStopButton();
    }
    
    func showRecordingIndicator(){
        recordingIndicator.hidden = false;
    }
    
    func showStopButton() {
        recordingStopper.hidden = false;
    }
    
    func hideRecordingIndicator() {
        recordingIndicator.hidden = true;
    }
    
    func hideStopButton() {
        recordingStopper.hidden = true;
    }
    
    func enableRecordingButton() {
        recordingInitiator.enabled = true;
    }

}

