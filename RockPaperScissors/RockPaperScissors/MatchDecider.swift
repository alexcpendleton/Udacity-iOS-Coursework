//
//  MatchDecider.swift
//  RockPaperScissors
//
//  Created by Alex Pendleton on 7/3/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import Foundation

public class MatchDecider : NSObject {
    public func decideWinner(hand1:PlayableHand!, hand2:PlayableHand!) -> Int? {
        var rock = Rock();
        var paper = Paper();
        var scissors = Scissors();
        
        if(hand1.identifier == hand2.identifier) {
            return nil;
        }
        println("hand1: \(hand1.identifier) : hand2: \(hand2.identifier)");
        if (hand1.identifier == rock.identifier) {
            return hand2.identifier == paper.identifier ? 1 : 0;
        }
        else if (hand1.identifier == paper.identifier) {
            return hand2.identifier == rock.identifier ? 0 : 1;
        }
        // hand1 is scissors
        return hand2.identifier == rock.identifier ? 1 : 0;
    }
}

public protocol PlayableHand {
    var identifier:String { get }
    var displayName:String { get }
    var imageAssetName:String { get }
}

public class Rock : NSObject, PlayableHand {
    public override init(){ }
    public var identifier:String { get { return "Rock" } }
    public var displayName:String { get { return identifier } }
    public var imageAssetName:String { get { return identifier } }
    public override var description : String { return identifier }
}

public class Paper: NSObject, PlayableHand {
    public override init(){ }
    public var identifier:String { get { return "Paper" } }
    public var displayName:String { get { return identifier } }
    public var imageAssetName:String { get { return identifier } }
    public override var description : String { return identifier }
}

public class Scissors: NSObject, PlayableHand {
    public override init(){ }
    public var identifier:String { get { return "Scissors" } }
    public var displayName:String { get { return identifier } }
    public var imageAssetName:String { get { return identifier } }
    public override var description : String { return identifier }
}