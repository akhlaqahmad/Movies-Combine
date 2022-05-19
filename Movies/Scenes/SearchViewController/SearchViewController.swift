//
//  SearchViewController.swift
//  WegooDriver
//
//  Created by Akhlaq Ahmad on 14/05/2022.
//  Copyright © 2022 AAPBD. All rights reserved.
//

import UIKit
import Combine

class SearchViewController: BaseViewController {
    
    
    @IBOutlet weak var itemsTV: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchTFContainer: UIView!
    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func bind() {
        viewModel.$moviesList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] moviesList in
                guard let self = self else { return }
                self.searchTF.resignFirstResponder()
                self.itemsTV.reloadData()
            }.store(in: &cancellables)
    }
    
    private func setupTableView() {
        itemsTV.delegate = self
        itemsTV.dataSource = self
        itemsTV.register(HomeMovieTVCell.nib, forCellReuseIdentifier: HomeMovieTVCell.identifier)
        itemsTV.rowHeight = 150
    }

    @IBAction func searchTapped(_ sender: UIButton) {
        guard let query = searchTF.text, !query.isEmpty else { return }
        itemsTV.setContentOffset(.zero, animated: true)
        viewModel.searchMovies(with: query, isPaging: false)
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.moviesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeMovieTVCell.identifier, for: indexPath) as! HomeMovieTVCell
        let movieItem = viewModel.moviesList[indexPath.row]
        cell.configureCell(model: movieItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.moviesList[indexPath.row]
        let movieDetailsVC = MovieDetailsViewController.initiate(movieModel: item)
        print(item.id)
        navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == viewModel.moviesList.count - 1,
              let query = searchTF.text,
              !query.isEmpty else { return }
        viewModel.searchMovies(with: query, isPaging: true)
    }
    
    
}
