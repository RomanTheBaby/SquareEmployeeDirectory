//
//  EmployeesFetchingService.swift
//  SquareEmployeeDirectory
//
//  Created by Roman on 2022-10-13.
//

import Foundation


// MARK: - EmployeesFetchingService

class EmployeesFetchingService {
    
    
    // MARK: - EmployeeListRequestType

    enum ResultType {
        case normal
        case empty
        case malformed
    }
    
    
    // MARK: - Private Properties
    
    private let networkService: NetworkService

    
    // MARK: - Init
        
    init(networkService: NetworkService = .init()) {
        self.networkService = networkService
    }
    
    
    // MARK: - Fetching
    
    func fetchEmployees(
        resultType: ResultType = .normal,
        completion: @escaping (Result<EmployeeList, Error>) -> Void
    ) {
        let request = EmployeesListRequest(resultType: resultType)
        networkService.makeRequest(request, completion: completion)
    }
    
}


// MARK: - EmployeesListRequest

private struct EmployeesListRequest: Request {
    typealias Model = EmployeeList
    
    var path: String {
        switch resultType {
        case .normal:
            return "employees.json"
            
        case .empty:
            return "employees_empty.json"
            
        case .malformed:
            return "employees_malformed.json"
            
        }
    }
    
    var method: RequestType {
        .get
    }
    
    private var resultType: EmployeesFetchingService.ResultType
    
    init(resultType: EmployeesFetchingService.ResultType) {
        self.resultType = resultType
    }
    
}
