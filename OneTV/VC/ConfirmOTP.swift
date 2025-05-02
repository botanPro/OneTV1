//
//  SendOTP.swift
//  OneTV
//
//  Created by Botan Amedi on 28/04/2025.
//

import UIKit
import Alamofire
import SwiftyJSON
import MHLoadingButton
import PhoneNumberKit
import RSLoadingView
import EFInternetIndicator
import Drops
class SendOTP: UIViewController , UITextFieldDelegate , InternetStatusIndicable{
    
    
    var internetConnectionIndicator:InternetViewIndicator?

    @IBAction func Dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    var ResetPassURL : URL!
    var is_from_forgetpass = false
    private var lastTapTime: TimeInterval = 0
    @IBAction func ResendCode(_ sender: Any) {
        let currentTime = Date().timeIntervalSince1970
           guard currentTime - lastTapTime > 30 else { return } // 30s delay
           lastTapTime = currentTime
        self.view.endEditing(true)
        self.LoadingView()
        if is_from_forgetpass == true{
            ResetPassURL = URL(string: "https://iq-flowers.com/api/send_otp_pass_reset");
        }else{
            ResetPassURL = URL(string: "https://iq-flowers.com/api/send_otp");
        }
        
        let param: [String: Any] = [
            "phone":self.phone
        ]
        
       print(self.phone)
        
        AF.request(ResetPassURL!, method: .post, parameters: param).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                self.alert.dismiss(animated: true, completion: {
                    self.showDrop(title: "", message: jsonData["message"].stringValue)
                })
            case .failure(let error):
                self.alert.dismiss(animated: true, completion: nil)
                print(error);
            }
        }
    }
    
    
    let loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
    @IBOutlet weak var OTPView: UIView!
    @IBOutlet weak var OTPCode: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Style(vieww: OTPView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHiden), name: UIResponder.keyboardWillHideNotification, object: nil)
        addDoneButtonOnKeyboard()
        
        OTPCode.delegate = self
    }
    
    func addDoneButtonOnKeyboard() {
            let toolbar: UIToolbar = UIToolbar()
            toolbar.sizeToFit()

            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))

            toolbar.setItems([flexSpace, done], animated: false)
            toolbar.isUserInteractionEnabled = true

        OTPCode.inputAccessoryView = toolbar
        }

        @objc func doneButtonAction() {
            OTPCode.resignFirstResponder()
        }
     
     deinit {
         NotificationCenter.default.removeObserver(self)
     }
     
     
     
    @IBOutlet weak var StackBottom: NSLayoutConstraint!
    var count = 1
     @objc func keyboardWasShown(notification: NSNotification) {
         if count == 1{
            count += 1
         let info = notification.userInfo!
         let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
         self.StackBottom.constant += keyboardFrame.height - 50
         }
     }
     
     @objc func keyboardWasHiden(notification: NSNotification) {
         count = 1
         self.StackBottom.constant = 0
     }

     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         return true
     }
     
     
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.OTPCode.becomeFirstResponder()
     }

    
    func Style(vieww : UIView){
        vieww.layer.borderWidth = 0.5
        vieww.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        vieww.layer.cornerRadius = 27
    }
    
    
    func showDrop(title: String, message: String) {
        let drop = Drop(
            title: title,
            subtitle: message,
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

    
    
    var alert = UIAlertController()
    var loadingLableMessage = "Please wait..."
    func LoadingView(){
        if XLanguage.get() == .English{
            loadingLableMessage = "Please wait..."
        }else if XLanguage.get() == .Arabic{
            loadingLableMessage = "جاري الإنتضار..."
        }else{
            loadingLableMessage = "تکایە چاوەروانبە..."
        }
        alert = UIAlertController(title: nil, message: self.loadingLableMessage, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    var IsFromSignUp = false
    var otp = ""
    var phone = ""
    var name = ""
    var password = ""
    var cityID = 0
    
    @IBAction func Confirm(_ sender: Any) {
        if CheckInternet.Connection(){
            print(IsFromSignUp)
            if self.OTPCode.text?.trimmingCharacters(in: .whitespaces) != ""{
                if self.IsFromSignUp == false{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordVC") as! ForgetPassword
                    vc.modalPresentationStyle = .fullScreen
                    vc.phone = self.phone
                    vc.otp = self.OTPCode.text!
                    self.present(vc, animated: true)
                }else{
                    print(self.phone)
                    LoginAPi.CreateAccount(name: self.name, password: self.password, phone: self.phone, otp: self.OTPCode.text!, city_id: "\(self.cityID)") { status in
                        if status == "success"{
                            UserDefaults.standard.setValue("true", forKey: "login")
                            UserDefaults.standard.setValue(self.phone, forKey: "phone")
                            UserDefaults.standard.set("false", forKey: "AddressAdded")
                           
                            LoginAPi.UpdateCity_ID(city_id: self.cityID) { status in
                                UserDefaults.standard.set(self.cityID, forKey: "CityId")
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! TabbarView
                                vc.modalPresentationStyle = .fullScreen
                                vc.modalTransitionStyle = .crossDissolve
                                
                                self.present(vc, animated: true)
                               
                            }
                            
                        }
                    }
                  }
                }else{
                    RSLoadingView.hide(from: self.view)
                    if self.OTPCode.text == ""{
                        if XLanguage.get() == .English{
                            self.showDrop(title: "", message: "Please enter OTP code.")
                        }else if XLanguage.get() == .Kurdish{
                            self.showDrop(title: "", message: "تکایە کۆدی OTP دابنێ.")
                        }else{
                            self.showDrop(title: "", message: "الرجاء إدخال رمز OTP.")
                        }
                        
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

    
    
    
    
    

