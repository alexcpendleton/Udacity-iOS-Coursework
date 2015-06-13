//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Alex Pendleton on 6/10/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    @IBOutlet weak var darthVaderButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    var playButtons:Array<UIButton> = [];
    
    var audioSource: RecordedAudio!;
    
    var engine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var playerNode:AVAudioPlayerNode!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        playButtons += [fastButton, slowButton, chipmunkButton, darthVaderButton];
        stopButton.hidden = true;
        
    }
    
    @IBAction func playbackStopped(sender: UIButton) {
        stopPlayerAndReenable();
    }
    
    func stopPlayerAndReenable() {
        setEnabledForPlayButtonsExcept(nil, status: true);
        stopButton.hidden = true;
    }
    
    func setEnabledForPlayButtonsExcept(except: UIButton?, status: Bool) {
        for singleButton in playButtons {
            singleButton.enabled = status;
        }
        if(except != nil) {
            except!.enabled = !status;
        }
        
    }
    
    
    func playAudio(sender: UIButton, rate: Float = 1.0, pitch: Float = 1.0) {
        
        engine = AVAudioEngine();
        audioFile = AVAudioFile(forReading:audioSource.filePathUrl, error:nil);
        playerNode = AVAudioPlayerNode();
        
        setEnabledForPlayButtonsExcept(sender, status: false);
    
        var changePitchEffect = AVAudioUnitTimePitch();
        changePitchEffect.pitch = pitch;
        changePitchEffect.rate = rate;

        engine.attachNode(playerNode);
        engine.attachNode(changePitchEffect);
        
        engine.connect(playerNode, to: changePitchEffect, format: nil);
        engine.connect(changePitchEffect, to: engine.outputNode, format:nil);
        
        playerNode.scheduleFile(audioFile, atTime: nil, completionHandler: audioFinishedHandler)
        engine.startAndReturnError(nil);
        
        stopButton.hidden = false;
        playerNode.play();
    }
    
    func audioFinishedHandler() {
        stopPlayerAndReenable();
    }
    func stopPlayer() {
        engine.stop();
    }
    
    @IBAction func playQuickly(sender: UIButton) {
        playAudio(sender, rate:1.5);
    }
    
    @IBAction func playSlowly(sender: UIButton) {
        playAudio(sender, rate:0.5)
    }
    @IBAction func playChipmunkly(sender: UIButton) {
        playAudio(sender, pitch:2400)
    }
    @IBAction func playVaderly(sender: UIButton) {
        playAudio(sender, pitch:-2400);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
