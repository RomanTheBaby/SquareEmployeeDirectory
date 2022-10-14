//
//  UIViewControllerExtension.swift
//  SquareEmployeeDirectory
//
//  Created by Roman on 2022-10-14.
//

import UIKit


extension UIViewController {
    func showAlert(
        title: String,
        message: String,
        actions: [UIAlertAction] = [],
        cancelActionTitle: String = "OK"
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        actions.forEach(alertController.addAction(_:))
        
        alertController.addAction(.init(title: cancelActionTitle, style: .cancel))
        
        present(alertController, animated: true)
    }
}
