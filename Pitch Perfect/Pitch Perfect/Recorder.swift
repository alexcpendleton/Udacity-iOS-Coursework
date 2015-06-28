//
//  Recorder.swift
//  Pitch Perfect
//
//  Created by Alex Pendleton on 6/27/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import AVFoundation

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
