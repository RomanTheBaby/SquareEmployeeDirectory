//
//  NSLayoutConstraintExtension.swift
//  SquareEmployeeDirectory
//
//  Created by Roman on 2022-10-14.
//

import UIKit


extension Array where Element == NSLayoutConstraint {
    func activate() {
        NSLayoutConstraint.activate(self)
    }
}
