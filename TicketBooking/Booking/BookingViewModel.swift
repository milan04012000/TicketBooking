//
//  BookingViewModel.swift
//  TicketBooking
//
//  Created by Milan Pal on 25/07/25.
//

import Foundation
import Alamofire
import NVActivityIndicatorView

class BookingViewModel: NSObject {
    
    var transactionID: String = ""
    
    func fetchFareEstimate(completion: @escaping (FareEstimateResponse?) -> Void) {
        // Step 1: get transaction_id
        
        DispatchQueue.main.async {
            let activityData = ActivityData(size: CGSize(width: 42, height: 42),
                                            message: "Please_wait",
                                            type: .lineSpinFadeLoader,
                                            color: #colorLiteral(red: 0.175999999, green: 0.3729999959, blue: 0.474999994, alpha: 1),
                                            padding: 2)
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        }
        
        sendFareRequest(transactionID: nil) { step1Response in
            guard let txnID = step1Response?.data?.fare?.transaction_id else {
                debugPrint("Transaction ID not found in Step 1")
                DispatchQueue.main.async {
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                }
                completion(nil)
                return
            }
            
            self.transactionID = txnID
            debugPrint("Step 1 Success – Transaction ID: \(txnID)")
            
            // Step 2: Poll until amount is non-nil
            self.pollForFareAmount(transactionID: txnID) { result in
                DispatchQueue.main.async {
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                }
                completion(result)
            }
        }
    }
    
    private func pollForFareAmount(transactionID: String, attempt: Int = 0, completion: @escaping (FareEstimateResponse?) -> Void) {
        guard attempt < 5 else {
            debugPrint("Polling stopped after 5 attempts")
            completion(nil)
            return
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            self.sendFareRequest(transactionID: transactionID) { response in
                if let amount = response?.data?.fare?.amount, !amount.isEmpty {
                    debugPrint("Fare found: ₹\(amount)")
                    completion(response)
                } else {
                    debugPrint("Amount still null, polling again...")
                    self.pollForFareAmount(transactionID: transactionID, attempt: attempt + 1, completion: completion)
                }
            }
        }
    }
    
    private func sendFareRequest(transactionID: String?, completion: @escaping (FareEstimateResponse?) -> Void) {
        let parameters: [String: Any] = [
            "transaction_id": transactionID ?? NSNull(),
            "start_stop_code": "ZAKHIRA_FLYOVER",
            "end_stop_code": "DB_GUPTA_MARKET",
            "route_id": "993DOWN",
            "variant": "ac",
            "bus_reg_num": "DL1PD5604",
            "category": "G"
        ]
        
        let accessToken = UserDefaults.standard.string(forKey: "access_token") ?? ""
        let headers: HTTPHeaders = [
            "x-api-key": "test",
            "Content-Type": "application/json",
            "X-CSRFTOKEN": "NIXpqB8KAKU2DM9H0IhYVBK4NLWx14fW3Mw2SJNsrXH0KGlQniILyEYAACXYGJsv",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AlamoFireAPICall.postData(action: Api.estimateUrl,parameters: parameters,headers: headers,completion: { response in
            guard let data = response as? Data else {
                debugPrint("Invalid response")
                completion(nil)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(FareEstimateResponse.self, from: data)
                completion(result)
            } catch {
                debugPrint("Decoding failed: \(error)")
                completion(nil)
            }
        },
                                  view: nil,
                                  showLoader: false,
                                  showLog: true
        )
    }
    
    // For ticket booking
    
    func initiateTicketBooking(transactionID: String, ticketCount: Int = 1, completion: @escaping (TicketBookingResponse?) -> Void) {
        
        let parameters: [String: Any] = [
            "transaction_id": transactionID,
            "pnr": NSNull(),
            "ticket_count": ticketCount,
            "transit_option": [
                "transit_mode": "BUS",
                "provider": [
                    "name": "ONDC"
                ]
            ],
            "meta": [
                "route_id": "993DOWN",
                "variant": "ac",
                "bus_reg_num": "DL1PD5604"
            ]
        ]
        
        let accessToken = UserDefaults.standard.string(forKey: "access_token") ?? ""
        debugPrint("Accesstoken",accessToken)
        let headers: HTTPHeaders = [
            "x-api-key": "test",
            "Content-Type": "application/json",
            "X-CSRFTOKEN": "NIXpqB8KAKU2DM9H0IhYVBK4NLWx14fW3Mw2SJNsrXH0KGlQniILyEYAACXYGJsv",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AlamoFireAPICall.postData(action: Api.bookingUrl,parameters: parameters,headers: headers,completion: { response in
            guard let data = response as? Data else {
                debugPrint("Invalid response")
                completion(nil)
                return
            }
            
            do {
                let ticket = try JSONDecoder().decode(TicketBookingResponse.self, from: data)
                debugPrint("SUCCESSFULLDONE",ticket)
                debugPrint("Booking success: \(ticket.data.pnr)")
                completion(ticket)
            } catch {
                debugPrint("Booking decode error: \(error)")
                completion(nil)
            }
        },
                                  view: nil,
                                  showLoader: true,
                                  showLog: true
        )
    }
    
}
