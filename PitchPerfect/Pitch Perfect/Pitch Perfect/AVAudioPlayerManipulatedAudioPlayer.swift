//
//  AVAudioPlayerManipulatedAudioPlayer.swift
//  Pitch Perfect
//
//  Created by Alex Pendleton on 6/25/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import AVFoundation

class AVAudioPlayerManipulatedAudioPlayer : NSObject, ManipulatedAudioPlayer, AVAudioPlayerDelegate {
    var finishedCallback :()->Void!;
    var player: AVAudioPlayer!;
    var alternativePitchPlayer: AVEngineManipulatedAudioPlayer!;
    override init() {
        finishedCallback = { return; };
        // The AVAudioPlayer doesn't support pitch, so we can use the other player
        // instead, while still adhering somewhat to the requirement that I use
        // the AVAudioPlayer's delegate. See the notes about the bugs I encountered
        // in that file.
        alternativePitchPlayer = AVEngineManipulatedAudioPlayer();
    }
    
    func playAudio(url: NSURL!, rate: Float, pitch: Float) {
        stop();
        if(pitch != 1.0) {
            alternativePitchPlayer.playAudio(url, rate: rate, pitch: pitch);
        } else {
            var mainBundle = NSBundle.mainBundle();
            player = AVAudioPlayer(contentsOfURL: url, error: nil);
            
            player.enableRate = true;
            player.rate = rate;
            player.delegate = self;
            player.prepareToPlay();
            player.play();
        }
    }
    func audioPlayerDidFinishPlaying(source: AVAudioPlayer,
        successfully flag: Bool) {
            finishedCallback();
    }
    func stop() {
        stopPlayer();
        finishedCallback();
    }
    
    func stopPlayer() {
        if(player != nil) {
            player.stop();
            player.currentTime = 0;
        }
        if(alternativePitchPlayer != nil) {
            alternativePitchPlayer.stop();
        }
    }
}
