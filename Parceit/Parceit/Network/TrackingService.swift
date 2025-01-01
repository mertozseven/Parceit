//
//  TrackingService.swift
//  Parceit
//
//  Created by Mert Ozseven on 1.01.2025.
//

import Foundation

// MARK: - Protocol
protocol TrackingServiceProtocol {
    func fetchTrackingInfo(
        trackingCode: String,
        completion: @escaping (Result<Tracking, NetworkError>) -> Void
    )
}

// MARK: - API Extension
extension API: TrackingServiceProtocol {
    func fetchTrackingInfo(
        trackingCode: String,
        completion: @escaping (Result<Tracking, NetworkError>) -> Void
    ) {
        let parameters: [String: Any] = ["trackingNumber": trackingCode]
        
        executeRequestFor(
            router: .trackingInfo,
            parameters: parameters,
            method: .post,
            completion: completion
        )
    }
}
