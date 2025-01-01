//
//  AddCodeViewController.swift
//  Parceit
//
//  Created by Mert Ozseven on 16.12.2024.
//

import UIKit
import SnapKit

protocol AddCodeViewControllerDelegate: AnyObject {
    func didAddQRCode(_ qrCode: QRCode)
}

final class AddCodeViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: AddCodeViewControllerDelegate?
    var viewModel: CreateViewModel?
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter a title"
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.textAlignment = .left
        
        return label
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter title"
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .dynamicColor(light: .systemBackground, dark: .tertiarySystemBackground)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let qrCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter a text to convert to a QR Code"
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.textAlignment = .left
        
        return label
    }()
    
    private let qrCodeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter QR code string"
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .dynamicColor(light: .systemBackground, dark: .tertiarySystemBackground)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add QR Code", for: .normal)
        button.backgroundColor = .accent
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Inits
    init(viewModel: CreateViewModel? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func configureUI() {
        view.backgroundColor = .dynamicColor(light: .secondarySystemBackground, dark: .systemBackground)
        
        addViews()
        configureLayout()
        configureActions()
        setupKeyboardObservers()
        view.addDismissKeyboardGesture()
    }
    
    private func addViews() {
        view.addSubview(closeButton)
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(qrCodeLabel)
        view.addSubview(qrCodeTextField)
        view.addSubview(addButton)
    }
    
    private func configureLayout() {
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalTo(view.layoutMarginsGuide)
            $0.width.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(32)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(20)
        }
        
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(44)
        }
        
        qrCodeLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(32)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(20)
        }
        
        qrCodeTextField.snp.makeConstraints {
            $0.top.equalTo(qrCodeLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(titleTextField)
            $0.height.equalTo(44)
        }
        
        addButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(50)
        }
    }
    
    private func configureActions() {
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func adjustAddButtonPosition(keyboardHeight: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.addButton.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Objective Methods
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height 
            adjustAddButtonPosition(keyboardHeight: keyboardHeight)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        adjustAddButtonPosition(keyboardHeight: 0)
    }
    
    @objc private func addButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty,
              let qrCodeString = qrCodeTextField.text, !qrCodeString.isEmpty else {
            return
        }
        
        let newQRCode = QRCode(title: title, qrCodeString: qrCodeString)
        delegate?.didAddQRCode(newQRCode)
        dismiss(animated: true)
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}

#Preview {
    AddCodeViewController()
}
