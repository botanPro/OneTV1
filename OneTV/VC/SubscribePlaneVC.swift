//
//  SubscribePlaneVC.swift
//  OneTV
//
//  Created by Botan Amedi on 19/04/2025.
//

import UIKit

class SubscribePlaneVC: UIViewController {

    @IBOutlet weak var PremiumPrice: UILabel!
    @IBOutlet weak var PemiumDays: UILabel!
    @IBOutlet weak var StandardPrice: UILabel!
    @IBOutlet weak var StandardDays: UILabel!
    
    
    
    
    @IBAction func WhatsApp(_ sender: Any) {
        var phoneNumber = self.phone
         
         // Add +964 if missing
         if !phoneNumber.hasPrefix("+964") {
             // Remove any leading zeros or other prefixes first
             phoneNumber = phoneNumber.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
             phoneNumber = "+964" + phoneNumber
         }
        let urlString = "https://wa.me/\(phoneNumber)"
        
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // WhatsApp not installed, open in browser
                let webURL = URL(string: "https://web.whatsapp.com/send?phone=\(phoneNumber)")!
                UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    
    
    
    @IBAction func Viber(_ sender: Any) {
        var phoneNumber = self.phone
         
         // Add +964 if missing
         if !phoneNumber.hasPrefix("+964") {
             // Remove any leading zeros or other prefixes first
             phoneNumber = phoneNumber.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
             phoneNumber = "+964" + phoneNumber
         }
        let urlString = "viber://add?number=\(phoneNumber)"
        
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Viber not installed, open in App Store
                let appStoreURL = URL(string: "https://apps.apple.com/app/viber-messenger-chats-calls/id382617920")!
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    
    @IBAction func Telegram(_ sender: Any) {
        var phoneNumber = self.phone
         
         // Add +964 if missing
         if !phoneNumber.hasPrefix("+964") {
             // Remove any leading zeros or other prefixes first
             phoneNumber = phoneNumber.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
             phoneNumber = "+964" + phoneNumber
         }
        let urlString = "tg://resolve?phone=\(phoneNumber)"
        
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Telegram not installed, open in App Store
                let appStoreURL = URL(string: "https://apps.apple.com/app/telegram-messenger/id686449807")!
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    @IBOutlet weak var ActiveAccount: UIView!
    var s_id = 0
    var p_id = 0
    var phone = ""
    var s_price = ""
    var p_price = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.ActiveAccount.layer.cornerRadius = 21.5
        self.ActiveAccount.backgroundColor = .clear
        self.ActiveAccount.layer.borderColor = UIColor.white.cgColor
        self.ActiveAccount.layer.borderWidth = 1
        
        
        
        DispatchQueue.main.async {
             let loadingIndicator = UIActivityIndicatorView(style: .large)
             loadingIndicator.center = self.view.center
             loadingIndicator.startAnimating()
             loadingIndicator.tag = 999 // For easy reference
             self.view.addSubview(loadingIndicator)
         }
        
        PlansAPi.getPlans { plans in
            DispatchQueue.main.async {
                if let loadingIndicator = self.view.viewWithTag(999) as? UIActivityIndicatorView {
                    loadingIndicator.removeFromSuperview()
                }
            }
            for (i, plan) in plans.enumerated() {
                if i == 0 {
                    DispatchQueue.main.async {
                        self.StandardPrice.text = plan.pricing.currencyFormatting()
                        self.StandardDays.text = plan.name
                        self.s_id = plan.id
                        self.phone = plan.phone
                        self.s_price = plan.pricing
                    }
                }else if i == 1 {
                    DispatchQueue.main.async {
                        self.PremiumPrice.text = plan.pricing.currencyFormatting()
                        self.PemiumDays.text = plan.name
                        self.p_id = plan.id
                        self.phone = plan.phone
                        self.p_price = plan.pricing
                    }
                }
            }
        }
        
    }

    @IBAction func ActiveAccount(_ sender: Any) {
        
    }
    
    
    @IBAction func Standard(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "PaymentMethod") as! PaymentMethod
//        vc.planid = s_id
//        vc.number = self.phone
//        vc.price = self.s_price
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func Premium(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "PaymentMethod") as! PaymentMethod
//        vc.planid = p_id
//        vc.number = self.phone
//        vc.price = self.p_price
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
