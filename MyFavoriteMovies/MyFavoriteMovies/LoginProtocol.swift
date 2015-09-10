//
//  LoginProtocol.swift
//  MyFavoriteMovies
//
//  Created by Alex Pendleton on 9/9/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import Foundation

public protocol LoginServiceProtocol {
    func AuthorizeCredentials(username:String, password:String)->Bool;
}