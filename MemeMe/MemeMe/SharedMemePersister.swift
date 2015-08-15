//
//  SharedMemePersister.swift
//  MemeMe
//
//  Created by Alex Pendleton on 8/14/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit

public class SharedMemePersister : NSObject {
    var persisted = [MemeModel]()
    public func persist(toPersist:MemeModel) {
        persisted.append(toPersist)
    }
    public func all() -> [MemeModel] {
        return persisted
    }

    static let appDefaultPersister = SharedMemePersister()
    public static func defaultPersister() -> SharedMemePersister {
        return appDefaultPersister
    }
}