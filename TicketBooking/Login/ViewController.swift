//
//  ViewController.swift
//  TicketBooking
//
//  Created by Milan Pal on 25/07/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var vWUsrnam: UIView!
    @IBOutlet weak var vWButton: UIView!
    
    private let fullText = "Welcome to SwiftTickets"
    private var currentIndex = 0
    private var typingTimer: Timer?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loginViewModel = LoginViewModel()
        
        
        let p = ""
    }
    
    var loginViewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        setUI()
        startTypewriterAnimation()
    }
    
    func setUI() {
        vWUsrnam.layer.cornerRadius = 10
        vWUsrnam.clipsToBounds = true
        vWUsrnam.layer.borderWidth = 1
        vWUsrnam.layer.borderColor = #colorLiteral(red: 0.1220000014, green: 0.2549999952, blue: 0.3249999881, alpha: 1)
        vWButton.layer.cornerRadius = 10
        lblHeading.text = ""
    }
    
    func startTypewriterAnimation() {
        typingTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(appendNextCharacter), userInfo: nil, repeats: true)
    }

    @objc func appendNextCharacter() {
        if currentIndex < fullText.count {
            let index = fullText.index(fullText.startIndex, offsetBy: currentIndex)
            lblHeading.text?.append(fullText[index])
            currentIndex += 1
        } else {
            typingTimer?.invalidate()
        }
    }

    @IBAction func btnLogin_Click(_ sender: Any) {
        loginViewModel.login(completion: {   data in
            if data != nil {
                debugPrint("access_token",data?.data?.access_token ?? "")
                debugPrint("refresh_token",data?.data?.refresh_token ?? "")
                UserDefaults.standard.set(data?.data?.access_token ?? "", forKey: "access_token")
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let NVC = storyBoard.instantiateViewController(withIdentifier: "BookingVc")as! BookingVc
                self.navigationController?.pushViewController(NVC, animated: true)
            }
        })
    }
    
}

