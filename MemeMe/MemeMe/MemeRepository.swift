//
//  MemeRepository.swift
//  MemeMe
//
//  Created by Alex Pendleton on 8/15/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import Foundation

public protocol MemeRepository {
    func persist(toPersist:MemeModel)
    func all() -> [MemeModel]
}