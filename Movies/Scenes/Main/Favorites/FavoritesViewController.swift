//
//  FavoritesViewController.swift
//  WegooDriver
//
//  Created by Akhlaq Ahmad on 14/05/2022.
//  Copyright © 2022 AAPBD. All rights reserved.
//

import UIKit

class FavoritesViewController: BaseViewController {

    @IBOutlet weak var itemsTV: UITableView!

    let viewModel = FavoritesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        viewModel.getFavoriteMovies()
    }
    
    
    private func setupTableView() {
        itemsTV.delegate = self
        itemsTV.dataSource = self
        itemsTV.register(HomeMovieTVCell.nib, forCellReuseIdentifier: HomeMovieTVCell.identifier)
        itemsTV.rowHeight = 150
    }
    
    private func bind() {
        viewModel.$favoriteMovies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] favoriteMovies in
                self?.itemsTV.reloadData()
            }.store(in: &cancellables)
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeMovieTVCell.identifier, for: indexPath) as! HomeMovieTVCell
        let item = viewModel.favoriteMovies[indexPath.row]
        cell.configureCell(model: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.favoriteMovies[indexPath.row]
        let movieDetailsVC = MovieDetailsViewController.initiate(movieModel: item)
        print(item.id)
        navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
    
    
    
    
}
