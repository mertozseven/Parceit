//
//  HomeViewController.swift
//  Parceit
//
//  Created by Mert Ozseven on 6.12.2024.
//

import UIKit
import SnapKit
import QRReader
import FirebaseAnalytics

final class SearchViewController: UIViewController {
    
    // MARK: - Properties
    private let searchBarView = SearchBarView()
    private let emptyView = EmptyView()
    private let qrReader = QRReader()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchBar()
    }
    
    // MARK: - Private Methods
    private func configureUI() {
        view.backgroundColor = .dynamicColor(light: .secondarySystemBackground, dark: .systemBackground)
        addViews()
        configureLayout()
        view.addDismissKeyboardGesture()
        emptyView.configure(with: "Previous Searches", body: "Couldn't find previous searches. Please enter your tracking number to the search field above. Your previous searches will appear here")
        Analytics.logEvent("HomeEvents", parameters: [
            AnalyticsParameterItemID: "Home Screen View"
        ])
    }
    
    private func addViews() {
        view.addSubview(searchBarView)
        view.addSubview(emptyView)
    }
    
    private func configureLayout() {
        searchBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalTo(view.layoutMarginsGuide.snp.leading)
            $0.trailing.equalTo(view.layoutMarginsGuide.snp.trailing)
            $0.height.equalTo(60)
        }
        emptyView.snp.makeConstraints {
            $0.top.equalTo(searchBarView.snp.bottom).offset(32)
            $0.leading.trailing.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(270)
        }
    }
    
    private func configureSearchBar() {
        searchBarView.onQRCodeTapped = { [weak self] in
            if ((self?.qrReader.isScanningAvailable()) != nil) {
                print("QR Scanner is available!")
            } else {
                print("QR Scanner is not supported on this device.")
            }
            self!.qrReader.presentScanner(from: self!) { result in
                print("Scanned code: \(result)")
            }
            
        }
        
    }
}

