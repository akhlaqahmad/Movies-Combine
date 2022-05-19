//
//  APIRouter.swift
//  Movies
//
//  Created by Akhlaq Ahmad on 14/05/2022.
//

import Alamofire
import Foundation

protocol APIConfiguration: URLRequestConvertible {
    
    var method: HTTPMethod { get }
    var baseURL: String { get }
    var path: String { get }
    var parameters: Parameters { get }
    var headers: HTTPHeaders { get }
    
    func asURLRequest() throws -> URLRequest
}


enum APIRouter: APIConfiguration {
    
    case genres
    case upcomingMovies(page: Int)
    case popularMovies(page: Int)
    case topRatedMovies(page: Int)
    case nowPlayingMovies(page: Int)
    case movieDetails(id: Int)
    case search(query: String, page: Int)
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        
        switch self {
        default :
            return .get
        }
    }
    
    // MARK: - BaseURL
    var baseURL: String {
        return "https://api.themoviedb.org/3/"
    }
    
    // MARK: - Path
    var path: String {
        switch self {
            
        case .genres:
            return "genre/movie/list"
        case .upcomingMovies:
            return "movie/upcoming"
        case .popularMovies:
            return "movie/popular"
        case .topRatedMovies:
            return "movie/top_rated"
        case .nowPlayingMovies:
            return "movie/now_playing"
        case .movieDetails(let id):
            return "movie/\(id)"
        case .search:
            return "search/movie"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters {
        
        switch self {
        case .nowPlayingMovies(let page):
            return ["page":"\(page)"]
        case .topRatedMovies(let page):
            return ["page":"\(page)"]
        case .upcomingMovies(let page):
            return ["page":"\(page)"]
        case .popularMovies(let page):
            return ["page":"\(page)"]
        case .search(let query, let page):
            return ["query" : query, "page": "\(page)"]
        default:
            return [:]
        }
    }
    
    // MARK: - Headers
    var headers: HTTPHeaders {
        
        switch self {
        default:
            return ["Content-Type" : "application/json"]
        }
    }
    
    // MARK: - URLRequestConvertible
    public func asURLRequest() throws -> URLRequest {
        let urlString = baseURL + path
        let url = try urlString.asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.headers = headers
        urlRequest.method = method

        switch method {
        case .get, .delete:
            return try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        }
        
    }
}
