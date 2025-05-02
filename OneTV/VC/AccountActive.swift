//
//  AccountActive.swift
//  OneTV
//
//  Created by Botan Amedi on 20/04/2025.
//

import UIKit
import EFInternetIndicator
import Drops
import SwiftyJSON
class AccountActive: UIViewController , InternetStatusIndicable{
    var internetConnectionIndicator: EFInternetIndicator.InternetViewIndicator?

    @IBOutlet weak var Code: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func showDrop(title: String, message: String) {
        let drop = Drop(
            title: title,
            subtitle: "",
            icon: UIImage(named: "attention"),
            action: .init {
                print("Drop tapped")
                Drops.hideCurrent()
            },
            position: .top,
            duration: 3.0,
            accessibility: "Alert: Title, Subtitle"
        )
        Drops.show(drop)
    }
    
    private var lastTapTime: TimeInterval = 0
    @IBAction func Active(_ sender: Any) {
        let currentTime = Date().timeIntervalSince1970
        guard currentTime - lastTapTime > 1 else { return }
        lastTapTime = currentTime
        
        
        if CheckInternet.Connection() == true{
            if self.Code.text != ""{
                if UserDefaults.standard.string(forKey: "login") == "true"{
                    var request = URLRequest(url: URL(string: "https://one-tv.net/api/activate-account?code=\(self.Code.text!)")!,timeoutInterval: Double.infinity)
                    request.addValue("Bearer \(openCartApi.token)", forHTTPHeaderField: "Authorization")

                    request.httpMethod = "POST"

                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                      guard let data = data else {
                        print(String(describing: error))
                        return
                      }
                      print(String(data: data, encoding: .utf8)!)
                        let jsonData = JSON(data)
                        
                        
                        if let sms = jsonData["message"].string{
                            self.showDrop(title: sms, message: "")
                        }
                        
                        if XLanguage.get() == .English{
                            self.showDrop(title: "your account has been activated", message: "")
                        }else if XLanguage.get() == .Arabic{
                            self.showDrop(title: "تم تفعيل حسابك", message: "")
                        }else{
                            self.showDrop(title: "ئەکاونتەکەت چالاککرا", message: "")
                        }
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    }

                    task.resume()
                }else{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let myVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    myVC.modalPresentationStyle = .fullScreen
                    self.present(myVC, animated: true)
                }
            }else{
                if XLanguage.get() == .English{
                    self.showDrop(title: "Please enter the code", message: "")
                }else if XLanguage.get() == .Arabic{
                    self.showDrop(title: "يرجى إدخال الرمز", message: "")
                }else{
                    self.showDrop(title: "تکایە کودەکە بنووسە", message: "")
                }
            }
        }else{
            if XLanguage.get() == .English{
                self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"No internet connection.", remoteHostName: "magic.com")
                
            }else if XLanguage.get() == .Arabic{
                self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"لا يوجد اتصال بالإنترنت.", remoteHostName: "magic.com")
                
            }else{
                self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"هێلی ئینترنێت نیە", remoteHostName: "magic.com")
            }
        }
    
    }
}
