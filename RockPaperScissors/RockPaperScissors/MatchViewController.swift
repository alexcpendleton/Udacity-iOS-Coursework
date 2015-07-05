//
//  MatchViewController.swift
//  RockPaperScissors
//
//  Created by Alex Pendleton on 7/3/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import UIKit

class MatchViewController: UIViewController {

    @IBOutlet weak var rockButton: UIButton!
    @IBOutlet weak var paperButton: UIButton!
    @IBOutlet weak var scissorsButton: UIButton!
    
    @IBAction func handButtonPressed(sender: UIButton) {
        presentViaStoryboardInstantiation(sender)
    }
    
    @IBAction func segueHandButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("showResults", sender: sender)
    }
    
    func makeRandomHand() -> PlayableHand {
        var possibilities: [PlayableHand] = [
            Rock(), Paper(), Scissors()
        ];
        var randomIndex = arc4random_uniform(UInt32(possibilities.count));
        return possibilities[Int(randomIndex)]
    }
    
    func deriveResults(sender:UIButton) -> ResultsModel {
        let p2 = makeRandomHand();
        let map: [UIButton: PlayableHand] = [
            rockButton!:Rock(),
            paperButton!:Paper(),
            scissorsButton!:Scissors()
        ];
        let p1 = map[sender];
        let decider = MatchDecider()
        let index = decider.decideWinner(p1, hand2: p2);
        return ResultsModel(winnerIndex: index, handsInOrder: [p1!, p2])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let resultsSegues = ["showResults", "showResultsScissors"];
        if(contains(resultsSegues, segue.identifier!)) {
            let senderButton = sender as! UIButton;
            let destination = segue.destinationViewController as! ResultsViewController;
            destination.results = deriveResults(senderButton)
            
        }
        
    }

    func presentViaStoryboardInstantiation(sender: UIButton) {
        var resultsView = instantiateResultsViewFromStoryBoard(deriveResults(sender))
        presentViewController(resultsView, animated: true, completion: nil)
    }
    
    func instantiateResultsViewFromStoryBoard(matchResults:ResultsModel) -> UIViewController! {
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("ResultsViewController") as! ResultsViewController;
        viewController.results = matchResults;
        return viewController;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

