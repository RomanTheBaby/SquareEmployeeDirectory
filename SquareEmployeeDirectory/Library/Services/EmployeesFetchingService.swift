//
//  EmployeesFetchingService.swift
//  SquareEmployeeDirectory
//
//  Created by Roman on 2022-10-13.
//

import Foundation


// MARK: - EmployeesFetchingService

class EmployeesFetchingService {
    
    
    // MARK: - Private Properties
    
    private let networkService: NetworkService

    
    // MARK: - Init
        
    init(networkService: NetworkService = .init()) {
        self.networkService = networkService
    }
    
    
    // MARK: - Fetching
    
    func fetchEmployees(
        requestType: EmployeeListRequestType = .normal,
        completion: @escaping (Result<EmployeeList, Error>) -> Void
    ) {
        let request = EmployeesListRequest(requestType: .normal)
        networkService.makeRequest(request, completion: completion)
    }
    
}


// MARK: - EmployeesListRequest

struct EmployeesListRequest: Request {
    typealias Model = EmployeeList
    
    var path: String {
        requestType.path
    }
    
    var method: RequestType {
        .get
    }
    
    var contentType: String {
        ""
    }
    
    private var requestType: EmployeeListRequestType
    
    init(requestType: EmployeeListRequestType) {
        self.requestType = requestType
    }
    
}

// MARK: - EmployeeListRequestType

enum EmployeeListRequestType {
    case normal
    case empty
    case malformed
    
    var path: String {
        switch self {
        case .normal:
            return "employees.json"
            
        case .empty:
            return "employees_empty.json"
            
        case .malformed:
            return "employees_malformed.json"
            
        }
    }
}
