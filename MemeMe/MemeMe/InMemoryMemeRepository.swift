//
//  InMemoryMemeRepository.swift
//  MemeMe
//
//  Created by Alex Pendleton on 8/14/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit

public class InMemoryMemeRepository : NSObject, MemeRepository {
    
    var persisted = [MemeModel]()
    
    public func persist(toPersist:MemeModel) {
        // Don't re-add edited memes, just let the changes take place
        if !contains(persisted, { (element) -> Bool in
        return element === toPersist
        }) {
            persisted.append(toPersist)
        }
    }
    
    public func remove(toRemove:MemeModel) {
        if contains(persisted, { (element) -> Bool in
            return element === toRemove
        }) {
            // Remove the element if it exists (by filtering the list)
            // http://stackoverflow.com/a/30829144
            persisted = persisted.filter() { $0 !== toRemove }
        }
    }
    
    public func all() -> [MemeModel] {
        return persisted
    }
}