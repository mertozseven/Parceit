//
//  HomeViewController.swift
//  Parceit
//
//  Created by Mert Ozseven on 6.12.2024.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    private let searchBarView = SearchBarView()
    private let emptyView = EmptyView()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Private Methods
    private func configureUI() {
        view.backgroundColor = .dynamicColor(light: .secondarySystemBackground, dark: .systemBackground)
        addViews()
        configureLayout()
        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Private Methods
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

}

#Preview {
    UINavigationController(rootViewController: HomeViewController())
}
