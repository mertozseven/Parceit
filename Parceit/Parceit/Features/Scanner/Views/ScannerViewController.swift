//
//  ScannerViewController.swift
//  Parceit
//
//  Created by Mert Ozseven on 15.12.2024.
//

import UIKit
import AVFoundation
import VisionKit
import SnapKit

final class ScannerViewController: UIViewController {
    
    let viewModel = ScannerViewModel()
    private var captureSession: AVCaptureSession?
    private let previewLayer = AVCaptureVideoPreviewLayer()
    
    private lazy var scannerOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    private lazy var flashlightButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "flashlight.off.fill"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(flashlightTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkCameraPermission()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        createScannerOverlay()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
        view.addSubview(scannerOverlay)
        view.addSubview(flashlightButton)
        
        scannerOverlay.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        flashlightButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(32)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(44)
        }
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
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async {
                        self?.setupCamera()
                    }
                }
            }
        default:
            break
        }
    }
    
    private func setupCamera() {
        let session = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              session.canAddInput(videoInput) else {
            return
        }
        
        session.addInput(videoInput)
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr, .ean13, .ean8, .pdf417]
        } else {
            return
        }
        
        previewLayer.session = session
        previewLayer.videoGravity = .resizeAspectFill
        
        DispatchQueue.global(qos: .background).async {
            session.startRunning()
        }
        
        self.captureSession = session
    }
    
    @objc private func flashlightTapped() {
        viewModel.toggleFlashlight()
        let imageName = flashlightButton.currentImage == UIImage(systemName: "flashlight.off.fill")
            ? "flashlight.on.fill"
            : "flashlight.off.fill"
        flashlightButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first,
              let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
              let stringValue = readableObject.stringValue else {
            return
        }
        
        captureSession?.stopRunning()
        viewModel.didFindCode?(stringValue)
        dismiss(animated: true)
    }
}
