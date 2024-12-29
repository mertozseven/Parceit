//
//  SplashViewController.swift
//  Parceit
//
//  Created by Mert Ozseven on 26.12.2024.
//

import UIKit
import SnapKit

final class SplashViewController: UIViewController {
    
    // MARK: - Properties
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to \nParceit"
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 40, weight: .heavy)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = false
        
        return label
    }()
    
    private let parcelIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "shippingbox.fill")
        imageView.tintColor = .systemYellow
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let trackingTitle: UILabel = {
        let label = UILabel()
        label.text = "Track Your Parcel"
        label.textAlignment = .left
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .title2)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = false
        
        return label
    }()
    
    private let trackingDescription: UILabel = {
        let label = UILabel()
        label.text = "Stay updated with real-time tracking information 🚚"
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = false
        
        return label
    }()
    
    
    private let qrReaderIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "qrcode.viewfinder")
        imageView.tintColor = .systemGreen
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let qrReaderTitle: UILabel = {
        let label = UILabel()
        label.text = "Scan QR and Barcodes"
        label.textAlignment = .left
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .title2)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = false
        
        return label
    }()
    
    private let qrReaderDescription: UILabel = {
        let label = UILabel()
        label.text = "Easily scan QR codes and barcodes to track your parcels 📦"
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = false
        
        return label
    }()
    
    private let qrGeneratorIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "qrcode")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let qrGeneratorTitle: UILabel = {
        let label = UILabel()
        label.text = "Generate QR Codes"
        label.textAlignment = .left
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .title2)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = false
        
        return label
    }()
    
    private let qrGeneratorDescription: UILabel = {
        let label = UILabel()
        label.text = "Create QR codes for your parcels to share tracking details ✨"
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = false
        
        return label
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.titleLabel?.textAlignment = .center
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Private Methods
    private func configureView() {
        addViews()
        configureLayout()
        continueButtonTapped()
        view.backgroundColor = .systemBackground
    }
    
    private func addViews() {
        view.addSubview(welcomeLabel)
        view.addSubview(parcelIcon)
        view.addSubview(trackingTitle)
        view.addSubview(trackingDescription)
        view.addSubview(qrReaderIcon)
        view.addSubview(qrReaderTitle)
        view.addSubview(qrReaderDescription)
        view.addSubview(qrGeneratorIcon)
        view.addSubview(qrGeneratorTitle)
        view.addSubview(qrGeneratorDescription)
        view.addSubview(continueButton)
    }
    
    private func configureLayout() {
        welcomeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(48)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(96)
        }
        
        parcelIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(40)
            $0.height.width.equalTo(56)
            $0.top.equalTo(trackingTitle.snp.top).offset(24)
        }
        
        trackingTitle.snp.makeConstraints {
            $0.leading.equalTo(parcelIcon.snp.trailing).offset(16)
            $0.top.equalTo(welcomeLabel.snp.bottom).offset(16)
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(48)
        }
        
        trackingDescription.snp.makeConstraints {
            $0.leading.equalTo(parcelIcon.snp.trailing).offset(16)
            $0.top.equalTo(trackingTitle.snp.bottom).offset(-8)
            $0.width.equalTo(UIScreen.main.bounds.width / 2 + 40)
            $0.height.equalTo(48)
        }
        
        qrReaderIcon.snp.makeConstraints {
            $0.leading.equalTo(parcelIcon.snp.leading)
            $0.top.equalTo(qrReaderTitle.snp.top).offset(16)
            $0.width.height.equalTo(56)
        }
        
        qrReaderTitle.snp.makeConstraints {
            $0.leading.equalTo(qrReaderIcon.snp.trailing).offset(16)
            $0.top.equalTo(trackingDescription.snp.bottom).offset(32)
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(24)
        }
        
        qrReaderDescription.snp.makeConstraints {
            $0.leading.equalTo(qrReaderIcon.snp.trailing).offset(16)
            $0.top.equalTo(qrReaderTitle.snp.bottom).offset(2)
            $0.width.equalTo(UIScreen.main.bounds.width / 2 + 40)
            $0.height.equalTo(72)
        }
        
        qrGeneratorIcon.snp.makeConstraints {
            $0.leading.equalTo(parcelIcon.snp.leading)
            $0.top.equalTo(qrGeneratorTitle.snp.top).offset(16)
            $0.width.height.equalTo(56)
        }
        
        qrGeneratorTitle.snp.makeConstraints {
            $0.leading.equalTo(qrGeneratorIcon.snp.trailing).offset(16)
            $0.top.equalTo(qrReaderDescription.snp.bottom).offset(32)
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(24)
        }
        
        qrGeneratorDescription.snp.makeConstraints {
            $0.leading.equalTo(qrGeneratorIcon.snp.trailing).offset(16)
            $0.top.equalTo(qrGeneratorTitle.snp.bottom).offset(2)
            $0.width.equalTo(UIScreen.main.bounds.width / 2 + 40)
            $0.height.equalTo(72)
        }
        
        continueButton.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom).inset(45)
            $0.width.equalTo(UIScreen.main.bounds.width / 2 + 40)
            $0.height.equalTo(48)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func continueButtonTapped() {
        continueButton.addTarget(self, action: #selector(continueButtonAction), for: .touchUpInside)
    }
    
    // MARK: - Objective Methods
    @objc private func continueButtonAction() {
        dismiss(animated: true)
    }
}

#Preview {
    SplashViewController()
}
