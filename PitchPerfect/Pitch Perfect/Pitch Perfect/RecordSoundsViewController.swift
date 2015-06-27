//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Alex Pendleton on 6/9/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingInitiator: UIButton!
    @IBOutlet weak var recordingIndicator: UILabel!
    @IBOutlet weak var recordingStopper: UIButton!
    @IBOutlet weak var recordingInstructions: UILabel!

    var recorder : Recorder!;
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        setToDefaultViewState();
    }
    
    func setToDefaultViewState() {
        hideStopButton();
        hideRecordingIndicator();
        enableRecordingButton();
        navigationController?.navigationBarHidden = true;
        recordingInstructions.hidden = false;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recorder = Recorder(delegate: self)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        recorder.stopRecording();
        enableRecordingButton();
        hideStopButton();
        hideRecordingIndicator();
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        startRecording();
    }
    
    func disableRecordingButton() {
        recordingInitiator.enabled = false;
    }
    
    func startRecording(){
        disableRecordingButton();
        showRecordingIndicator();
        showStopButton();
        recorder.startRecording();
        recordingInstructions.hidden = true;
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
    var recordingFinishedSegueIdentifier = "recordingFinished";
    func audioRecorderDidFinishRecording(avRecorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag) {
            // Save the recorded audio
            var result = RecordedAudio(avAudioRecorder.url, avRecorder.url.lastPathComponent);
            // Segue to modifier screen
            performSegueWithIdentifier(recordingFinishedSegueIdentifier, sender: result)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // TODO: This smells. How does one manage segue identifiers in a non-trivial app?
        if(segue.identifier == recordingFinishedSegueIdentifier) {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController;
            playSoundsVC.audioSource = sender as! RecordedAudio;
        }
    }
}

