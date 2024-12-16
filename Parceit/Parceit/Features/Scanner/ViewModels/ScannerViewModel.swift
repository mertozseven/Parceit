//
//  ScannerViewModel.swift
//  Parceit
//
//  Created by Mert Ozseven on 15.12.2024.
//

import Foundation
import AVFoundation

struct ScannerViewModel {
    var didFindCode: ((String) -> Void)?
    var didEncounterError: ((Error) -> Void)?
}
