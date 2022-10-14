//
//  ViewController.swift
//  SquareEmployeeDirectory
//
//  Created by Roman on 2022-10-13.
//

import UIKit

class ViewController: UIViewController {
    

    // MARK: - Section
    
    private enum Section {
        case employees
    }
    
    
    // MARK: - Private Properties
    
    private lazy var collectionView: UICollectionView = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.allowsSelection = false
        
        return collectionView
    }()
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Employee> = {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Employee> { cell, indexPath, employee in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = employee.fullName
            
            cell.contentConfiguration = contentConfiguration
        }
        
        return UICollectionViewDiffableDataSource<Section, Employee>(collectionView: collectionView) { collectionView, indexPath, employee in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: employee)
        }
    }()
    
    private let employeesFetchingService: EmployeesFetchingService
    
    
    // MARK: - Init
    
    init(employeesFetchingService: EmployeesFetchingService = .init()) {
        self.employeesFetchingService = employeesFetchingService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupCollectionView()
        setupRefreshControl()
        fetchEmployees()
        
    }

    
    // MARK: - Private Methods
    
    private func setupCollectionView() {
        collectionView.dataSource = dataSource
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ].activate()
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefreshControlValueChanged(_:)), for: .valueChanged)
        
        collectionView.refreshControl = refreshControl
    }
    
    private let networkService = NetworkService()
    
    private func fetchEmployees() {
        let request = URLRequest(url: URL(string: "https://s3.amazonaws.com/sq-mobile-interview/employees.json")!)
        
        employeesFetchingService.fetchEmployees { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .failure(error):
                    self?.showAlert(title: "Error fetching Employees List", message: error.localizedDescription)
                    
                case let .success(employeeList):
                    self?.updateSnapshot(with: employeeList.employees)
                }
                
                self?.collectionView.refreshControl?.endRefreshing()
            }
        }
        
        Task {
            do {
                let smth = try await networkService.makeContinuationRequest(request)
                
                let decoder = JSONDecoder()
                let decodedObject = try decoder.decode(EmployeeList.self, from: smth)
                print(">>>Fetched with continuation: ", decodedObject.employees.count)
                
            } catch let error {
                showAlert(title: "Error processing Employees List response", message: error.localizedDescription)
            }
        }
        
    }
    
    private func updateSnapshot(with employees: [Employee]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Employee>()
        snapshot.appendSections([.employees])
        snapshot.appendItems(employees)
        
        dataSource.apply(snapshot)
    }
    
    
    // MARK: - Actions Handling
    
    @objc private func handleRefreshControlValueChanged(_ refreshControl: UIRefreshControl) {
        fetchEmployees()
    }
    
}
