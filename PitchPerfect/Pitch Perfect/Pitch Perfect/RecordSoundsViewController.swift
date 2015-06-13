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
    
    var recorder : Recorder!;
    
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
        recorder.startRecording();
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
    func audioRecorderDidFinishRecording(avRecorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag) {
            // Save the recorded audio
            var result = RecordedAudio();
            result.filePathUrl = avRecorder.url;
            result.title = avRecorder.url.lastPathComponent;
            // Segue to modifier screen
            performSegueWithIdentifier("recordingFinished", sender: result)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // TODO: This smells. How does one manage segue identifiers in a non-trivial app?
        if(segue.identifier == "recordingFinished") {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController;
            playSoundsVC.audioSource = sender as! RecordedAudio;
        }
    }
    internal class Recorder : NSObject {
        internal init(delegate: AVAudioRecorderDelegate!) {
            finishedDelegate = delegate;
        }
        var finishedDelegate : AVAudioRecorderDelegate! = nil;
        var audioRecorder:AVAudioRecorder!;
        func stopRecording() {
            if(audioRecorder != nil) {
                audioRecorder.stop();
                AVAudioSession.sharedInstance().setActive(false, error: nil)
            }
        }
        func startRecording() {
            println("Recorder.startRecording");
            var filePath = buildOutputPath()
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
            
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.meteringEnabled = true
            audioRecorder.delegate = finishedDelegate;
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            
        }
        
        func buildOutputPath() -> NSURL? {
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
            // Intentionally chose to use a single output path as not to clutter up
            // the data directory. This app doesn't handle multiple files anyway.
            let recordingName = "PitchPerfectOutput.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            return filePath;
        }
        
    }
}

