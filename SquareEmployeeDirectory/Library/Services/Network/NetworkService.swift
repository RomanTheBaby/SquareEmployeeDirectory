//
//  NetworkService.swift
//  SquareEmployeeDirectory
//
//  Created by Roman on 2022-10-13.
//

import Foundation


// TODO: Come up with better name
protocol URLSessionCompatible {
    func makeRequest(
        _ request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    )
}


extension URLSession: URLSessionCompatible {
    func makeRequest(
        _ request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) {
        let dataTask = dataTask(with: request, completionHandler: completionHandler)
        dataTask.resume()
    }
    
}

class NetworkService {
    
    
    // MARK: - Private Properties
    
    private let baseURL: URL
    private let urlSession: URLSessionCompatible
    
    
    // MARK: - Init
    
    init(baseURL: URL = .squareAPI, urlSession: URLSessionCompatible = URLSession.shared) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }
    
    
    // MARK: - Public Methods
    
    func makeRequest<R: Request>(_ request: R, completion: @escaping (Result<R.Model, Error>) -> Void) {
        guard let request = request.buildURLRequest(withBaseURL: baseURL) else {
            return
        }
        
        makeRequest(request) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
                
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let decodedObject = try decoder.decode(R.Model.self, from: data)
                    completion(.success(decodedObject))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func makeRequest(_ request: URLRequest, _ completion: @escaping (Result<Data, Error>) -> Void) {
        urlSession.makeRequest(request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                completion(.success(data))
            }
        }
    }
    
    func makeContinuationRequest(_ request: URLRequest) async throws -> Data {
        return try await withCheckedThrowingContinuation({ continuation in
            makeRequest(request) { result in
                switch result {
                case .success(let data):
                    continuation.resume(returning: data)
                    
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
    }
    
}


private extension URL {
    static let squareAPI = URL(string: "https://s3.amazonaws.com/sq-mobile-interview/")!
}
