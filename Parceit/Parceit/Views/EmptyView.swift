//
//  EmptyView.swift
//  Parceit
//
//  Created by Mert Ozseven on 13.12.2024.
//

import UIKit
import SnapKit

final class EmptyView: UIView {
    
    // MARK: - Properties
    private let containerView = ContainerView(
        backgroundColor: .dynamicColor(light: .systemGreen, dark: UIColor(hex: "#0f2d0e")!),
        cornerRadius: 10
    )
    
    private let shippingBoxIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "shippingbox")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .dynamicColor(light: UIColor(hex: "#0f2d0e")!, dark: .systemGreen)
        
        return imageView
    }()
    
    private let emptyTextTitle: UILabel = {
        let label = UILabel()
        label.text = "Previous Searches"
        label.textColor = .dynamicColor(light: UIColor(hex: "#0f2d0e")!, dark: .systemGreen)
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    private let emptyText: UILabel = {
        let label = UILabel()
        label.text = "Couldn't find previous searches. Please enter your tracking number to the search field above. Your previous searches will appear here"
        label.textColor = .dynamicColor(light: UIColor(hex: "#0f2d0e")!, dark: .systemGreen)
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    // MARK: - inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    public func configure(with title: String, body: String) {
        self.emptyTextTitle.text = title
        self.emptyText.text = body
    }
    
    // MARK: - Private Methods
    private func configureUI() {
        addViews()
        configureLayout()
    }
    
    private func addViews() {
        addSubview(containerView)
        containerView.addSubview(shippingBoxIcon)
        containerView.addSubview(emptyTextTitle)
        containerView.addSubview(emptyText)
    }
    
    private func configureLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        shippingBoxIcon.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
            
            $0.height.equalTo(64)
        }
        emptyTextTitle.snp.makeConstraints {
            $0.top.equalTo(shippingBoxIcon.snp.bottom).offset(24)
            $0.leading.trailing.equalTo(shippingBoxIcon)
            $0.height.equalTo(24)
        }
        emptyText.snp.makeConstraints {
            $0.top.equalTo(emptyTextTitle.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}

#Preview {
    EmptyView()
}
