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
    private let topDateView = TopDateView()
    
    private let containerView = ContainerView(
        backgroundColor: .dynamicColor(light: .systemBackground, dark: .secondarySystemBackground),
        cornerRadius: 10
    )
    private let topTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Track your parcel"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        
        return label
    }()
    
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
    }
    
    // MARK: - Private Methods
    private func addViews() {
        view.addSubview(topDateView)
        view.addSubview(containerView)
        view.addSubview(topTitleLabel)
    }
    
    private func configureLayout() {
        topDateView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(16)
            $0.height.equalTo(80)
        }
        containerView.snp.makeConstraints {
            $0.top.equalTo(topDateView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(topDateView)
            $0.bottom.equalTo(topTitleLabel.snp.bottom).offset(16)
        }
        topTitleLabel.snp.makeConstraints {
            $0.top.equalTo(containerView).offset(16)
            $0.trailing.leading.equalTo(containerView).offset(16)
            $0.height.equalTo(24)
        }
    }

}

#Preview {
    HomeViewController()
}
