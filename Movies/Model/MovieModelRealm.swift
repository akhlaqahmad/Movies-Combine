//
//  MovieModelRealm.swift
//  Movies
//
//  Created by Akhlaq Ahmad on 15/05/2022.
//

import Foundation
import RealmSwift

//MARK : - Movie Model Used in Persistent Data

class MovieModelRealm: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var adult: Bool
    @Persisted var backdropPath: String?
    @Persisted var genreIDS = RealmSwift.List<Int>()
    @Persisted var originalLanguage: String
    @Persisted var originalTitle: String
    @Persisted var overview: String
    @Persisted var popularity: Double
    @Persisted var posterPath: String
    @Persisted var releaseDate: String
    @Persisted var title: String
    @Persisted var video: Bool
    @Persisted var voteAverage: Double
    @Persisted var voteCount: Int
}

extension MovieModel: Persistable {
    
    public init(managedObject: MovieModelRealm) {
        adult            = managedObject.adult
        backdropPath     = managedObject.backdropPath
        genreIDS         = Array(managedObject.genreIDS)
        id               = managedObject.id
        originalLanguage = managedObject.originalLanguage
        originalTitle    = managedObject.originalTitle
        overview         = managedObject.overview
        popularity       = managedObject.popularity
        posterPath       = managedObject.posterPath
        releaseDate      = managedObject.releaseDate
        title            = managedObject.title
        video            = managedObject.video
        voteAverage      = managedObject.voteAverage
        voteCount        = managedObject.voteCount
    }
    
    public func managedObject() -> MovieModelRealm {
        let movieRealm = MovieModelRealm()
        movieRealm.adult = adult
        movieRealm.backdropPath = backdropPath
        movieRealm.genreIDS.append(objectsIn: genreIDS)
        movieRealm.id = id
        movieRealm.originalLanguage = originalLanguage
        movieRealm.originalTitle = originalTitle
        movieRealm.overview = overview
        movieRealm.popularity = popularity
        movieRealm.posterPath = posterPath ?? ""
        movieRealm.releaseDate = releaseDate
        movieRealm.title = title
        movieRealm.video = video
        movieRealm.voteAverage = voteAverage
        movieRealm.voteCount = voteCount
        return movieRealm
    }
}
