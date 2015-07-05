//
//  ResultsViewController.swift
//  RockPaperScissors
//
//  Created by Alex Pendleton on 7/3/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit


public class ResultsViewController : UIViewController {
    public var results:ResultsModel!;
    
    @IBOutlet weak var resultsShoutoutLabel: UILabel!
    @IBOutlet weak var yourPick: UIImageView!
    @IBOutlet weak var theirPick: UIImageView!
    @IBOutlet weak var playAgainButton: UIButton!


    @IBAction func playAgainPressed(sender: UIButton) {
        goBackFromStoryboard()
    }
    
    func goBackFromStoryboard() {
        if let matchView = self.storyboard?.instantiateViewControllerWithIdentifier("MatchViewController") as? MatchViewController
        {
            presentViewController(matchView, animated: true, completion: nil)
        }
    }
    
    func setPlayerImage(target:UIImageView, index:Int) {
        target.image = UIImage(named: results!.handsInOrder[index].imageAssetName)
    }
    
    func setResultsShoutout() {
        var resultWord = "circumvented the game";
        
        switch (results.winnerIndex) {
        case .None:
            resultWord = "tied"
        case .Some(0):
            resultWord = "won"
        default:
            resultWord = "lost"
        }
        resultsShoutoutLabel.text = "You \(resultWord)!"
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        if(results != nil) {
            setPlayerImage(yourPick, index: 0)
            setPlayerImage(theirPick, index: 1)
            
            setResultsShoutout()
        }
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}