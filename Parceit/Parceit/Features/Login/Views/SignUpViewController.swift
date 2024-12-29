//
//  SignUpViewController.swift
//  Parceit
//
//  Created by Mert Ozseven on 27.12.2024.
//

import UIKit
import SnapKit

final class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    private let cargoLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "shippingbox.fill")
        imageView.tintColor = .accent
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let signUpTitle: UILabel = {
        let label = UILabel()
        label.text = "Sign Up"
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 40, weight: .heavy)
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private let signUpText: UILabel = {
        let label = UILabel()
        label.text = "Create your account"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .dynamicColor(light: .systemBackground, dark: .tertiarySystemBackground)
        textField.keyboardType = .default
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.textContentType = .username
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.rightView = rightView
        textField.rightViewMode = .always
        
        return textField
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
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .accent
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        
        return button
    }()
    
    private let termsTextView: UITextView = {
        let textView = UITextView()

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let baseAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.secondaryLabel,
            .font: UIFont.preferredFont(forTextStyle: .footnote),
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedString = NSMutableAttributedString(
            string: "By creating an account, you agree to our Terms & Conditions and acknowledge that you have read our Privacy Policy.",
            attributes: baseAttributes
        )
        
        let termsRange = (attributedString.string as NSString).range(of: "Terms & Conditions")
        let privacyRange = (attributedString.string as NSString).range(of: "Privacy Policy")
        
        attributedString.addAttributes(
            [.link: "terms://termsAndConditions", .foregroundColor: UIColor.accent],
            range: termsRange
        )
        
        attributedString.addAttributes(
            [.link: "privacy://privacyPolicy", .foregroundColor: UIColor.accent],
            range: privacyRange
        )
        
        textView.attributedText = attributedString
        textView.linkTextAttributes = [.foregroundColor: UIColor.accent]
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = true
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        textView.delaysContentTouches = false
        
        return textView
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Have an account? Sign In", for: .normal)
        button.setTitleColor(.accent, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Private Methods
    private func configureView() {
        view.backgroundColor = .dynamicColor(light: .secondarySystemBackground, dark: .systemBackground)
        view.addDismissKeyboardGesture()
        termsTextView.delegate = self
        addViews()
        configureLayout()
        configureActions()
    }
    
    private func addViews() {
        view.addSubview(cargoLogo)
        view.addSubview(signUpTitle)
        view.addSubview(signUpText)
        view.addSubview(usernameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpButton)
        view.addSubview(termsTextView)
        view.addSubview(signInButton)
    }
    
    private func configureLayout() {
        cargoLogo.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(100)
        }
        signUpTitle.snp.makeConstraints {
            $0.top.equalTo(cargoLogo.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(40)
        }
        signUpText.snp.makeConstraints {
            $0.top.equalTo(signUpTitle.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(20)
        }
        usernameTextField.snp.makeConstraints {
            $0.top.equalTo(signUpText.snp.bottom).offset(32)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(52)
        }
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(usernameTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(52)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(52)
        }
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(32)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(52)
        }
        termsTextView.snp.makeConstraints {
            $0.top.equalTo(signUpButton.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.centerX.equalToSuperview()
        }
        signInButton.snp.makeConstraints {
            $0.top.equalTo(termsTextView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(24)
        }
    }
    
    private func configureActions() {
        showPasswordButton.addTarget(self, action: #selector(showPasswordButtonTapped), for: .touchUpInside)
        passwordTextField.rightView = showPasswordButton
        passwordTextField.rightViewMode = .always
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
    }
    
    private func showWebViewer(with urlString: String) {
        let webViewer = WebViewController(with: urlString)
        let nav = UINavigationController(rootViewController: webViewer)
        present(nav, animated: true)
    }
    
    // MARK: - Objective Methods
    @objc private func showPasswordButtonTapped() {
        passwordTextField.isSecureTextEntry.toggle()
        let button = showPasswordButton
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        button.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func didTapSignUpButton() {
        let registerUserRequest = RegisterUserRequest(
            username: usernameTextField.text ?? "",
            email: emailTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
        
        // Username check
        if !Validator.isValidUsername(for: registerUserRequest.username) {
            AlertManager.showInvalidUsernameAlert(on: self)
            return
        }
        
        // Email check
        if !Validator.isValidEmail(for: registerUserRequest.email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        // Password check
        if !Validator.isPasswordValid(for: registerUserRequest.password) {
            AlertManager.showInvalidPasswordAlert(on: self)
            return
        }
        
        AuthService.shared.registerUser(with: registerUserRequest) { [weak self] wasRegistered, error in
            guard let self else { return }
            
            if let error = error {
                AlertManager.showRegistrationErrorAlert(on: self, with: error)
                return
            }
            
            if wasRegistered {
                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.checkAuthentication()
                }
            } else {
                AlertManager.showRegistrationErrorAlert(on: self)
            }
        }
    }
    
    @objc private func didTapSignInButton() {
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SignUpViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "terms" {
            showWebViewer(with: "https://policies.google.com/terms?hl=en")
        } else if URL.scheme == "privacy" {
            showWebViewer(with: "https://policies.google.com/privacy?hl=en")
        }
        
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.delegate = nil
        textView.selectedTextRange = nil
        textView.delegate = self
    }
    
}
