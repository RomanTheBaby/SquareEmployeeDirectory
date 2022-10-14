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

    enum ListType {
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
        listType: ListType = .normal,
        completion: @escaping (Result<EmployeeList, Error>) -> Void
    ) {
        let request = EmployeesListRequest(listType: listType)
        networkService.makeRequest(request, completion: completion)
    }
    
}


// MARK: - EmployeesListRequest

private struct EmployeesListRequest: Request {
    typealias Model = EmployeeList
    
    var path: String {
        switch listType {
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
    
    private var listType: EmployeesFetchingService.ListType
    
    init(listType: EmployeesFetchingService.ListType) {
        self.listType = listType
    }
    
}
