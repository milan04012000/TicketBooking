//
//  ApiCall.swift
//  TicketBooking
//
//  Created by Milan Pal on 25/07/25.
//

import Foundation
import NVActivityIndicatorView
import Alamofire

class AlamoFireAPICall: NSObject {
    
    static func postData(action: String,parameters: [String: Any],headers: HTTPHeaders,completion: ((Any) -> ())?,view: UIView?,showLoader: Bool = true,showLog: Bool = true) {
        
        let activityData = ActivityData(size: CGSize(width: 42, height: 42),
                                        message: "Please_wait",
                                        type: .lineSpinFadeLoader,
                                        color: #colorLiteral(red: 0.175999999, green: 0.3729999959, blue: 0.474999994, alpha: 1),
                                        padding: 2)
        
        if showLoader {
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        }
        
        let url = "\(Api.baseUrl)\(action)"
        
        debugPrint("URL: \(url)")
        debugPrint("PARAMETER: \(parameters)")
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .responseData { response in
            if showLoader {
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            }
            switch response.result {
            case .success(let data):
                completion?(data)
            case .failure(let error):
                debugPrint("Request failed:", error)
                if let statusCode = response.response?.statusCode {
                    debugPrint("Status code:", statusCode)
                }
            }
        }
    }
    
}
