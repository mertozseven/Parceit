//
//  HomeViewController.swift
//  Parceit
//
//  Created by Mert Ozseven on 6.12.2024.
//

import UIKit
import SnapKit

final class SearchViewController: UIViewController {
    
    // MARK: - Properties
    private let searchBarView = SearchBarView()
    private let emptyView = EmptyView()
    
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
        title = "Search"
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
            let scannerVC = ScannerViewController()
            scannerVC.modalPresentationStyle = .fullScreen
            scannerVC.viewModel.didFindCode = { [weak self] code in
                self?.searchBarView.configure(with: code)
                print("Scanned code: \(code)")
            }
            self?.present(scannerVC, animated: true)
        }
    }
}
