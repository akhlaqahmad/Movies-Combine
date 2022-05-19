//
//  GenreModel.swift
//  Movies
//
//  Created by Akhlaq Ahmad on 14/05/2022.
//

import Foundation

// MARK: - GenreModel
struct GenresModel: Codable {
    let genres: [Genre]
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name: String
}
