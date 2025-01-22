//
//  RecentSearchCell.swift
//  Parceit
//
//  Created by Mert Ozseven on 2.01.2025.
//

import UIKit
import SnapKit

class RecentSearchCell: UITableViewCell {

    // MARK: - Properties
    static let identifier = "RecentSearchCell"
    
    // MARK: - UI Elements
    private let magnifierIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .label
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    private let rightArrowIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrow.right")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        return imageView
    }()
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    public func configure(with title: String) {
        titleLabel.text = title
    }
    
    // MARK: - Private Methods
    private func configureView() {
        contentView.backgroundColor = .dynamicColor(light: .secondarySystemBackground, dark: .systemBackground)
        contentView.addSubview(magnifierIcon)
        contentView.addSubview(titleLabel)
        contentView.addSubview(rightArrowIcon)
        
        configureLayout()
    }
    
    private func configureLayout() {
        magnifierIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(magnifierIcon.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(rightArrowIcon.snp.leading).offset(-8)
        }
        
        rightArrowIcon.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
    }
}
