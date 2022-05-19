//
//  SearchViewModel.swift
//  Movies
//
//  Created by Akhlaq Ahmad on 15/05/2022.
//

import Foundation

class SearchViewModel: BaseViewModel {
    
    
    @Published var moviesList: [MovieModel] = []
    
    var page: Int = 0
    var isPaginating = false
    var apiClient: APIClientProtocol!
    var totalPages = 1
    var query: String = ""
    
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }
    
    func searchMovies(with query: String, isPaging: Bool) {
        if query != self.query {}
        else if query == self.query && page > totalPages { return }
        if !isPaging {
            isLoading = true
            page = 1
        }
        print("Page search \(page)")
        apiClient.performRequest(endpoint: .search(query: query, page: page), model: MoviesListModel.self)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error.description
                case .finished:
                    break
                }
                self?.isLoading = false
            } receiveValue: { [weak self] moviesList in
                if isPaging { self?.moviesList.append(contentsOf: moviesList.results) }
                else {
                    self?.moviesList = moviesList.results
                    self?.totalPages = moviesList.totalPages
                }
                self?.page += 1
                self?.query = query
            }.store(in: &cancellables)

    }
    
}
