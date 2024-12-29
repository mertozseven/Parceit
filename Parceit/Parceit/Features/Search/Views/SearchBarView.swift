//
//  SearchBarView.swift
//  Parceit
//
//  Created by Mert Ozseven on 12.12.2024.
//

import UIKit
import SnapKit

final class SearchBarView: UIView {
    
    // MARK: - Properties
    var onQRCodeTapped: (() -> Void)?
    
    private let containerView = ContainerView(
        backgroundColor: .dynamicColor(light: .systemBackground, dark: .secondarySystemBackground),
        cornerRadius: 10
    )
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.placeholder = "Enter your tracking code"
        textField.textColor = .dynamicColor(light: UIColor(hex: "#0f2d0e")!, dark: .systemGreen)
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        return textField
    }()
    
    private let searchIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let qrCodeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "qrcode")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func configureUI() {
        configureTextField()
        addViews()
        configureLayout()
    }
    
    private func addViews() {
        addSubview(containerView)
        containerView.addSubview(searchTextField)
    }
    
    private func configureLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        searchTextField.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }
    
    private func configureTextField() {
        let leftContainer = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        searchIcon.frame = CGRect(x: 8, y: 7, width: 30, height: 30)
        leftContainer.addSubview(searchIcon)
        
        let rightContainer = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        qrCodeIcon.frame = CGRect(x: 6, y: 7, width: 30, height: 30)
        rightContainer.addSubview(qrCodeIcon)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(qrCodeTapped))
        rightContainer.addGestureRecognizer(tapGesture)
        rightContainer.isUserInteractionEnabled = true
        
        searchTextField.leftView = leftContainer
        searchTextField.rightView = rightContainer
    }
    
    // MARK: - Public Methods
    func configure(with text: String) {
        searchTextField.text = text
    }
    
    // MARK: - Objective Methods
    @objc private func qrCodeTapped() {
        onQRCodeTapped?()
    }
}

#Preview {
    SearchBarView()
}
