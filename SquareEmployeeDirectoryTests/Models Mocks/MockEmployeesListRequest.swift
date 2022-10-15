//
//  MockEmployeesListRequest.swift
//  SquareEmployeeDirectoryTests
//
//  Created by Roman on 2022-10-14.
//

import Foundation


struct MockEmployeesListRequest: Request {
    
    typealias Model = EmployeeList
    
    var path: String
    var method: RequestType
    
}
