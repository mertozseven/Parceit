//
//  Tracking.swift
//  Parceit
//
//  Created by Mert Ozseven on 1.01.2025.
//

import Foundation

struct Tracking: Codable {
    let data: Ship24Data?
}

// MARK: - Ship24Data
struct Ship24Data: Codable {
    let trackings: [Ship24Tracking]?
}

// MARK: - Ship24Tracking
struct Ship24Tracking: Codable {
    let shipment: Shipment?
    let events: [Event]?
    let statistics: Statistics?
}

// MARK: - Shipment
struct Shipment: Codable {
    let shipmentId: String?
    let statusCode: String?
    let statusCategory: String?
    let statusMilestone: String?
    let originCountryCode: String?
    let destinationCountryCode: String?
    let delivery: Delivery?
    let trackingNumbers: [TrackingNumber]?
    let recipient: Recipient?

    enum CodingKeys: String, CodingKey {
        case shipmentId
        case statusCode
        case statusCategory
        case statusMilestone
        case originCountryCode
        case destinationCountryCode
        case delivery
        case trackingNumbers
        case recipient
    }
}

struct Delivery: Codable {
    let estimatedDeliveryDate: String?
    let service: String?
    let signedBy: String?
}

struct TrackingNumber: Codable {
    let tn: String?
}

struct Recipient: Codable {
    let name: String?
    let address: String?
    let postCode: String?
    let city: String?
    let subdivision: String?
}

struct Event: Codable {
    let eventId: String?
    let trackingNumber: String?
    let eventTrackingNumber: String?
    let status: String?
    let occurrenceDatetime: String?
    let order: String?
    let datetime: String?
    let hasNoTime: Bool?
    let utcOffset: String?
    let location: String?
    let sourceCode: String?
    let courierCode: String?
    let statusCode: String?
    let statusCategory: String?
    let statusMilestone: String?

    enum CodingKeys: String, CodingKey {
        case eventId
        case trackingNumber
        case eventTrackingNumber
        case status
        case occurrenceDatetime
        case order
        case datetime
        case hasNoTime
        case utcOffset
        case location
        case sourceCode
        case courierCode
        case statusCode
        case statusCategory
        case statusMilestone
    }
}

struct Statistics: Codable {
    let timestamps: Timestamps?
}

struct Timestamps: Codable {
    let infoReceivedDatetime: String?
    let inTransitDatetime: String?
    let outForDeliveryDatetime: String?
    let failedAttemptDatetime: String?
    let availableForPickupDatetime: String?
    let exceptionDatetime: String?
    let deliveredDatetime: String?
}
