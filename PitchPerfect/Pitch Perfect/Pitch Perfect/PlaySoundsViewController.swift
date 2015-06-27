//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Alex Pendleton on 6/10/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import UIKit

class PlaySoundsViewController: UIViewController {
    
    @IBOutlet weak var darthVaderButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var playButtons:Array<UIButton> = [];
    var audioSource: RecordedAudio!;
    var player :ManipulatedAudioPlayer!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        playButtons += [fastButton, slowButton, chipmunkButton, darthVaderButton];
        stopButton.hidden = true;
        player = AVAudioPlayerManipulatedAudioPlayer();
        navigationController?.navigationBarHidden = false
    }
    func playingStoppedCallback() { // Callback for ManipulatedAudioPlayer finished playing
        stopPlayer()
    }
    
    @IBAction func playbackStopped(sender: UIButton) {
        stopPlayer();
    }
    
    func stopPlayer() {
        stopButton.hidden = true;
        player.stop();
    }
    
    func playAudio(sender: UIButton, rate: Float = 1.0, pitch: Float = 1.0) {
        stopButton.hidden = false;
        player.playAudio(audioSource.filePathUrl, rate: rate, pitch: pitch)
    }
    
    func audioFinishedHandler() {
        stopPlayer();
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
    }
    
    
}
