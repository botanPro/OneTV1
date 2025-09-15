//
//  LoginVC.swift
//  OneTV
//
//  Created by Botan Amedi on 17/04/2025.
//

import UIKit
import DropDown
import AVFoundation
import AudioToolbox
import SwiftyJSON
import BSImagePicker
import Photos
import PhoneNumberKit
import MHLoadingButton
import RSLoadingView
import PSMeter
import EFInternetIndicator
import Drops
import Alamofire



class LoginVC: UIViewController , UITextFieldDelegate, UITextViewDelegate, InternetStatusIndicable{
    var internetConnectionIndicator: EFInternetIndicator.InternetViewIndicator?
    

    @IBOutlet weak var Code: UITextField!
    @IBOutlet weak var Phone: PhoneNumberTextField!
    
    
    func getActiveOption(completion :@escaping (_ status: Int)->()){
        let stringUrl = URL(string: "https://one-tv.net/api/active");
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(openCartApi.token)"
        ]

        
        AF.request(stringUrl!, method: .get, headers: headers).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                let data = jsonData.arrayValue
                for act in data{
                    print(act["is_active"].intValue)
                    completion(act["is_active"].intValue)
                }
                
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if XLanguage.get() == .English{
            self.Code.placeholder = "Password"
        } else if XLanguage.get() == .Arabic{
            self.Code.placeholder = "كلمة المرور"
        } else {
            self.Code.placeholder = "وشەی نهێنی"
        }
        
        self.getActiveOption { active in
            if active == 1{
                if XLanguage.get() == .English{
                    self.Code.placeholder = "Password"
                } else if XLanguage.get() == .Arabic{
                    self.Code.placeholder = "كلمة المرور"
                } else {
                    self.Code.placeholder = "وشەی نهێنی"
                }
            }else{
                if XLanguage.get() == .English{
                    self.Code.placeholder = "Activation Code"
                } else if XLanguage.get() == .Arabic{
                    self.Code.placeholder = "رمز التفعيل"
                } else {
                    self.Code.placeholder = "کۆدی چالاککردن"
                }
            }
        }
        
        self.Phone.placeHolderColor = .lightGray
        self.Phone.keyboardType = .asciiCapable
        self.Phone.withPrefix = true
        self.Phone.withFlag = true
        self.Phone.withExamplePlaceholder = false
        self.Phone.placeholder = "750 123 45 67"
        self.Phone.withDefaultPickerUI = true
         
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHiden), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        addDoneButtonOnKeyboard()

        Code.delegate = self
        Phone.delegate = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
      
    @IBOutlet weak var Stackbottom: NSLayoutConstraint!
    
    var count = 1
    @objc func keyboardWasShown(notification: NSNotification) {
        if count == 1{
           count += 1
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.Stackbottom.constant += keyboardFrame.height - 50
        }
    }
    
    @objc func keyboardWasHiden(notification: NSNotification) {
        count = 1
        self.Stackbottom.constant = 0
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func addDoneButtonOnKeyboard() {
        let toolbar: UIToolbar = UIToolbar()
        toolbar.sizeToFit()

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))

        toolbar.setItems([flexSpace, done], animated: false)
        toolbar.isUserInteractionEnabled = true

        Code.inputAccessoryView = toolbar
        Phone.inputAccessoryView = toolbar
    }
    
    
    
    func showDrop(title: String, message: String) {
        let drop = Drop(
            title: message,
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
    
    @objc func doneButtonAction() {
        Code.resignFirstResponder()
        Phone.resignFirstResponder()
    }
    
  
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    var phone = ""
    @IBAction func SignIn(_ sender: Any) {
        if CheckInternet.Connection() == true{
            if Phone.text?.trimmingCharacters(in: .whitespaces) != "" && Code.text?.trimmingCharacters(in: .whitespaces) != ""{
                LoadingView()
                self.Phone.resignFirstResponder()
                self.Code.resignFirstResponder()
                
                let str = self.Phone.text!
                if str.count > 0{
                    let index = str.index(str.startIndex, offsetBy: 0)
                    if str[index] == "0" && self.Phone.currentRegion == "IQ"{
                        self.phone = self.Phone.text!
                        self.phone.remove(at: index)
                    }else{
                        self.phone = self.Phone.text!
                    }
                }

                self.phone = self.Phone.text!.convertedDigitsToLocale(Locale(identifier: "EN")).replace(string: " ", replacement: "");
                //get device id
                let deviceId = UIDevice.current.identifierForVendor?.uuidString
                LoginAPi.Login(mobile: self.phone, code: self.Code.text!, deviceId: deviceId ?? "") { status, user in
                    self.alert.dismiss(animated: true, completion: {
                        if status == "success"{
                            UserDefaults.standard.setValue("true", forKey: "login")
                            UserDefaults.standard.setValue(self.Phone.text!, forKey: "phone")
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! TabbarView
                            vc.modalPresentationStyle = .fullScreen
                            vc.modalTransitionStyle = .crossDissolve
                            
                            self.present(vc, animated: true)
                        }
                    })
                }
            }else{
                if self.Phone.text! == ""{
                    if XLanguage.get() == .English{
                        self.showDrop(title: "", message: "Please enter your phone number")
                    }else if XLanguage.get() == .Arabic{
                        self.showDrop(title: "", message: "الرجاء إدخال رقم هاتفك")
                    }else{
                        self.showDrop(title: "", message: "تکایە ژمارەی موبایلەکە دابنێ")
                    }
                   
                    return
                }
                
                
                if self.Code.text! == ""{
                    if XLanguage.get() == .English{
                        self.showDrop(title: "", message: "Please enter your activation code")
                    }else if XLanguage.get() == .Arabic{
                        self.showDrop(title: "", message: "الرجاء إدخال رمز التفعيل الخاص بك")
                    }else{
                        self.showDrop(title: "", message: "تکایە کۆدی چالاککردنەکەت دابنێ")
                    }
                    
                    return
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
    
    
    @IBAction func ForgetPass(_ sender: Any) {
        
    }
    
    
    
    @IBOutlet weak var HidePass: UIButton!
    var PassIsHide = true
    @IBAction func HidePass(_ sender: Any) {
        if self.PassIsHide == true{
            PassIsHide = false
            self.HidePass.setImage(UIImage(named: "eye"), for: .normal)
            self.Code.isSecureTextEntry = false
        }else{
            PassIsHide = true
            self.HidePass.setImage(UIImage(named: "eye-slash"), for: .normal)
            self.Code.isSecureTextEntry = true
        }
    }
    
}



class MyGBTextField: PhoneNumberTextField {
    override var defaultRegion: String {
        get {
            return "UA"
        }
        set {}
    }
}

