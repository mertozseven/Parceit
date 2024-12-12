//
//  TopDateView.swift
//  Parceit
//
//  Created by Mert Ozseven on 9.12.2024.
//

import UIKit
import SnapKit

class TopDateView: UIView {
    
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Parceit"
        label.textAlignment = .left
        label.textColor = .label
        label.font = .systemFont(ofSize: 44, weight: .black)
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        
        return label
    }()                                  
    
    // MARK: - inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    public func configureWithCurrentDateAndGreeting() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = " E d MMM"
        let currentDate = dateFormatter.string(from: Date())
        dateLabel.text = currentDate
    }
    
    // MARK: - Private methods
    private func configureView() {
        backgroundColor = .clear
        addViews()
        configureLayout()
        configureWithCurrentDateAndGreeting()
    }
    
    private func addViews() {
        addSubview(titleLabel)
        addSubview(dateLabel)
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.leading.equalTo(4)
            $0.height.equalTo(52)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
}

#Preview {
    return TopDateView()
}
