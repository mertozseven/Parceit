//
//  ForgotPasswordViewController.swift
//  Parceit
//
//  Created by Mert Ozseven on 27.12.2024.
//

import UIKit
import SnapKit

class ForgotPasswordViewController: UIViewController {
    
    // MARK: - Properties
    private let cargoLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "shippingbox.fill")
        imageView.tintColor = .accent
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let forgotPasswordTitle: UILabel = {
        let label = UILabel()
        label.text = "Forgot Password"
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 40, weight: .heavy)
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private let forgotPasswordText: UILabel = {
        let label = UILabel()
        label.text = "Reset your password"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .dynamicColor(light: .systemBackground, dark: .tertiarySystemBackground)
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.textContentType = .emailAddress
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.rightView = rightView
        textField.rightViewMode = .always
        
        return textField
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send verification code", for: .normal)
        button.backgroundColor = .accent
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Private Methods
    private func configureView() {
        view.backgroundColor = .dynamicColor(light: .secondarySystemBackground, dark: .systemBackground)
        view.addDismissKeyboardGesture()
        addViews()
        configureLayout()
        configureActions()
    }
    
    private func addViews() {
        view.addSubview(cargoLogo)
        view.addSubview(forgotPasswordTitle)
        view.addSubview(forgotPasswordText)
        view.addSubview(emailTextField)
        view.addSubview(forgotPasswordButton)
    }
    
    private func configureLayout() {
        cargoLogo.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(100)
        }
        forgotPasswordTitle.snp.makeConstraints {
            $0.top.equalTo(cargoLogo.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(40)
        }
        forgotPasswordText.snp.makeConstraints {
            $0.top.equalTo(forgotPasswordTitle.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(20)
        }
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(forgotPasswordText.snp.bottom).offset(32)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(52)
        }
        forgotPasswordButton.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(52)
        }
    }
    
    private func configureActions() {
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPasswordButton), for: .touchUpInside)
    }
    
    // MARK: - Objective Methods
    @objc private func didTapForgotPasswordButton() {
        let email = emailTextField.text ?? ""
        
        if !Validator.isValidEmail(for: email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        AuthService.shared.forgotPassword(with: email) { [weak self] error in
            guard let self else { return }
            if let error = error {
                AlertManager.showErrorSendingPasswordReset(on: self, with: error)
                return
            }
            
            AlertManager.showPasswordResetSent(on: self)
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }

}

#Preview {
    ForgotPasswordViewController()
}
