//
//  Genre.swift
//  MyFavoriteMovies
//
//  Created by Alex Pendleton on 9/11/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit

public class Genre {
    init(name:String, image:UIImage?, id:String) {
        self.name = name
        self.image = image
        self.id = id
    }
    var name:String
    var image:UIImage?
    var id:String
}