//
//  URLSessionCompatible.swift
//  SquareEmployeeDirectory
//
//  Created by Roman on 2022-10-14.
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
