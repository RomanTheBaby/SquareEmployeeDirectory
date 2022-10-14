//
//  NSErrorExtension.swift
//  SquareEmployeeDirectory
//
//  Created by Roman on 2022-10-14.
//

import Foundation


extension NSError {
    convenience init(domain: String = "com.sq-test", code: Int, localizedDescription: String) {
        self.init(
            domain: domain,
            code: code,
            userInfo: [NSLocalizedDescriptionKey: localizedDescription]
        )
    }
}
