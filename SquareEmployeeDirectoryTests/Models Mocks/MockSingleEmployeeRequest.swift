//
//  MockSingleEmployeeRequest.swift
//  SquareEmployeeDirectoryTests
//
//  Created by Roman on 2022-10-14.
//

import Foundation

struct MockSingleEmployeeRequest: Request {
    
    typealias Model = Employee
    
    var path: String
    var method: RequestType
    
}
