//
//  ResultsModel.swift
//  RockPaperScissors
//
//  Created by Alex Pendleton on 7/3/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import Foundation

public class ResultsModel {
    public init(winnerIndex:Int?, handsInOrder:[PlayableHand]) {
        self.winnerIndex = winnerIndex;
        self.handsInOrder = handsInOrder;
    }
    public var winnerIndex:Int?;
    public var handsInOrder:[PlayableHand];
}