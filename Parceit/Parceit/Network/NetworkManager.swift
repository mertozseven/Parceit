//
//  NetworkManager.swift
//  Parceit
//
//  Created by Mert Ozseven on 1.01.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
    case requestFailed
    case jsonDecodedError
    case customError(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidRequest:
            return "Invalid Request"
        case .requestFailed:
            return "Request Failed. Please check your internet connection."
        case .jsonDecodedError:
            return "Failed to decode JSON data."
        case .customError(let error):
            return error.localizedDescription
        }
    }
}

protocol NetworkService {
    func execute<T: Decodable>(
        urlRequest: URLRequest,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}

final class NetworkManager {
    private let session: URLSession
    
    // MARK: - Initializer
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
}

extension NetworkManager: NetworkService {
    // MARK: - Execute Request
    func execute<T: Decodable>(
        urlRequest: URLRequest,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("Network Error: \(error.localizedDescription)")
                completion(.failure(.customError(error)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                print("HTTP Error: Status code \(httpResponse.statusCode)")
                completion(.failure(.requestFailed))
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(.failure(.requestFailed))
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON Response: \(jsonString)")
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                print("Decoding Error: \(error)")
                completion(.failure(.jsonDecodedError))
            }
        }
        task.resume()
    }
}
