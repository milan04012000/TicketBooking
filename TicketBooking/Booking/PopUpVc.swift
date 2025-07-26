//
//  PopUpVc.swift
//  TicketBooking
//
//  Created by Milan Pal on 26/07/25.
//

import UIKit

class PopUpVc: UIViewController {
    
    @IBOutlet weak var vWBg: UIView!
    @IBOutlet weak var vWCorner: UIView!
    @IBOutlet weak var vWbutton: UIView!
    
    @IBOutlet weak var lblPnr: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblFare: UILabel!
    @IBOutlet weak var lblCoupon: UILabel!
    @IBOutlet weak var lblCreated: UILabel!
    @IBOutlet weak var lblPassenger: UILabel!
    @IBOutlet weak var lblVehicle: UILabel!
    @IBOutlet weak var lblRoute: UILabel!
    
    var onDismiss: (() -> Void)?
    var ticketResponse: TicketBookingResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.vWBg.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        vWCorner.layer.cornerRadius = 15
        vWbutton.layer.cornerRadius = 5.0
        
        populateData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissOnOutsideTap(_:)))
               tapGesture.cancelsTouchesInView = false
               self.view.addGestureRecognizer(tapGesture)

    }
    
    func populateData() {
        guard let ticket = ticketResponse else { return }

        lblPnr.text = "PNR: \(ticket.data.pnr)"
        lblStatus.text = "Status: \(ticket.data.status)"
        lblFare.text = "Fare: ₹\(ticket.data.fare.amount)"
        lblCoupon.text = "Coupon: \(ticket.data.fare.coupon)"
        lblCreated.text = "Created: \(ticket.data.created_at.prefix(10))" // yyyy-MM-dd
        lblPassenger.text = "Passenger(s): \(ticket.data.passenger_count)"
        lblVehicle.text = "Vehicle No: \(ticket.data.vehicle_number)"
        lblRoute.text = "Route: \(ticket.data.service_details.route)"
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.vWCorner.transform = .identity
        })
    }
    
    private func dismissAlertWithAnimation(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.vWCorner.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        }, completion: { _ in
            self.dismiss(animated: false) {
                self.onDismiss?()
                completion()
            }
        })
    }
    
    @objc func dismissOnOutsideTap(_ sender: UITapGestureRecognizer) {
            let location = sender.location(in: self.view)
            if !vWCorner.frame.contains(location) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    
    @IBAction func btnDismiss(_ sender: Any) {
        dismissAlertWithAnimation(completion: {
            
        })
    }
    
    
    @IBAction func btnCross_Click(_ sender: Any) {
        dismissAlertWithAnimation(completion: {
            
        })
    }
    
    @IBAction func btnGotIt_Click(_ sender: Any) {
        dismissAlertWithAnimation(completion: {
            
        })
    }


}
