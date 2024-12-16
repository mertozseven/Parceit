//
//  ScannerViewController.swift
//  Parceit
//
//  Created by Mert Ozseven on 15.12.2024.
//

import UIKit
import VisionKit
import SnapKit

final class ScannerViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel = ScannerViewModel()
    private var dataScannerViewController: DataScannerViewController?
    private var scannerAvailable: Bool {
        DataScannerViewController.isSupported && DataScannerViewController.isAvailable
    }
    
    private lazy var scannerOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Align the QR code within the frame to scan"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupScanner()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createScannerOverlay()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(scannerOverlay)
        view.addSubview(closeButton)
        view.addSubview(instructionLabel)
        
        scannerOverlay.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalTo(view.layoutMarginsGuide)
            $0.width.height.equalTo(44)
        }
        
        instructionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.snp.centerY).offset(-150)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    
    }
    
    private func setupScanner() {
        guard scannerAvailable else {
            print("Scanner not available")
            return
        }
        
        let dataScanner = DataScannerViewController(
            recognizedDataTypes: [.barcode()],
            qualityLevel: .balanced,
            recognizesMultipleItems: false,
            isHighFrameRateTrackingEnabled: true,
            isHighlightingEnabled: true
        )
        
        dataScanner.delegate = self
        
        let windowSize: CGFloat = 250
        let screenSize = UIScreen.main.bounds
        let roi = CGRect(
            x: (screenSize.width - windowSize) / 2,
            y: (screenSize.height - windowSize) / 2,
            width: windowSize,
            height: windowSize
        )
        dataScanner.regionOfInterest = roi
        
        addChild(dataScanner)
        view.insertSubview(dataScanner.view, at: 0)
        dataScanner.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        dataScanner.didMove(toParent: self)
        
        try? dataScanner.startScanning()
        
        self.dataScannerViewController = dataScanner
    }
    
    private func createScannerOverlay() {
        let windowSize: CGFloat = 250
        let windowRect = CGRect(
            x: (view.bounds.width - windowSize) / 2,
            y: (view.bounds.height - windowSize) / 2,
            width: windowSize,
            height: windowSize
        )
        
        let path = UIBezierPath(rect: view.bounds)
        let scannerWindow = UIBezierPath(rect: windowRect)
        path.append(scannerWindow.reversing())
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        scannerOverlay.layer.mask = maskLayer
        
        let cornerLength: CGFloat = 30
        let cornerColor = UIColor.systemGreen
        
        addCornerLine(at: windowRect.origin, width: cornerLength, height: 2, color: cornerColor)
        addCornerLine(at: windowRect.origin, width: 2, height: cornerLength, color: cornerColor)
        
        let topRight = CGPoint(x: windowRect.maxX - cornerLength, y: windowRect.minY)
        addCornerLine(at: topRight, width: cornerLength, height: 2, color: cornerColor)
        addCornerLine(at: CGPoint(x: windowRect.maxX - 2, y: windowRect.minY), width: 2, height: cornerLength, color: cornerColor)
        
        let bottomLeft = CGPoint(x: windowRect.minX, y: windowRect.maxY - 2)
        addCornerLine(at: bottomLeft, width: cornerLength, height: 2, color: cornerColor)
        addCornerLine(at: CGPoint(x: windowRect.minX, y: windowRect.maxY - cornerLength), width: 2, height: cornerLength, color: cornerColor)
        
        let bottomRight = CGPoint(x: windowRect.maxX - cornerLength, y: windowRect.maxY - 2)
        addCornerLine(at: bottomRight, width: cornerLength, height: 2, color: cornerColor)
        addCornerLine(at: CGPoint(x: windowRect.maxX - 2, y: windowRect.maxY - cornerLength), width: 2, height: cornerLength, color: cornerColor)
    }
    
    private func addCornerLine(at point: CGPoint, width: CGFloat, height: CGFloat, color: UIColor) {
        let line = UIView(frame: CGRect(x: point.x, y: point.y, width: width, height: height))
        line.backgroundColor = color
        view.addSubview(line)
    }
    
    // MARK: - Objective Methods
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}

// MARK: - DataScannerViewControllerDelegate
extension ScannerViewController: DataScannerViewControllerDelegate {
    func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
        switch item {
        case .barcode(let barcode):
            if let stringValue = barcode.payloadStringValue {
                viewModel.didFindCode?(stringValue)
                dismiss(animated: true)
            }
        default:
            break
        }
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        guard let firstItem = addedItems.first else { return }
        
        switch firstItem {
        case .barcode(let barcode):
            if let stringValue = barcode.payloadStringValue {
                viewModel.didFindCode?(stringValue)
                dismiss(animated: true)
            }
        default:
            break
        }
    }
}
