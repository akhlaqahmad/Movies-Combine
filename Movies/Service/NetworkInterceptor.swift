//
//  NetworkInterceptor.swift
//  Movies
//
//  Created by Akhlaq Ahmad on 14/05/2022.
//

import Foundation
import Alamofire


class NetworkInterceptor: RequestInterceptor {
    
    private var apiKeyParameter = ["api_key":"0e7274f05c36db12cbe71d9ab0393d47"]
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        let encoding = URLEncodedFormParameterEncoder.default
        if let request = try? encoding.encode(apiKeyParameter, into: urlRequest) {
            urlRequest = request
        }
        completion(.success(urlRequest))
    }
    
    
}
