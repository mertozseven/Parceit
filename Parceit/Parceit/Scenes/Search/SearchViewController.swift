//
//  SearchViewController.swift
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
    private var isLoading = false 
    
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
        emptyView.configure(
            with: "Previous Searches",
            body: "Couldn't find previous searches. Please enter your tracking number in the search field above. Your previous searches will appear here."
        )
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
            guard let self else { return }
            
            if self.qrReader.isScanningAvailable() {
                self.qrReader.presentScanner(from: self) { [weak self] result in
                    guard let self else { return }
                    print("Scanned code: \(result)")
                    self.searchBarView.searchTextField.text = result
                    self.fetchTrackingInfo(trackingCode: result)
                    
                }
            } else {
                AlertManager.showTrackingErrorAlert(on: self, with: "QR Scanner is not supported on this device.")
            }
        }
    }
    
    private func fetchTrackingInfo(trackingCode: String) {
        guard !isLoading else { return }
        isLoading = true
        
        API.shared.fetchTrackingInfo(trackingCode: trackingCode) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let trackingData):
                    if let trackings = trackingData.data?.trackings,
                       let firstTracking = trackings.first,
                       let shipmentId = firstTracking.shipment?.shipmentId,
                       shipmentId.isEmpty == false {
                        print("Valid Tracking Data: \(trackingData)")
                        self.navigateToDetailViewController(with: trackingData)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.dismiss(animated: true)
                        }
                    } else {
                        print("Invalid Tracking Code")
                        self.dismiss(animated: true)
                        AlertManager.showTrackingErrorAlert(on: self, with: "The tracking code is invalid or not found. Please try another code.")
                    }
                case .failure(let error):
                    print("Error fetching tracking info: \(error.localizedDescription)")
                    self.dismiss(animated: true)
                    AlertManager.showTrackingErrorAlert(on: self, with: "Failed to fetch tracking info. Please check your connection or try again.")
                }
            }
        }
    }
    
    private func navigateToDetailViewController(with tracking: Tracking) {
        let detailVC = TrackingDetailViewController(tracking: tracking)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
