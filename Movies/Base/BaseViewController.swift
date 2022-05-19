//
//  BaseViewController.swift
//  Movies
//
//  Created by Akhlaq Ahmad on 15/05/2022.
//

import UIKit
import Combine

class BaseViewController: UIViewController {
    
    var cancellables = Set<AnyCancellable>()
    
    private lazy var loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        
        let ai = UIActivityIndicatorView()
        ai.style = .medium
        ai.color = .white
        ai.startAnimating()
        ai.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(ai)
        ai.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ai.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLoadingView()
        
    }
    
    private func setupLoadingView() {
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func showLoading(_ show: Bool) {
        self.loadingView.alpha = show ? 1 : 0
    }
    
    func showSimpleAlert(alertMessage: String) {
        let alert = UIAlertController(title: "Movies", message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }

}
