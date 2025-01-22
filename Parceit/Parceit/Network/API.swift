//
//  API.swift
//  Parceit
//
//  Created by Mert Ozseven on 1.01.2025.
//

import Foundation

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
}

enum Router {
    case trackingInfo
    
    var path: String {
        switch self {
        case .trackingInfo:
            return "public/v1/tracking/search"
        }
    }
}

final class API {
    
    // MARK: - Singleton Instance
    static let shared: API = {
        let instance = API()
        return instance
    }()
    
    // MARK: - Properties
    private let apiKey = "apik_OG16FiJxDk1jKcJQ4WJW2zeVnLTemT"
    private let baseURL = "https://api.ship24.com/" 
    
    var service: NetworkService
    
    // MARK: - Initializer
    init(service: NetworkService = NetworkManager()) {
        self.service = service
    }
}

extension API {
    
    // MARK: - Prepare URL Request
    func prepareURLRequestFor(
        router: Router,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        method: RequestMethod = .post
    ) -> URLRequest? {
        
        let urlString = baseURL + router.path
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLRequest(url: url)
        
        if let params = parameters {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                request.httpBody = jsonData
            } catch {
                print("Error serializing JSON: \(error.localizedDescription)")
                return nil
            }
        }
        
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        if let requestHeaders = headers {
            for (field, value) in requestHeaders {
                request.setValue(value, forHTTPHeaderField: field)
            }
        }
        
        return request
    }
    
    // MARK: - Execute Request
    func executeRequestFor<T: Decodable>(
        router: Router,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        method: RequestMethod = .post,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let urlRequest = prepareURLRequestFor(
            router: router,
            parameters: parameters,
            headers: headers,
            method: method
        ) else {
            completion(.failure(.invalidRequest))
            return
        }
        
        service.execute(urlRequest: urlRequest, completion: completion)
    }
}
