//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Alex Pendleton on 6/10/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import UIKit
import AVFoundation
class AVAudioFileManipulatedAudioPlayer : ManipulatedAudioPlayer {
    var finishedCallback :()->Void!;
    init() {
        finishedCallback = { return; };
    }
    func playAudio(url: NSURL!, rate: Float, pitch: Float) {
    }
    func stop() {
        
    }
}

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

        var amountPlayed: Int32;
        println("frameCapacity: " + frameCapacity.description);
        playerNode.installTapOnBus(0, bufferSize: frameCapacity, format: format) {
            (buffer: AVAudioPCMBuffer!, time: AVAudioTime!) -> Void in
            println("now: " + NSDate().description);
            println("buffer.frameCapacity: " + buffer.frameCapacity.description);
            println("buffer.frameLength: " + buffer.frameLength.description);
            println("playing? " + self.playerNode.playing.description);
            println("time: " + time.description);
            
            // why does this work? because perhaps the smaller buffer is reused by the audioengine, with the code to dump new data into the block just using the block size as set here?
            // I am not sure that this is supported by apple?
            //NSLog(@"buffer frame length %d", (int)buffer.frameLength);

            var frames:UInt32! = 0;
            //NSLog(@"number of buffers: %d", buffer.audioBufferList[0].mNumberBuffers.description);
            //NSLog(@"%d frames are sent at %lf", (int) frames, [AVAudioTime secondsForHostTime:[when hostTime]] - start);
        }
        engine.prepare();
        engine.startAndReturnError(nil);
        
        playerNode.play();
        
        self.finishedCallback();
        
    }
}

protocol ManipulatedAudioPlayer {
    var finishedCallback :()->Void! { get set };
    func playAudio(url: NSURL!, rate: Float, pitch: Float);
    func stop();
}
protocol ManipulatedAudioPlayerDelegate {
    func playingStopped();
}
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
        player = AVEngineManipulatedAudioPlayer();
        player.finishedCallback = { self.playingStoppedCallback() };
    }
    func playingStoppedCallback() { // Callback for ManipulatedAudioPlayer finished playing
        stopPlayerAndReenable()
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
        setEnabledForPlayButtonsExcept(sender, status: false);
        stopButton.hidden = false;
        player.playAudio(audioSource.filePathUrl, rate: rate, pitch: pitch)
    }
    
    func audioFinishedHandler() {
        println("audio finished handler.start");
        stopPlayerAndReenable();
        println("audio finished handler.end");
    }
    func stopPlayer() {
        player.stop();
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
