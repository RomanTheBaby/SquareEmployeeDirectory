//
//  RequestTests.swift
//  SquareEmployeeDirectoryTests
//
//  Created by Roman on 2022-10-14.
//

import XCTest

final class RequestTests: XCTestCase {
    
    
    // MARK: - DummyEmployeeRequest
    
    struct DummyEmployeeRequest: Request {
        
        typealias Model = Employee
        
        var path: String
        var method: RequestType
        
    }
    
    
    // MARK: - Private Properties
    
    private let baseURL = "https://s3.amazonaws.com/sq-mobile-interview"
    
    
    // MARK: - Tests
    
    func testGetRequestBuildsSuccessfully() {
        let requestPath = "/funnyName"
        let dummyRequest = DummyEmployeeRequest(path: requestPath, method: .get)
        
        let expectedRequest = URLRequest(url: URL(string: baseURL + requestPath)!)
        
        XCTAssertEqual(expectedRequest, dummyRequest.buildRequest(withBaseUrl: URL(string: baseURL)!))
    }
    
    func testPostRequestBuildsSuccessfully() {
        let requestPath = "/funnyName"
        let dummyRequest = DummyEmployeeRequest(path: requestPath, method: .post)
        let dummyURLRequest = dummyRequest.buildRequest(withBaseUrl: URL(string: baseURL)!)
        
        var expectedRequest = URLRequest(url: URL(string: baseURL + requestPath)!)
        expectedRequest.httpMethod = RequestType.post.rawValue
        
        XCTAssertEqual(expectedRequest, dummyURLRequest)
    }

}
