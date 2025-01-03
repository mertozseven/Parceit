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
    private let recentSearchesKey = "recentSearchesKey"
    private var recentSearches: [String] = [] {
        didSet {
            recentSearchTableView.reloadData()
            recentSearchTableView.isHidden = recentSearches.isEmpty
            emptyView.isHidden = !recentSearches.isEmpty
        }
    }

    private lazy var recentSearchTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecentSearchCell.self, forCellReuseIdentifier: RecentSearchCell.identifier)
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .dynamicColor(light: .secondarySystemBackground, dark: .systemBackground)
        tableView.isUserInteractionEnabled = true
        return tableView
    }()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRecentSearches()
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
        view.addSubview(recentSearchTableView)
        view.addSubview(emptyView)
    }

    private func configureLayout() {
        searchBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalTo(view.layoutMarginsGuide.snp.leading)
            $0.trailing.equalTo(view.layoutMarginsGuide.snp.trailing)
            $0.height.equalTo(60)
        }

        recentSearchTableView.snp.makeConstraints {
            $0.top.equalTo(searchBarView.snp.bottom).offset(16)
            $0.leading.equalTo(view.layoutMarginsGuide.snp.leading)
            $0.trailing.equalTo(view.layoutMarginsGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
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
                    self.addSearchToRecent(result)
                    self.fetchTrackingInfo(trackingCode: result)
                }
            } else {
                AlertManager.showTrackingErrorAlert(on: self, with: "QR Scanner is not supported on this device.")
            }
        }

        searchBarView.onSearchTapped = { [weak self] text in
            guard let self else { return }
            print("Search initiated for text: \(text)")
            self.addSearchToRecent(text)
            self.fetchTrackingInfo(trackingCode: text)
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
    
    private func addSearchToRecent(_ search: String) {
        if !recentSearches.contains(search) {
            if recentSearches.count == 5 {
                recentSearches.removeLast()
            }
            recentSearches.insert(search, at: 0)
            saveRecentSearches()
        }
    }

    private func saveRecentSearches() {
        UserDefaults.standard.set(recentSearches, forKey: recentSearchesKey)
    }

    private func loadRecentSearches() {
        if let savedSearches = UserDefaults.standard.array(forKey: recentSearchesKey) as? [String] {
            recentSearches = savedSearches
        }
    }
    
    private func deleteSearch(at index: Int) {
        recentSearches.remove(at: index)
        saveRecentSearches()
    }

    private func navigateToDetailViewController(with tracking: Tracking) {
        let detailVC = TrackingDetailViewController(tracking: tracking)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchCell.identifier, for: indexPath) as? RecentSearchCell else {
            return UITableViewCell()
        }
        cell.configure(with: recentSearches[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSearch = recentSearches[indexPath.row]
        print("Selected recent search: \(selectedSearch)")
        fetchTrackingInfo(trackingCode: selectedSearch)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self else { return }
            self.deleteSearch(at: indexPath.row)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
