//
//  ProfileViewController.swift
//  Parceit
//
//  Created by Mert Ozseven on 13.12.2024.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Mert Adem Ozseven"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "mert@parceit.com"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log Out", for: .normal)
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
        fetchUser()
    }
    
    // MARK: - Private Methods
    private func configureView() {
        addViews()
        configureLayout()
        configureLogoutButton()
    }
    
    private func addViews() {
        view.addSubview(logoutButton)
        view.addSubview(usernameLabel)
        view.addSubview(emailLabel)
    }
    
    private func configureLayout() {
        usernameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(20)
        }
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(usernameLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(20)
        }
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(44)
        }
    }
    
    private func configureLogoutButton() {
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    private func fetchUser() {
        AuthService.shared.fetchUser { [weak self] user, error in
            guard let self else { return }
            if let error = error {
                AlertManager.showFetchingUserError(on: self, with: error)
                return
            }
            if let user = user {
                self.usernameLabel.text = user.username
                self.emailLabel.text = user.email
            }
        }
    }
    
    // MARK: - Objective Methods
    @objc private func logoutButtonTapped() {
        AuthService.shared.signOut { [weak self] error in
            guard let self else { return }
            if let error = error {
                AlertManager.showSignOutErrorAlert(on: self, with: error)
                return
            }
            
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
    }
}
