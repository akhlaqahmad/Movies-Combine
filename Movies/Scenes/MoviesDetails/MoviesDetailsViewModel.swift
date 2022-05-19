//
//  MoviesDetailsViewModel.swift
//  Movies
//
//  Created by Akhlaq Ahmad on 15/05/2022.
//

import Foundation
import Combine

class MoviesDetailsViewModel: BaseViewModel {
    
    
    @Published var movieDetails: MovieDetailsModel?
    
    var realmManager: MoviesRealmManagerProtocol!
    var apiClient: APIClientProtocol!
    
    init(apiClient: APIClientProtocol = APIClient(), realmManager: MoviesRealmManagerProtocol = MoviesRealmManager()) {
        self.apiClient = apiClient
        self.realmManager = realmManager
    }
    
    
    func getMovieDetails(id: Int) {
        isLoading = true
        apiClient.performRequest(endpoint: .movieDetails(id: id), model: MovieDetailsModel.self).sink {
            [weak self] completion in
            guard let self = self else { return }
            switch completion {
            case .failure(let error):
                self.error = error.description
            case .finished:
                break
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isLoading = false
            }
        } receiveValue: {
            [weak self] movieDetails in
            guard let self = self else { return }
            self.movieDetails = movieDetails
        }.store(in: &cancellables)

    }
    
    func addMovieToFavorites(movieModel: MovieModel) {
        realmManager.save(movieModel)
    }
    
    func removeMovieFromFavorites(movieModel: MovieModel) {
        realmManager.delete(id: movieModel.id)
    }
    
    func checkIfMovieExistsInFavorites(movieModel: MovieModel) -> Bool {
        return realmManager.checkExist(id: movieModel.id)
    }
    
}
