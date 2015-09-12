//
//  PassthroughLoginService.swift
//  MyFavoriteMovies
//
//  Created by Alex Pendleton on 9/9/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import Foundation

public class PassthroughLoginService : LoginServiceProtocol {
    // Allows anyone through, for testing purposes before auth is necessary
    public func AuthorizeCredentials(username: String, password: String) -> Bool {
        return true
    }
}