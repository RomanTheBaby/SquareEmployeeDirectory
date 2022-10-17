//
//  EmoployeeBoardEmptyStateView.swift
//  SquareEmployeeDirectory
//
//  Created by Roman on 2022-10-17.
//

import UIKit

class StateView: UIView {
    
    
    // MARK: - State
    
    enum State {
        case noContent
        case loadingContent
    }
    
    
    // MARK: - Constants
    
    private enum Constants {
        enum Text {
            static let horizontalInsets: CGFloat = 16
        }
    }
    
    
    // MARK: - Private Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        
        return label
    }()
    

    // MARK: - Init
    
    init(state: State = .loadingContent) {
        super.init(frame: .zero)
        
        setupLayout()
        adjust(forState: state)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported. Please use init(text:) instead")
    }
    
    
    // MARK: - Public Methods
    
    func adjust(forState state: State) {
        switch state {
        case .noContent:
            titleLabel.text = "No content to display"
            
        case .loadingContent:
            titleLabel.text = "Loading data..."
            
        }
    }
    
    
    // MARK: - Private Methods
    
    private func setupLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        [
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Text.horizontalInsets),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Text.horizontalInsets),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ].activate()
        
    }
    
}
