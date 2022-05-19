//
//  HomeViewController.swift
//  WegooDriver
//
//  Created by Akhlaq Ahmad on 14/05/2022.
//  Copyright © 2022 AAPBD. All rights reserved.
//

import UIKit
import Alamofire


enum MoviesListType {
    case nowPlaying, popular, topRated, upcoming
}

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var tabsCV: UICollectionView!
    @IBOutlet weak var itemsTV: UITableView!
        
    private let viewModel = HomeViewModel()
    private var dataSource = [MovieModel]() {
        didSet {
            itemsTV.reloadData()
        }
    }
    
    var moviesType = MoviesListType.nowPlaying {
        didSet {
            view.layoutIfNeeded()
            if moviesType == .nowPlaying { itemsTV.setContentOffset(CGPoint(x: 0, y: viewModel.nowPlayingOffset), animated: false) }
            if moviesType == .popular { itemsTV.setContentOffset(CGPoint(x: 0, y: viewModel.popularOffset), animated: false) }
            if moviesType == .topRated { itemsTV.setContentOffset(CGPoint(x: 0, y: viewModel.topRatedOffset), animated: false) }
            if moviesType == .upcoming { itemsTV.setContentOffset(CGPoint(x: 0, y: viewModel.upcomingOffset), animated: false) }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupTableView()
        bind()
        viewModel.getGenres()
        viewModel.getUpcomingMovies(isPaging: false)
        viewModel.getTopRatedMovies(isPaging: false)
        viewModel.getPopularMovies(isPaging: false)
        viewModel.getNowPlayingMovies(isPaging: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func bind() {
        viewModel.$genres.sink { [weak self] _ in
            self?.itemsTV.reloadData()
        }.store(in: &cancellables)
        
        viewModel.$nowPlayingMovies.sink { [weak self] nowplayingList in
            guard let self = self else { return }
            if self.moviesType == .nowPlaying { self.dataSource = nowplayingList }
        }.store(in: &cancellables)
        
        viewModel.$popularMovies.sink { [weak self] popularList in
            guard let self = self else { return }
            if self.moviesType == .popular { self.dataSource = popularList }
        }.store(in: &cancellables)
        
        viewModel.$topRatedMovies.sink { [weak self] topratedList in
            guard let self = self else { return }
            if self.moviesType == .topRated { self.dataSource = topratedList }
        }.store(in: &cancellables)
        
        viewModel.$upcomingMovies.sink { [weak self] upcomingList in
            guard let self = self else { return }
            if self.moviesType == .upcoming { self.dataSource = upcomingList }
        }.store(in: &cancellables)
        
        
        viewModel.$error.sink { [weak self] errorMessage in
            guard let errorMessage = errorMessage, !errorMessage.isEmpty else { return }
            guard let self = self else { return }
            self.showSimpleAlert(alertMessage: errorMessage)
        }.store(in: &cancellables)
        
        viewModel.$isLoading.sink { [weak self] isloading in
            guard let self = self else { return }
            self.showLoading(isloading)
        }.store(in: &cancellables)
    }
    
    private func setupCollectionView() {
        tabsCV.delegate = self
        tabsCV.dataSource = self
        tabsCV.register(HomeTabCVCell.nib, forCellWithReuseIdentifier: HomeTabCVCell.identifier)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        layout.estimatedItemSize = CGSize(width: 70, height: 50)
        tabsCV.setCollectionViewLayout(layout, animated: true)
        tabsCV.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    private func setupTableView() {
        itemsTV.delegate = self
        itemsTV.dataSource = self
        itemsTV.register(HomeMovieTVCell.nib, forCellReuseIdentifier: HomeMovieTVCell.identifier)
        itemsTV.rowHeight = 150
    }
    
    
    @IBAction func searchTapped(_ sender: UIButton) {
        let searchVC = SearchViewController()
        searchVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(searchVC, animated: true)
    }
    

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeMovieTVCell.identifier, for: indexPath) as! HomeMovieTVCell
        let movieItem = dataSource[indexPath.row]
        cell.configureCell(model: movieItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource[indexPath.row]
        let movieDetailsVC = MovieDetailsViewController.initiate(movieModel: item)
        print(item.id)
        navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == dataSource.count - 1, !viewModel.isLoading else { return }
        if moviesType == .nowPlaying {
            viewModel.getNowPlayingMovies(isPaging: true)
        } else if moviesType == .popular {
            viewModel.getPopularMovies(isPaging: true)
        } else if moviesType == .topRated {
            viewModel.getTopRatedMovies(isPaging: true)
        } else if moviesType == .upcoming {
            viewModel.getUpcomingMovies(isPaging: true)
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTabCVCell.identifier, for: indexPath) as! HomeTabCVCell
        if indexPath.row == 0 { cell.tabTitleLabel.text = "Now Playing" }
        else if  indexPath.row == 1 { cell.tabTitleLabel.text = "Popular" }
        else if  indexPath.row == 2 { cell.tabTitleLabel.text = "Top Rated" }
        else { cell.tabTitleLabel.text = "Upcoming" }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 { dataSource = viewModel.nowPlayingMovies ; moviesType = .nowPlaying }
        else if  indexPath.row == 1 { dataSource = viewModel.popularMovies ; moviesType = .popular }
        else if  indexPath.row == 2 { dataSource = viewModel.topRatedMovies ; moviesType = .topRated }
        else { dataSource = viewModel.upcomingMovies ; moviesType = .upcoming }
    }
    
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == itemsTV else { return }
        if moviesType == .nowPlaying { viewModel.nowPlayingOffset = scrollView.contentOffset.y }
        else if moviesType == .popular { viewModel.popularOffset = scrollView.contentOffset.y }
        else if moviesType == .topRated { viewModel.topRatedOffset = scrollView.contentOffset.y }
        else { viewModel.upcomingOffset = scrollView.contentOffset.y }
    }
}
