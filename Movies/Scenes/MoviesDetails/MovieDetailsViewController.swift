//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Akhlaq Ahmad on 15/05/2022.
//

import UIKit
import Kingfisher
import Combine

class MovieDetailsViewController: BaseViewController {
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var spokenLanguagesLabel: UILabel!
    
    var movieModel: MovieModel!
    let viewModel = MoviesDetailsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        viewModel.getMovieDetails(id: movieModel.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    
    static func initiate(movieModel: MovieModel) -> MovieDetailsViewController {
        let vc = MovieDetailsViewController()
        vc.movieModel = movieModel
        vc.title = "Movie Details"
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
    
    private func setupUI() {
        backImageView.layer.cornerRadius = 15
        posterImageView.layer.cornerRadius = 8
        favoriteButton.layer.cornerRadius = 12
        favoriteButton.setTitle(viewModel.checkIfMovieExistsInFavorites(movieModel: movieModel) ? "Remove From Favorites" : "Add To Favorites", for: .normal)
    }
    
    private func bind() {
        viewModel.$movieDetails.sink { [weak self] movieDetails in
            guard let self = self, let movieDetails = movieDetails else { return }
            self.loadMovieData(movieDetails)
        }.store(in: &cancellables)
        
        viewModel.$error.sink { [weak self] errorMessage in
            guard let errorMessage = errorMessage, !errorMessage.isEmpty else { return }
            self?.showSimpleAlert(alertMessage: errorMessage)
        }.store(in: &cancellables)
        
        viewModel.$isLoading.sink { [weak self] isloading in
            self?.showLoading(isloading)
        }.store(in: &cancellables)
        
    }
    
    private func loadMovieData(_ movieDetails: MovieDetailsModel) {
        let backURL = URL(string: "https://image.tmdb.org/t/p/original/\(movieDetails.backdropPath)")
        backImageView.kf.indicatorType = .activity
        backImageView.kf.setImage(
            with: backURL,
            placeholder: UIImage(named: "placeholder"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])

        let posterURL = URL(string: "https://image.tmdb.org/t/p/original/\(movieDetails.posterPath)")
        posterImageView.kf.indicatorType = .activity
        posterImageView.kf.setImage(
            with: posterURL,
            placeholder: UIImage(named: "placeholder"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        
        titleLabel.text = movieDetails.title
        taglineLabel.text = movieDetails.tagline
        overviewLabel.text = movieDetails.overview
        statusLabel.text = movieDetails.status
        releaseDateLabel.text = "Release Date : \(movieDetails.releaseDate)"
        genresLabel.text = movieDetails.genres.map { $0.name }.joined(separator: " - ")
        spokenLanguagesLabel.text = movieDetails.spokenLanguages.map { $0.englishName }.joined(separator: ", ")
        
        
    }
    

    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        if viewModel.checkIfMovieExistsInFavorites(movieModel: movieModel) {
            viewModel.removeMovieFromFavorites(movieModel: movieModel)
            showSimpleAlert(alertMessage: "This Movie is Removed From Your Favorite Movies")
            favoriteButton.setTitle("Add To Favorites", for: .normal)
        } else {
            viewModel.addMovieToFavorites(movieModel: movieModel)
            showSimpleAlert(alertMessage: "This Movie is Added To Your Favorite Movies")
            favoriteButton.setTitle("Remove From Favorites", for: .normal)
        }
        
    }
    
}
