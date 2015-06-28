//
//  AVEngineManipulatedAudioPlayer.swift
//  Pitch Perfect
//
//  Created by Alex Pendleton on 6/25/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import AVFoundation

class AVEngineManipulatedAudioPlayer : ManipulatedAudioPlayer  {
    var finishedCallback :()->Void!;
    var engine: AVAudioEngine!;
    var playerNode: AVAudioPlayerNode!;
    
    init() {
        engine = AVAudioEngine();
        finishedCallback = { return; };
    }
    func stop() {
        if((engine) != nil) {
            engine.stop();
            engine.reset();
        }
    }
    func playAudio(url: NSURL!, rate: Float, pitch: Float) {
        stop();
        var audioFile = AVAudioFile(forReading:url, error:nil)
        playerNode = AVAudioPlayerNode();
        
        var changePitchEffect = AVAudioUnitTimePitch();
        changePitchEffect.pitch = pitch;
        changePitchEffect.rate = rate;
        
        engine.attachNode(playerNode);
        engine.attachNode(changePitchEffect);
        
        engine.connect(playerNode, to: changePitchEffect, format: nil);
        engine.connect(changePitchEffect, to: engine.outputNode, format:nil);
        
        
        /* I intentionally got rid of the separate method for playing audio that could
        only accept a rate, which used the AVAudioPlayer with a delegate. However, this
        completion handler accomplishes effectively the same thing. I did implement it
        that way originally, but having multiple methods that do slightly different things
        just smelled wrong to me, especially since this way accepts a rate. Additionally,
        I encountered what seems to be a bug in the scheduleFile method where the
        completionHandler is fired immediately rather than when the file finishes playing.
        A solution I discovered was to use the scheduleBuffer method instead. I've left both
        approaches here if you wish to see for yourself.
        Trying that seemed to have the same result.
        
        I'm sort of at a loss now.
        
        More updates: I've even found what seems to be some sort of Udacity forum archive
        with people trying and failing at the same thing I am. This is both reassuring
        and incredibly disheartening.
        http://webmaps.mammothmapping.com/t/questions-for-lesson-4b/38/17
        
        */
        var useBufferInsteadOfFile = false;
        var frameCapacity : AVAudioFrameCount = UInt32(audioFile.length);
        var format : AVAudioFormat! = audioFile.processingFormat;
        if(useBufferInsteadOfFile) {
            //var format = audioFile.processingFormat
            //var audioFrameCount = UInt32(audioFile.length)
            var bufferToPlay = AVAudioPCMBuffer(PCMFormat: format, frameCapacity: frameCapacity)
            playerNode.scheduleBuffer(bufferToPlay, completionHandler: {
                return
                self.finishedCallback();
            });
        } else {
            playerNode.scheduleFile(audioFile, atTime: nil, completionHandler: {
                return
                self.finishedCallback();
            });
        }
        
        engine.prepare();
        engine.startAndReturnError(nil);
        playerNode.play();
        
        self.finishedCallback();
        
    }
}
