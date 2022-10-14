//
//  UIViewControllerExtension.swift
//  SquareEmployeeDirectory
//
//  Created by Roman on 2022-10-14.
//

import UIKit


extension UIViewController {
    func showAlert(title: String, message: String, cancelActionTitle: String = "OK") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(.init(title: cancelActionTitle, style: .cancel))
        
        present(alertController, animated: true)
    }
}
