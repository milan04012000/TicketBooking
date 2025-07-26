//
//  BookingResponseModel.swift
//  TicketBooking
//
//  Created by Milan Pal on 25/07/25.
//

import Foundation

// FareEstimateResponse

struct FareEstimateResponse: Decodable {
    let message: String?
    let data: FareData?
}

struct FareData: Decodable {
    let fare: FareDetails?
    let quantity: QuantityDetails?
}

struct FareDetails: Decodable {
    let transaction_id: String?
    let basic: String?
    let discount: String?
    let amount: String?
    let coupon: String?
}

struct QuantityDetails: Decodable {
    let minimum_ticket_count: Int?
    let maximum_ticket_count: Int?
}


// MARK: - Root Response
struct TicketBookingResponse: Codable {
    let message: String
    let description: String
    let data: TicketBookingData
}

// MARK: - Ticket Booking Data
struct TicketBookingData: Codable {
    let start_location_code: String
    let start_location_name: String
    let start_location_lat: String
    let end_location_code: String
    let end_location_name: String
    let end_location_lat: String
    let transit_option: TransitOption
    let created_for: CreatedFor
    let pnr: String
    let fare: Fare
    let created_at: String
    let updated_at: String
    let status: String
    let claim_status: Int
    let payment_status: String
    let transit_pnr: String?
    let ticket_type: TicketType
    let transaction: [Transaction]
    let journey_leg_index: Int
    let passenger_count: Int
    let vehicle_number: String
    let seat_no: String?
    let valid_till: String?
    let amount: Double
    let poc_name: String?
    let poc_phone: String?
    let service_details: ServiceDetails
}

// MARK: - Transit Option
struct TransitOption: Codable {
    let transit_mode: String
    let provider: Provider
}

struct Provider: Codable {
    let name: String
}

// MARK: - Created For
struct CreatedFor: Codable {
    let id: String
    let email: String
    let username: String
    let first_name: String?
    let last_name: String?
    let phone: String?
    let pin: Int
}

// MARK: - Fare
struct Fare: Codable {
    let basic: Double
    let toll: Double
    let convenience_charge: Double
    let convenience_charge_tax: Double
    let discount: Double
    let add_on: Double
    let add_on_tax: Double
    let cancellation_chg: Double
    let franchisee_service_charge: Double
    let amount: Double
    let coupon_discount: Double
    let quantity: Int
    let coupon: String
}

// MARK: - Ticket Type
struct TicketType: Codable {
    let name: String
    let discount_percentage: Double
    let is_description_required: Bool
    let is_active: Bool
    let description: String?
}

// MARK: - Transaction (Empty array for now)
struct Transaction: Codable {}


// MARK: - Service Details
struct ServiceDetails: Codable {
    let ticket_qr: String
    let route: String
    let agency: String
    let variant: String
}
