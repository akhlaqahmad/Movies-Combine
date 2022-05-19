//
//  MoviesListModel.swift
//  Movies
//
//  Created by Akhlaq Ahmad on 15/05/2022.
//

import Foundation

// MARK: - MoviesListModel
struct MoviesListModel: Codable {
    let dates       : Dates?
    let page        : Int
    let results     : [MovieModel]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages     = "total_pages"
        case totalResults   = "total_results"
    }
}

// MARK: - Dates
struct Dates: Codable {
    let maximum, minimum: String?
}

// MARK: - MovieModel
struct MovieModel: Codable {
    let adult       : Bool
    let backdropPath: String?
    let genreIDS    : [Int]
    let id          : Int
    let popularity  : Double
    let posterPath  : String?
    let video       : Bool
    let voteAverage : Double
    let voteCount   : Int
    let releaseDate, title: String
    let originalLanguage, originalTitle, overview: String
    
    var genreString: String {
        if genresGlobal.isEmpty { return "" }
        else {
            let itemGenres = genresGlobal.filter { genreIDS.contains($0.id) }
            return itemGenres.map { $0.name }.joined(separator: " - ")
        }
    }

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}


