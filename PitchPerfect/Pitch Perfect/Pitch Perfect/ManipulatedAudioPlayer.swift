//
//  ManipulatedAudioPlayer.swift
//  Pitch Perfect
//
//  Created by Alex Pendleton on 6/25/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import Foundation
// Represents an object that can manipulate the qualities of an audio file
// loaded from a URL. This is to support multiple methods of playing a file,
// specifically via an AVAudioPlayer, or alternatively the AVAudioEngine.
// This is because AVAudioPlayer doesn't support pitch or other effects,
// and AVAudioEngine's completionHandlers do not work as expected.
protocol ManipulatedAudioPlayer {
    // Theoretically executed when the sound is finished player.
    var finishedCallback :()->Void! { get set };
    // Loads and plays the specified audio file at a certain rate and pitch.
    func playAudio(url: NSURL!, rate: Float, pitch: Float);
    // Stops the playing of the audio file.
    func stop();
}