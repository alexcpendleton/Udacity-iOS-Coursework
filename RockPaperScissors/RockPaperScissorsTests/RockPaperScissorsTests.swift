//
//  RockPaperScissorsTests.swift
//  RockPaperScissorsTests
//
//  Created by Alex Pendleton on 7/3/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import UIKit
import XCTest
import RockPaperScissors

class RockPaperScissorsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRockBeatsScissors() {
        var decider = MatchDecider()
        var result = decider.decideWinner(Rock(), hand2: Scissors());
        XCTAssert(result == 0)
        var result2 = decider.decideWinner(Scissors(), hand2: Rock());
        XCTAssert(result2 == 1);
    }
    
    func testPaperBeatsRock() {
        var decider = MatchDecider()
        var result = decider.decideWinner(Paper(), hand2: Rock());
        XCTAssert(result == 0)
        var result2 = decider.decideWinner(Rock(), hand2: Paper());
        XCTAssert(result2 == 1);
    }
    
    func testScissorsBeatsPaper() {
        var decider = MatchDecider()
        var result = decider.decideWinner(Scissors(), hand2: Paper());
        XCTAssert(result == 0)
        var result2 = decider.decideWinner(Paper(), hand2: Scissors());
        XCTAssert(result2 == 1);
    }
    
    func testTieReturnsNil() {
        var decider = MatchDecider()
        var result = decider.decideWinner(Scissors(), hand2: Scissors());
        XCTAssert(result == nil)
        var result2 = decider.decideWinner(Paper(), hand2: Paper());
        XCTAssert(result2 == nil);
        var result3 = decider.decideWinner(Rock(), hand2: Rock());
        XCTAssert(result3 == nil);
        
    }
    
}
