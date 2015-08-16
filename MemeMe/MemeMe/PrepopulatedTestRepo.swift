//
//  PrepopulatedTestRepo.swift
//  MemeMe
//
//  Created by Alex Pendleton on 8/15/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit

public class PrepopulatedTestRepo : InMemoryMemeRepository {
    public override init() {
        super.init()
        for (var i = 0; i < 10; i++) {
            persist(make(i))
        }
    }
    
    internal func make(number:Int) -> MemeModel {
        var image = UIImage(named: "TestImage1")
        return MemeModel(top: "Meme Top #" + number.description, bottom: "Meme Bottom #" + number.description, original: image!, applied: image!)
    }
    
}