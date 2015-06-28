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

    @IBOutlet weak var slowButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func playSlowly(sender: UIButton) {
        println("Slow playback button pressed.");
        var mainBundle = NSBundle.mainBundle();
        if var filePath = mainBundle.pathForResource("movie_quote", ofType:"mp3") {
            var url = NSURL.fileURLWithPath(filePath);
            var player = AVAudioPlayer(contentsOfURL: url, error: nil);
            //player.prepareToPlay();
            player.play();
        } else {
            println("movie_quote.mp3 not found");
        }
        
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
