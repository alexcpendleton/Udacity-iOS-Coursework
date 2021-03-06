//
//  PastMemesViewController.swift
//  MemeMe
//
//  Created by Alex Pendleton on 8/14/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit

public class PastMemesViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {

    public var memes = [MemeModel]()
    public let cellIdentifier = "MemeCell"
    
    @IBOutlet var targetTableView: UITableView!
    
    func reloadMemes() {
        memes = AppDelegate.defaultMemeRepository().all()
        targetTableView.reloadData()
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // If we come back from editing or making a 
        // meme we want to make sure the data is fresh
        reloadMemes()
        targetTableView.allowsMultipleSelectionDuringEditing = false
        targetTableView.setEditing(false, animated: true)
    }

    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            AppDelegate.defaultMemeRepository().remove(memes[indexPath.row])
            reloadMemes()
        }
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var currentMeme = memes[indexPath.row]
        PastMemesViewController.presentViewMeme(currentMeme, storyboard: storyboard, navigationController: navigationController)
    }
    
    public static func presentViewMeme(toLoad:MemeModel?, storyboard:UIStoryboard?, navigationController:UINavigationController?) {
        presentMemeEditor(toLoad, inEditMode: false, storyboard: storyboard, navigationController: navigationController)
        
    }
    
    internal static func presentMemeEditor(toLoad:MemeModel?, inEditMode:Bool, storyboard:UIStoryboard?, navigationController:UINavigationController?) {
        if let target = storyboard?.instantiateViewControllerWithIdentifier("MemeDetail") as? PickerViewController {
            navigationController?.pushViewController(target, animated: true)
            target.isInEditMode = inEditMode
            if toLoad != nil {
                target.sourceMeme = toLoad!
                target.canDelete = true
            }
        }
    }
    
    public static func presentEditMeme(toLoad:MemeModel?, storyboard:UIStoryboard?, navigationController:UINavigationController?) {
        presentMemeEditor(toLoad, inEditMode: true, storyboard: storyboard, navigationController: navigationController)
        
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var currentMeme = memes[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
            as? UITableViewCell
        
        cell?.textLabel?.text = currentMeme.topText + " " + currentMeme.bottomText
        cell?.imageView?.image = currentMeme.appliedImage
        return cell!
    }
}