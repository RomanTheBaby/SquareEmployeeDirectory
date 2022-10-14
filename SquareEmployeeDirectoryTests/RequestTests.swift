//
//  RequestTests.swift
//  SquareEmployeeDirectoryTests
//
//  Created by Roman on 2022-10-14.
//

import XCTest

final class RequestTests: XCTestCase {
    
    
    // MARK: - Private Properties
    
    private let baseURL = "https://s3.amazonaws.com/sq-mobile-interview"
    
    
    // MARK: - Tests
    
    func testGetRequestBuildsSuccessfully() {
        let requestPath = "/funnyName"
        let mockRequest = MockSingleEmployeeRequest(path: requestPath, method: .get)
        
        let expectedRequest = URLRequest(url: URL(string: baseURL + requestPath)!)
        
        XCTAssertEqual(expectedRequest, mockRequest.buildURLRequest(withBaseURL: URL(string: baseURL)!))
    }
    
    func testPostRequestBuildsSuccessfully() {
        let requestPath = "/funnyName"
        let dummyRequest = MockSingleEmployeeRequest(path: requestPath, method: .post)
        let dummyURLRequest = dummyRequest.buildURLRequest(withBaseURL: URL(string: baseURL)!)
        
        var expectedRequest = URLRequest(url: URL(string: baseURL + requestPath)!)
        expectedRequest.httpMethod = RequestType.post.rawValue
        
        XCTAssertEqual(expectedRequest, dummyURLRequest)
    }

}
