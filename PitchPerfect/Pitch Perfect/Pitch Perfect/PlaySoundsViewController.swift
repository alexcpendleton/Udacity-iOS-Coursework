//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Alex Pendleton on 6/10/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    var playButtons:Array<UIButton> = [];
    var player: AVAudioPlayer!
    var audioSource: RecordedAudio!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        playButtons += [fastButton, slowButton];
        stopButton.hidden = true;
        
    }
    
    @IBAction func playbackStopped(sender: UIButton) {
        stopPlayerAndReenable();
    }
    
    @IBAction func stopPlayerAndReenable() {
        stopPlayer();
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
    
    
    func playAudio(rate: Float, sender: UIButton) {
        setEnabledForPlayButtonsExcept(sender, status: false);
        
        if(player == nil) {
            let url = audioSource.filePathUrl;
            player = AVAudioPlayer(contentsOfURL: url, error: nil);

        }
        stopPlayer();
        stopButton.hidden = false;
        player.enableRate = true;
        player.rate = rate;
        player.delegate = self;
        player.prepareToPlay();
        player.play();
    }
    
    func audioPlayerDidFinishPlaying(AVAudioPlayer!, successfully: Bool) {
        stopPlayerAndReenable()
    }
    
    func stopPlayer() {
        if(player == nil) {
            return;
        }
        player.stop();
        player.currentTime = 0;
    }
    
    @IBAction func playQuickly(sender: UIButton) {
        playAudio(1.5, sender: sender);
    }
    
    @IBAction func playSlowly(sender: UIButton) {
        playAudio(0.5, sender: sender)
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
