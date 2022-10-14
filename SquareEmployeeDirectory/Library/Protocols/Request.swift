//
//  Request.swift
//  SquareEmployeeDirectory
//
//  Created by Roman on 2022-10-14.
//

import Foundation

protocol Request {
    var path: String { get }
    var method: RequestType { get }
    var contentType: String { get }
    var body: [String: Any]? { get }
    var headers: [String: String]? { get }
    
    associatedtype Model: Codable
}

extension Request {
    
    var contentType: String {
        ""
    }
    
    var body: [String: Any]? {
        nil
    }
    
    var headers: [String: String]? {
        nil
    }
    
    func buildURLRequest(withBaseURL baseURL: URL) -> URLRequest? {
        guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        urlComponents.path = baseURL.path.appending(path)
        
        guard let finalURL = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        return request
    }
    
}
