//
//  HomeViewModel.swift
//  Movies
//
//  Created by Akhlaq Ahmad on 15/05/2022.
//

import UIKit

var genresGlobal: [Genre] = []


class HomeViewModel: BaseViewModel {
    
    @Published var upcomingMovies: [MovieModel] = []
    @Published var topRatedMovies: [MovieModel] = []
    @Published var popularMovies: [MovieModel] = []
    @Published var nowPlayingMovies: [MovieModel] = []
    @Published var genres: [Genre] = []
        
    var nowPlayingTotalPages = 1
    var popularTotalPages = 1
    var topRatedTotalPages = 1
    var upcomingTotalPages = 1
    
    var nowPlayingOffset: CGFloat = 0.0
    var popularOffset: CGFloat = 0.0
    var topRatedOffset: CGFloat = 0.0
    var upcomingOffset: CGFloat = 0.0
    
    
    var nowPlayingPage = 1
    var popularPage = 1
    var topRatedPage = 1
    var upcomingPage = 1
    
    var apiClient: APIClientProtocol!
    
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }
    
    
    
    func getGenres() {
        apiClient.performRequest(endpoint: .genres, model: GenresModel.self)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error.description
                case .finished:
                    break
                }
            } receiveValue: { [weak self] genresModel in
                self?.genres = genresModel.genres
                genresGlobal = genresModel.genres
            }
            .store(in: &cancellables)

    }
    
    func getUpcomingMovies(isPaging: Bool) {
        print("Page upcoming \(upcomingPage)")
        guard upcomingPage <= upcomingTotalPages else { return }
        if !isPaging { isLoading = true } 
        apiClient.performRequest(endpoint: .upcomingMovies(page: upcomingPage), model: MoviesListModel.self)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error.description
                case .finished:
                    break
                }
                self?.isLoading = false
            } receiveValue: { [weak self] upcomingList in
                self?.upcomingMovies.append(contentsOf: upcomingList.results)
                self?.upcomingPage += 1
                self?.upcomingTotalPages = upcomingList.totalPages
            }
            .store(in: &cancellables)

    }
    
    func getTopRatedMovies(isPaging: Bool) {
        print("Page top rated \(topRatedPage)")
        guard topRatedPage <= topRatedTotalPages else { return }
        if !isPaging { isLoading = true }
        apiClient.performRequest(endpoint: .topRatedMovies(page: topRatedPage), model: MoviesListModel.self)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error.description
                case .finished:
                    break
                }
                self?.isLoading = false
            } receiveValue: { [weak self] topratedList in
                self?.topRatedMovies.append(contentsOf: topratedList.results)
                self?.topRatedPage += 1
                self?.topRatedTotalPages = topratedList.totalPages
            }
            .store(in: &cancellables)
    }
    
    func getPopularMovies(isPaging: Bool) {
        print("Page popular \(popularPage)")
        guard popularPage <= popularTotalPages else { return }
        if !isPaging { isLoading = true }
        apiClient.performRequest(endpoint: .popularMovies(page: popularPage), model: MoviesListModel.self)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error.description
                case .finished:
                    break
                }
                self?.isLoading = false
            } receiveValue: { [weak self] popularList in
                self?.popularMovies.append(contentsOf: popularList.results)
                self?.popularPage += 1
                self?.popularTotalPages = popularList.totalPages
            }
            .store(in: &cancellables)
    }
    
    func getNowPlayingMovies(isPaging: Bool) {
        print("Page Now playing \(nowPlayingPage)")
        guard nowPlayingPage <= nowPlayingTotalPages else { return }
        if !isPaging { isLoading = true }
        apiClient.performRequest(endpoint: .nowPlayingMovies(page: nowPlayingPage), model: MoviesListModel.self)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error.description
                case .finished:
                    break
                }
                self?.isLoading = false
            } receiveValue: { [weak self] nowPlayingList in
                self?.nowPlayingMovies.append(contentsOf: nowPlayingList.results)
                self?.nowPlayingPage += 1
                self?.nowPlayingTotalPages = nowPlayingList.totalPages
            }
            .store(in: &cancellables)
    }
 
    
    
}
