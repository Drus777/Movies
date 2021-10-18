//
//  GenresOfMovie.swift
//  Final Project
//
//  Created by Andrey on 26.09.21.
//

import UIKit

struct Genre: Codable {
    var id: Int
    var name: String
}

struct GenresOfMovie: Codable {
    var genres: [Genre]
}
