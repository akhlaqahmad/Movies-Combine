//
//  APIClient.swift
//  Movies
//
//  Created by Akhlaq Ahmad on 14/05/2022.
//

import Foundation
import Alamofire
import Combine


protocol APIClientProtocol {
    
    func performRequest<T: Codable>(endpoint: APIRouter, model: T.Type) -> AnyPublisher<T,NetworkError>
}

class APIClient: APIClientProtocol {
    
    func performRequest<T: Codable>(endpoint: APIRouter, model: T.Type) -> AnyPublisher<T,NetworkError> {
        return AF
            .request(endpoint, interceptor: NetworkInterceptor())
            .validate()
            .publishDecodable(type: model.self, decoder: JSONDecoder())
            .value()
            .mapError({ afError in
                if afError.responseCode == 401 { return NetworkError.notAuthorized }
                else if afError.isResponseSerializationError { print(afError) ; return NetworkError.parsingError }
                return NetworkError.unknownError
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
