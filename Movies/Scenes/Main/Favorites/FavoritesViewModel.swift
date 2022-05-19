//
//  FavoritesViewModel.swift
//  Movies
//
//  Created by Akhlaq Ahmad on 15/05/2022.
//

import Foundation


class FavoritesViewModel: BaseViewModel {
    
    @Published var favoriteMovies: [MovieModel] = []
    
    var realmManager: MoviesRealmManagerProtocol!
    
    init(realmManager: MoviesRealmManagerProtocol = MoviesRealmManager()) {
        self.realmManager = realmManager
    }
    
    func getFavoriteMovies() {
        realmManager.get { [weak self] moviesList in
            DispatchQueue.main.async {
                self?.favoriteMovies = moviesList
            }
        }
    }
}
