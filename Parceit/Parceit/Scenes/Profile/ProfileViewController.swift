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
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .dynamicColor(
            light: .systemBackground,
            dark: .secondarySystemBackground
        )
        view.layer.cornerRadius = 10
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 16,
            leading: 16,
            bottom: 16,
            trailing: 16
        )
        
        return view
    }()
    
    private let usernameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .title3)
        label.textAlignment = .left
        
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private let emailTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .title3)
        label.textAlignment = .left
        
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private let profilePhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        
        return imageView
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
        view.backgroundColor = .dynamicColor(light: .secondarySystemBackground, dark: .systemBackground)
        addViews()
        configureLayout()
        configureLogoutButton()
    }
    
    private func addViews() {
        view.addSubview(containerView)
        containerView.addSubview(usernameTitleLabel)
        containerView.addSubview(usernameLabel)
        containerView.addSubview(emailTitleLabel)
        containerView.addSubview(emailLabel)
        containerView.addSubview(profilePhoto)
        view.addSubview(logoutButton)
    }
    
    private func configureLayout() {
        containerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.bottom.equalTo(emailLabel.snp.bottom).offset(16)
        }
        profilePhoto.snp.makeConstraints {
            $0.top.trailing.equalTo(containerView.layoutMarginsGuide)
            $0.height.width.equalTo(80)
        }
        usernameTitleLabel.snp.makeConstraints {
            $0.top.leading.equalTo(containerView.layoutMarginsGuide)
            $0.trailing.equalTo(profilePhoto.snp.leading).offset(-8)
            $0.height.equalTo(20)
        }
        usernameLabel.snp.makeConstraints {
            $0.top.equalTo(usernameTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(usernameTitleLabel)
            $0.height.equalTo(24)
        }
        emailTitleLabel.snp.makeConstraints {
            $0.top.equalTo(usernameLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(usernameTitleLabel)
            $0.height.equalTo(20)
        }
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(emailTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(usernameTitleLabel)
            $0.height.equalTo(24)
        }
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(52)
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
