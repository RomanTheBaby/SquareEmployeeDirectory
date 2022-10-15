//
//  ViewController.swift
//  SquareEmployeeDirectory
//
//  Created by Roman on 2022-10-13.
//

import UIKit

// TODO: Add Readme
class EmployeeBoardViewController: UIViewController, UIContextMenuInteractionDelegate {
    

    // MARK: - Section
    
    private enum Section {
        case employees
    }
    
    
    // MARK: - Constants
    
    enum Constants {
        enum EmployeeImage {
            static let maxSize = CGSize(width: 32, height: 32)
        }
        
        enum NavigationTitle {
            static let `default` = "Employee Board"
            static let loading = "Loading..."
        }
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
            contentConfiguration.secondaryText = employee.team
            contentConfiguration.imageProperties.maximumSize = Constants.EmployeeImage.maxSize
            contentConfiguration.imageProperties.reservedLayoutSize = Constants.EmployeeImage.maxSize
            contentConfiguration.imageProperties.cornerRadius = Constants.EmployeeImage.maxSize.width / 2
            
            if let url = employee.photoURLLarge ?? employee.photoURLSmall {
                if let cachedImage = self.imageFetchingService.cachedImage(for: url) {
                    contentConfiguration.image = cachedImage
                } else {
                    contentConfiguration.image = #imageLiteral(resourceName: "AvatarPlaceholder.png")
                    self.imageFetchingService.loadImage(at: url) { [weak self] result in
                        guard let self = self, case let .success(image) = result else {
                            return
                        }
                        
                        DispatchQueue.main.async {
                            var updatedSnapshot = self.dataSource.snapshot()
                            updatedSnapshot.reloadItems([employee])
                            self.dataSource.apply(updatedSnapshot, animatingDifferences: true)
                        }
                    }
                }
            }
            
            cell.contentConfiguration = contentConfiguration
        }
        
        return UICollectionViewDiffableDataSource<Section, Employee>(collectionView: collectionView) { collectionView, indexPath, employee in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: employee)
        }
    }()
    
    private let employeesFetchingService: EmployeesFetchingService
    private let imageFetchingService: ImageFetchingService = .init()
    
    
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
        
        setupInterface()
        fetchEmployees()
        
    }

    
    // MARK: - Private Methods
    
    private func setupInterface() {
        title = Constants.NavigationTitle.default
        
        setupNavigationBarActions()
        setupCollectionView()
        setupRefreshControl()
    }
    
    private func setupNavigationBarActions() {
        let button = UIButton(type: .system)
        button.setTitle("Hold Me", for: .normal)

        let interaction = UIContextMenuInteraction(delegate: self)
        button.addInteraction(interaction)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
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
    
    private func fetchEmployees(listType: EmployeesFetchingService.ListType = .normal) {
        title = Constants.NavigationTitle.loading
        
        employeesFetchingService.fetchEmployees(listType: listType) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .failure(error):
                    self?.showAlert(
                        title: "Error fetching Employees List",
                        message: error.localizedDescription,
                        actions: [
                            .init(title: "Clear current list?", style: .default, handler: { _ in
                                self?.updateSnapshot(with: [])
                            }),
                        ]
                    )
                    
                case let .success(employeeList):
                    self?.updateSnapshot(with: employeeList.employees)
                }
                
                self?.title = "Employee Board"
                self?.collectionView.refreshControl?.endRefreshing()
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
        fetchEmployees(listType: .normal)
    }
    
    // MARK: - UIContextMenuInteractionDelegate
    
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
            let fetchNormalListAction = UIAction(
                title: "Normal List",
                image:  UIImage(systemName: "arrow.up.square")
            ) { action in
                self.fetchEmployees(listType: .normal)
            }
            
            let fetchMalformedListAction = UIAction(
                title: "Malformed List",
                image: UIImage(systemName: "plus.square.on.square")
            ) { action in
                self.fetchEmployees(listType: .malformed)
            }
            
            let fetchEmptyListAction = UIAction(
                title: "Empty List",
                image:  UIImage(systemName: "trash")
            ) { action in
                self.fetchEmployees(listType: .empty)
            }
                                            
            return UIMenu(
                title: "What kind of list should be fetched???",
                children: [fetchNormalListAction, fetchMalformedListAction, fetchEmptyListAction]
            )
        })
    }
    
}
