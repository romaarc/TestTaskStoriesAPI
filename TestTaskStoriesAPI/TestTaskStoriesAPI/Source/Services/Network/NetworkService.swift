//
//  NetworkService.swift
//  TestTaskStoriesAPI
//
//  Created by Roman Gorshkov on 08.05.2022.
//

import Foundation
import PromiseKit

enum NetworkErrors: Error {
    case wrongURL
    case dataIsEmpty
    case decodeIsFail
}

final class NetworkService {

    func baseRequest<T: Decodable>(request: URLRequest) -> Promise<T> {
        Promise { seal in
            guard let _ = request.url else {
                seal.reject(NetworkErrors.wrongURL)
                return
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    seal.reject(error)
                }
                
                guard let data = data else {
                    seal.reject(NetworkErrors.dataIsEmpty)
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let decodedModel = try decoder.decode(T.self, from: data)
                    seal.fulfill(decodedModel)
                } catch {
                    seal.reject(NetworkErrors.decodeIsFail)
                }
            }.resume()
        }
    }
}
