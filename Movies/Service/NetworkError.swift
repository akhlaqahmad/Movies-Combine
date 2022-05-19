//
//  NetworkError.swift
//  Movies
//
//  Created by Akhlaq Ahmad on 14/05/2022.
//

import Foundation


enum NetworkError: Error {
    
    case notAuthorized
    case parsingError
    case unknownError
    
    var description: String {
        switch self {
        case .notAuthorized:
            return "You are not authorized"
        case .unknownError:
            return "Something went wrong, Please try again!"
        case .parsingError:
            return "Invalid data"
        }
    }
    
}
