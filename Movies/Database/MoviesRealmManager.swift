//
//  RealmManager.swift
//  Movies
//
//  Created by Akhlaq Ahmad on 15/05/2022.
//

import Foundation
import RealmSwift

protocol MoviesRealmManagerProtocol {
    func save(_ model: MovieModel)
    func get(completion: @escaping ([MovieModel]) -> Void)
    func delete(id: Int)
    func checkExist(id: Int) -> Bool
}


class MoviesRealmManager: MoviesRealmManagerProtocol {
    
    let localRealm = try! Realm()
    
    func save(_ model: MovieModel) {
        let movieModelObject = model.managedObject()
        try! localRealm.write {
            localRealm.add(movieModelObject)
        }
    }
    
    func get(completion: @escaping ([MovieModel]) -> Void) {
        let moviesListRealm = localRealm.objects(MovieModelRealm.self)
        let moviesList = moviesListRealm.map { movieModelRealm -> MovieModel in
            let movie = MovieModel(managedObject: movieModelRealm)
            return movie
        }
        completion(Array(moviesList))
            
    }
    
    func delete(id: Int) {
        if let itemToDelete = localRealm.object(ofType: MovieModelRealm.self, forPrimaryKey: id) {
            try! localRealm.write {
                localRealm.delete(itemToDelete)
            }
        }
    }
    
    func checkExist(id: Int) -> Bool {
        return localRealm.object(ofType: MovieModelRealm.self, forPrimaryKey: id) != nil
    }
    
}
