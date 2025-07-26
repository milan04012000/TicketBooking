//
//  LoginResponseModel.swift
//  TicketBooking
//
//  Created by Milan Pal on 25/07/25.
//

import Foundation

struct LoginResponseModel: Codable {
    let message: String?
    let data: TokenData?
}

struct TokenData: Codable {
    let access_token: String?
    let refresh_token: String?
}
