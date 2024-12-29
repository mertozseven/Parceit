//
//  PITextField.swift
//  Parceit
//
//  Created by Mert Ozseven on 27.12.2024.
//

import UIKit

class PITextField: UITextField {

    // MARK: - Properties
    enum PITextFieldType {
        case email
        case password
        case fullName
    }
    
    private let authFieldType: PITextFieldType
    private let leftpaddingView = UIView()
    
    
    // MARK: - Inits
    init(fieldType: PITextFieldType) {
        self.authFieldType = fieldType
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func configureView() {
        backgroundColor = .dynamicColor(light: .systemBackground, dark: .secondarySystemBackground)
        layer.cornerRadius = 10
        returnKeyType = .done
        autocorrectionType = .no
        autocapitalizationType = .none
    }

}
