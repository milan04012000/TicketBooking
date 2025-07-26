//
//  Api.swift
//  TicketBooking
//
//  Created by Milan Pal on 25/07/25.
//

import Foundation

struct Api {
    static let baseUrl = "https://pre-prod-ondc-buyer-api.delhitransport.in/"
    static let loginUrl = "user/login/"
    static let estimateUrl = "api/v1/ondc/delhi/bus/estimate"
    static let bookingUrl = "api/v1/tickets/initiate/"
}
