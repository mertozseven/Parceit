//
//  ScannerViewModel.swift
//  Parceit
//
//  Created by Mert Ozseven on 15.12.2024.
//

import Foundation
import AVFoundation

final class ScannerViewModel {
    var didFindCode: ((String) -> Void)?
    var didEncounterError: ((Error) -> Void)?
    
    func toggleFlashlight() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        do {
            try device.lockForConfiguration()
            device.torchMode = device.torchMode == .on ? .off : .on
            device.unlockForConfiguration()
        } catch {
            didEncounterError?(error)
        }
    }
}
