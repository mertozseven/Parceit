//
//  QRCodeCell.swift
//  Parceit
//
//  Created by Mert Ozseven on 15.12.2024.
//

import UIKit
import SnapKit

final class QRCodeCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "QRCodeCell"
    private var qrCodeString = ""
    
    private let containerView = ContainerView(backgroundColor: .dynamicColor(light: .systemBackground, dark: .secondarySystemBackground), cornerRadius: 10)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    private let qrCodeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let qrCodeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .headline)
        
        return label
    }()
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    public func configure(with title: String, qrCodeString: String) {
        print("Configuring cell with title: \(title), qrCode: \(qrCodeString)")
        self.titleLabel.text = title
        self.qrCodeString = qrCodeString
        self.qrCodeLabel.text = qrCodeString
        self.layoutIfNeeded()
        generateQRCodeImage()
    }
    
    // MARK: - Private Methods
    private func configureUI() {
        addViews()
        configureLayout()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        containerView.backgroundColor = .dynamicColor(light: .systemBackground, dark: .secondarySystemBackground)
    }
    
    private func addViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(qrCodeImage)
        containerView.addSubview(qrCodeLabel)
    }
    
    private func configureLayout() {
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.trailing.leading.equalToSuperview().inset(16)
        }
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(18)
        }
        qrCodeImage.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(160)
        }
        qrCodeLabel.snp.makeConstraints {
            $0.top.equalTo(qrCodeImage.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(18)
        }
        
    }
    
    private func generateQRCodeImage() {
        print("QR Code String: \(qrCodeString)")
        guard !qrCodeString.isEmpty else {
            print("QR Code String is empty.")
            return
        }
        guard let data = qrCodeString.data(using: String.Encoding.utf8) else {
            print("Failed to create data from qrCodeString.")
            return
        }
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else {
            print("Failed to create QR code filter.")
            return
        }
        qrFilter.setValue(data, forKey: "inputMessage")
        guard let qrImage = qrFilter.outputImage else {
            print("Failed to generate QR code image.")
            return
        }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else {
            print("Failed to create CGImage from scaled QR code image.")
            return
        }
        let processedImage = UIImage(cgImage: cgImage)
        qrCodeImage.image = processedImage
    }
    
}
