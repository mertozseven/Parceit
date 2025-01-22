//
//  EventCell.swift
//  Parceit
//
//  Created by Mert Ozseven on 30.12.2024.
//

import UIKit

class EventCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "EventCell"
    
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .dynamicColor(light: .systemBackground, dark: .secondarySystemBackground)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 16,
            leading: 16,
            bottom: 16,
            trailing: 16
        )
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let courierTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.text = "Courier"
        label.textAlignment = .left
        return label
    }()
    
    private let courierLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.textAlignment = .left
        label.text = "UPS"
        return label
    }()
    
    private let statusTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.text = "Package Status"
        label.textAlignment = .left
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.text = "In Transit"
        label.textAlignment = .left
        return label
    }()
    
    private let datetimeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.text = "Occurrence Date"
        label.textAlignment = .left
        return label
    }()
    
    private let datetimeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.textAlignment = .left
        label.text = "2024-10-31T17:26:00"
        return label
    }()
    
    private let locationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.text = "Location"
        label.textAlignment = .left
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.textAlignment = .left
        label.text = "Istanbul, Turkey"
        return label
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
    public func configure(with event: Event) {
        statusLabel.text = event.status ?? "Unknown Status"
        datetimeLabel.text = event.occurrenceDatetime?.formattedDate() ?? "Unknown Date"
        locationLabel.text = event.location ?? "Unknown Location"
    }
    
    // MARK: - Private Methods
    private func configureView() {
        selectionStyle = .none
        contentView.backgroundColor = .dynamicColor(light: .secondarySystemBackground, dark: .systemBackground)
        addViews()
        configureLayout()
    }
    
    private func addViews() {
        contentView.addSubview(container)
        container.addSubview(stackView)
        stackView.addArrangedSubview(courierTitleLabel)
        stackView.addArrangedSubview(courierLabel)
        stackView.addArrangedSubview(statusTitleLabel)
        stackView.addArrangedSubview(statusLabel)
        stackView.addArrangedSubview(datetimeTitleLabel)
        stackView.addArrangedSubview(datetimeLabel)
        stackView.addArrangedSubview(locationTitleLabel)
        stackView.addArrangedSubview(locationLabel)
    }
    
    private func configureLayout() {
        container.snp.makeConstraints {
            $0.bottom.top.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.edges.equalTo(container.layoutMarginsGuide)
        }
    }
}
