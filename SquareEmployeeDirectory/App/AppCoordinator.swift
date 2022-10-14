//
//  AppCoordinator.swift
//  SquareEmployeeDirectory
//
//  Created by Roman on 2022-10-14.
//

import UIKit


final class AppCoordinator {
    
    
    // MARK: - Private Methods
    
    private let window: UIWindow
    
    
    // MARK: - Init
    
    init(windowScene: UIWindowScene) {
        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .systemBackground
        
        self.window = window
    }
    
    
    // MARK: - Public Methods
    
    func start() {
        window.rootViewController = UINavigationController(rootViewController: EmployeeBoardViewController())
        window.makeKeyAndVisible()
    }
    
}
