//
//  BaseViewModel.swift
//  Movies
//
//  Created by Akhlaq Ahmad on 15/05/2022.
//

import UIKit
import Combine


class BaseViewModel {
    
    var cancellables = Set<AnyCancellable>()
    @Published var isLoading: Bool = false
    @Published var error: String?
    
}
