//
//  MockEmployeesArrayRequest.swift
//  SquareEmployeeDirectoryTests
//
//  Created by Roman on 2022-10-14.
//

import Foundation


struct MockEmployeesArrayRequest: Request {
    
    typealias Model = [Employee]
    
    var path: String
    var method: RequestType
    
}
