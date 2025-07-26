//
//  BookingVc.swift
//  TicketBooking
//
//  Created by Milan Pal on 25/07/25.
//

import UIKit

class BookingVc: UIViewController {
    
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var vWForm: UIView!
    @IBOutlet weak var vWTo: UIView!
    @IBOutlet weak var vWCheckButton: UIView!
    @IBOutlet weak var vWFaireDetails: UIView!
    @IBOutlet weak var vWBookNowButton: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.bookingViewModel = BookingViewModel()
        
    }
    
    var bookingViewModel = BookingViewModel()
    
    @IBOutlet weak var lblBasicfare: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblFinalamount: UILabel!
    @IBOutlet weak var lblCoupon: UILabel!
    @IBOutlet weak var lblMinMaxticket: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setUI()
    }
    
    func setUI() {
        vWForm.layer.cornerRadius = 10
        vWForm.clipsToBounds = true
        vWForm.layer.borderWidth = 1
        vWForm.layer.borderColor = #colorLiteral(red: 0.1220000014, green: 0.2549999952, blue: 0.3249999881, alpha: 1)
        vWTo.layer.cornerRadius = 10
        vWTo.clipsToBounds = true
        vWTo.layer.borderWidth = 1
        vWTo.layer.borderColor = #colorLiteral(red: 0.1220000014, green: 0.2549999952, blue: 0.3249999881, alpha: 1)
        vWCheckButton.layer.cornerRadius = 10
        vWBookNowButton.layer.cornerRadius = 10
        vWFaireDetails.isHidden = true
    }
    
    @IBAction func btnRefresh_Click(_ sender: Any) {
        vWFaireDetails.isHidden = true
    }
    
    @IBAction func btnBack_Click(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCheckFair_Click(_ sender: Any) {
        
        bookingViewModel.fetchFareEstimate { [self] response in
            debugPrint("here response",response ?? "")
            guard let fare = response?.data?.fare else {
                print("Fare data not found")
                return
            }
            vWFaireDetails.isHidden = false
            DispatchQueue.main.async {
                self.lblBasicfare.text = "Basic fare: ₹\(fare.basic ?? "0")"
                self.lblDiscount.text = "Discount: ₹\(fare.discount ?? "0")"
                self.lblFinalamount.text = "Final amount: ₹\(fare.amount ?? "0")"
                self.lblCoupon.text = "Coupon: \(fare.coupon ?? "-")"
                
                if let quantity = response?.data?.quantity {
                    self.lblMinMaxticket.text = "Min ticket count: \(quantity.minimum_ticket_count ?? 0), Max ticket count: \(quantity.maximum_ticket_count ?? 0)"
                }
            }
        }
        
    }
    
    @IBAction func btnBookNow_Click(_ sender: Any) {
        
        guard !bookingViewModel.transactionID.isEmpty else {
            print("Transaction ID missing. Call fare estimation first.")
            return
        }
        
        bookingViewModel.initiateTicketBooking(transactionID: bookingViewModel.transactionID) { response in
            debugPrint("here response",response ?? "")
            guard response != nil else {
                print("Ticket booking failed.")
                return
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let cameraAlertVc = storyboard.instantiateViewController(withIdentifier: "PopUpVc") as? PopUpVc {
                cameraAlertVc.modalPresentationStyle = .overFullScreen
                cameraAlertVc.modalTransitionStyle = .crossDissolve
                cameraAlertVc.ticketResponse = response
                cameraAlertVc.onDismiss = {
                        // ✅ Do this after popup is dismissed
                        self.vWFaireDetails.isHidden = true
                    }
                DispatchQueue.main.async {
                    self.present(cameraAlertVc, animated: false, completion: nil)
                }
            }
        }
        
    }
    
}
