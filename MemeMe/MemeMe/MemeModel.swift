//
//  MemeModel.swift
//  MemeMe
//
//  Created by Alex Pendleton on 8/14/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit

public class MemeModel : NSObject {
    public init(top:String, bottom:String, original: UIImage, applied: UIImage) {
        self.topText = top
        self.bottomText = bottom
        self.originalImage = original
        self.appliedImage = applied
    }
    public var topText: String = ""
    public var bottomText: String = ""
    public var originalImage: UIImage!
    public var appliedImage: UIImage!
    
}