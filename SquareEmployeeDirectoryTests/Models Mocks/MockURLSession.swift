//
//  MockURLSession.swift
//  SquareEmployeeDirectoryTests
//
//  Created by Roman on 2022-10-14.
//

import Foundation


class MockURLSession: URLSessionCompatible {
    
    
    // MARK: - Private Properties
    
    private(set) var lastRequest: URLRequest?
    private var nextResponseData: Data?
    private var nextResponseError: Error?
    
    
    // MARK: - Public Methods
    
    func setNextResponseParameters(nextResponseData: Data?, nextResponseError: Error?) {
        self.nextResponseData = nextResponseData
        self.nextResponseError = nextResponseError
    }
    
    
    // MARK: - URLSessionCompatible
    
    func makeRequest(
        _ request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) {
        lastRequest = request
        
        completionHandler(nextResponseData, nil, nextResponseError)
    }
}
