//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Alex Pendleton on 8/15/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import Foundation
//
//  PastMemesViewController.swift
//  MemeMe
//
//  Created by Alex Pendleton on 8/14/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit

public class MemeCollectionViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    // For future reference: http://www.raywenderlich.com/78550/beginning-ios-collection-views-swift-part-1
    public var memes = {
        // Lazy load these from the default repo if they aren't 
        // explicitly set
        AppDelegate.defaultMemeRepository().all()
    }()
    
    public let cellIdentifier = "MemeCell"
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let toLoad = memes[indexPath.row]
        PastMemesViewController.presentViewMeme(toLoad, storyboard: self.storyboard, navigationController: self.navigationController)
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var currentMeme = memes[indexPath.row]
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
            as? MemeCollectionViewCell
        cell?.backgroundColor = UIColor.redColor()
        cell?.image?.image = currentMeme.appliedImage!
        return cell!
    }
}

public class MemeCollectionViewCell : UICollectionViewCell {
    @IBOutlet var image:UIImageView?
}