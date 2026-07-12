//
//  LoginViewModel.swift
//  TicketBooking
//
//  Created by Milan Pal on 25/07/25.
//

import Foundation
import Alamofire

class LoginViewModel:NSObject{
    
    func login(completion: @escaping (LoginResponseModel?) -> Void) {
        
        let parameters: [String: Any] = [
            "username": "bbbbbbbbb"
            "pass": "aaa2"
        ]
        
        let headers: HTTPHeaders = [
            "x-api-key": "test",
            "Content-Type": "application/json",
            "X-CSRFTOKEN": "NIXpqB8KAKU2DM9H0IhYVBK4NLWx14fW3Mw2SJNsrXH0KGlQniILyEYAACXYGJsv"
        ]
        
        AlamoFireAPICall.postData(action: Api.loginUrl,parameters: parameters,headers: headers,completion: { response in
            guard let data = response as? Data else {
                completion(nil)
                return
            }
            do {
                let result = try JSONDecoder().decode(LoginResponseModel.self, from: data)
                debugPrint("Login success:", result)
                completion(result)
            } catch {
                debugPrint("Decoding error:", error)
                completion(nil)
            }
        },
                                  view: nil,
                                  showLoader: true,
                                  showLog: true
        )
    }
    
}
