//
//  HardcodedGenresService.swift
//  MyFavoriteMovies
//
//  Created by Alex Pendleton on 9/11/15.
//  Copyright (c) 2015 Alex Pendleton. All rights reserved.
//

import Foundation

public class HardcodedGenresService : GenresServiceProtocol {
    public func all() -> [Genre] {
        return [
            Genre(name: "Sci-Fi", image: nil, id: "001"),
            Genre(name: "Comedy", image: nil, id: "002"),
            Genre(name: "Action", image: nil, id: "003"),
        ]
    }
}