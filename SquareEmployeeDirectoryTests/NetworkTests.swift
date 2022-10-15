//
//  NetworkTests.swift
//  SquareEmployeeDirectoryTests
//
//  Created by Roman on 2022-10-14.
//

import XCTest


final class NetworkTests: XCTestCase {
    
    
    // MARK: - Private Properties
    
    let mockEmployees = [
        Employee(id: "1", fullName: "R", emailAddress: "sad1@em.com", team: "Test", type: .fullTime),
        Employee(id: "2", fullName: "2", emailAddress: "sad2@em.com", team: "New", type: .contractor),
        Employee(id: "2", fullName: "2", emailAddress: "sad3@em.com", team: "Old", type: .partTime),
    ]

    
    // MARK: - Tests
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testURLRequestTriggeredSuccessfully() throws {
        let baseURL = URL(string: "https://s3.amazonaws.com/sq-mobile-interview")!
        
        let mockSession = MockURLSession()
        mockSession.setNextResponseParameters(
            nextResponseData: nil,
            nextResponseError: NSError(code: 404, localizedDescription: "This is dummy error, to make sure completion handler is called.")
        )
        let networkService = NetworkService(baseURL: baseURL, urlSession: mockSession)
        let mockRequest = MockSingleEmployeeRequest(path: "/employee", method: .get)
        
        networkService.makeRequest(mockRequest) { _ in
        }
        
        let employeeURLRequest = mockRequest.buildURLRequest(withBaseURL: baseURL)

        XCTAssertEqual(mockSession.lastRequest, employeeURLRequest)
    }
    
    func testRequestParsesErrorSuccessfully() {
        let mockError = NSError(code: 404, localizedDescription: "This is test error")
        let mockRequest = MockSingleEmployeeRequest(path: "/employeesList", method: .get)
        
        let (receivedModel, receivedError) = make(
            request: mockRequest,
            hardcodedResponseError: mockError
        )
        
        XCTAssertNil(receivedModel)
        XCTAssertNotNil(receivedError)
        
        if let receivedError = receivedError {
            XCTAssertEqual(receivedError as NSError, mockError)
        }
    }
    
    func testRequestParsesSingleModelSuccessfully() throws {
        let encoder = JSONEncoder()
        
        let mockRequest = MockSingleEmployeeRequest(path: "/employeesList", method: .get)
        
        let (receivedModel, receivedError) = make(
            request: mockRequest,
            hardcodedResponseData: try encoder.encode(mockEmployees[0])
        )
        
        XCTAssertNotNil(receivedModel)
        XCTAssertNil(receivedError)
        XCTAssertEqual(receivedModel, mockEmployees[0])
    }
    
    func testRequestParsesArrayModelSuccessfully() throws {
        let mockRequest = MockEmployeesArrayRequest(path: "/employeesList", method: .get)
        let encoder = JSONEncoder()

        let (receivedModel, receivedError) = make(
            request: mockRequest,
            hardcodedResponseData: try encoder.encode(mockEmployees)
        )
        
        XCTAssertNotNil(receivedModel)
        XCTAssertNil(receivedError)
        XCTAssertEqual(receivedModel, mockEmployees)
    }
    
    func testRequestParsesNestedModelSuccessfully() throws {
        let mockRequest = MockEmployeesListRequest(path: "/employeesList", method: .get)
        let mockEmployeesList = EmployeeList(employees: mockEmployees)

        let encoder = JSONEncoder()

        let (receivedModel, receivedError) = make(
            request: mockRequest,
            hardcodedResponseData: try encoder.encode(mockEmployeesList)
        )
        
        XCTAssertNotNil(receivedModel)
        XCTAssertNil(receivedError)
        XCTAssertEqual(receivedModel, mockEmployeesList)
    }
    
    func testRequestResponseWithErrorProducesFailure() throws {
        let mockRequest = MockEmployeesArrayRequest(path: "/employeesList", method: .get)
        let mockError = NSError(
            code: 404,
            localizedDescription: "If error is present in response, then only error object should be returned"
        )
        let encoder = JSONEncoder()

        let (receivedModel, receivedError) = make(
            request: mockRequest,
            hardcodedResponseData: try encoder.encode(mockEmployees),
            hardcodedResponseError: mockError
        )
        
        XCTAssertNil(receivedModel)
        XCTAssertNotNil(receivedError)
        
        if let receivedError = receivedError {
            XCTAssertEqual(mockError, receivedError as NSError)
        }
    }
    
    
    // MARK: - Private Helpers
    
    private func make<R: Request>(
        request: R,
        hardcodedResponseData: Data? = nil,
        hardcodedResponseError: Error? = nil
    ) -> (receivedModel: R.Model?, receivedError: Error?) {
        let baseURL = URL(string: "https://s3.amazonaws.com/sq-mobile-interview")!
        
        let mockSession = MockURLSession()
        mockSession.setNextResponseParameters(nextResponseData: hardcodedResponseData, nextResponseError: hardcodedResponseError)
        
        let networkService = NetworkService(baseURL: baseURL, urlSession: mockSession)
        
        let expectation = XCTestExpectation(description: #function)
        
        var receivedModel: R.Model?
        var receivedError: Error?
        
        networkService.makeRequest(request) { result in
            switch result {
            case let .success(model):
                receivedModel = model
                
            case let .failure(error):
                receivedError = error
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        
        return (receivedModel, receivedError)
    }
}
