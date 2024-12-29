//
//  LoginViewController.swift
//  Parceit
//
//  Created by Mert Ozseven on 26.12.2024.
//

import UIKit
import SnapKit

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    private let cargoLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "shippingbox.fill")
        imageView.tintColor = .accent
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let welcomeTitle: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Parceit"
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 40, weight: .heavy)
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private let signInText: UILabel = {
        let label = UILabel()
        label.text = "Sign in to your account"
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
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .dynamicColor(light: .systemBackground, dark: .tertiarySystemBackground)
        textField.isSecureTextEntry = true
        textField.textContentType = .password
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let showPasswordButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "eye")
        config.imagePadding = 16
        config.baseForegroundColor = .systemGray3
        button.configuration = config
        
        return button
    }()
    
    private let signinButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .accent
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Don't have an account? Sign Up", for: .normal)
        button.setTitleColor(.accent, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Forgot password?", for: .normal)
        button.setTitleColor(.accent, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        
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
        DispatchQueue.main.async { [weak self] in
            let splashVC = SplashViewController()
            let nav = UINavigationController(rootViewController: splashVC)
            nav.isModalInPresentation = true
            self?.navigationController?.present(nav, animated: true)
        }
    }
    
    private func addViews() {
        view.addSubview(cargoLogo)
        view.addSubview(welcomeTitle)
        view.addSubview(signInText)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signinButton)
        view.addSubview(signUpButton)
        view.addSubview(forgotPasswordButton)
    }
    
    private func configureLayout() {
        cargoLogo.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(100)
        }
        welcomeTitle.snp.makeConstraints {
            $0.top.equalTo(cargoLogo.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(40)
        }
        signInText.snp.makeConstraints {
            $0.top.equalTo(welcomeTitle.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(20)
        }
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(signInText.snp.bottom).offset(32)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(52)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(52)
        }
        signinButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(32)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(52)
        }
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(signinButton.snp.bottom).offset(24)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(24)
        }
        forgotPasswordButton.snp.makeConstraints {
            $0.top.equalTo(signUpButton.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(24)
        }
    }
    
    private func configureActions() {
        showPasswordButton.addTarget(self, action: #selector(showPasswordButtonTapped), for: .touchUpInside)
        passwordTextField.rightView = showPasswordButton
        passwordTextField.rightViewMode = .always
        signinButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPasswordButton), for: .touchUpInside)
    }
    
    // MARK: - Objective Methods
    @objc private func didTapSignInButton() {
        let loginRequest = LoginUserRequest(
            email: emailTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
        // Email check
        if !Validator.isValidEmail(for: loginRequest.email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        // Password check
        if !Validator.isPasswordValid(for: loginRequest.password) {
            AlertManager.showInvalidPasswordAlert(on: self)
            return
        }
        AuthService.shared.signIn(with: loginRequest) { [weak self] error in
            guard let self else { return }
            
            if let error = error {
                AlertManager.showSignInErrorAlert(on: self, with: error)
                return
            }
            
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            } else {
                AlertManager.showSignInErrorAlert(on: self)
            }
        }
    }
    
    @objc private func didTapSignUpButton() {
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapForgotPasswordButton() {
        let vc = ForgotPasswordViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func showPasswordButtonTapped() {
        passwordTextField.isSecureTextEntry.toggle()
        let button = showPasswordButton
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        button.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
}
