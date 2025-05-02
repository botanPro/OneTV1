//
//  Profile.swift
//  OneTV
//
//  Created by Botan Amedi on 08/03/2025.
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


class Profile: UIViewController , UITextFieldDelegate, UITextViewDelegate, InternetStatusIndicable, PasswordEstimator{
    var internetConnectionIndicator:InternetViewIndicator?
    @IBOutlet weak var NameWordView: UIView!
    @IBOutlet weak var SubscribeCodeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SubscribeCodeView.layer.cornerRadius = 21.5
        self.SubscribeCodeView.backgroundColor = .clear
        self.SubscribeCodeView.layer.borderColor = UIColor.white.cgColor
        self.SubscribeCodeView.layer.borderWidth = 1
        self.NameWordView.layer.cornerRadius = self.NameWordView.bounds.width / 2
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHiden), name: UIResponder.keyboardWillHideNotification, object: nil)
        addDoneButtonOnKeyboard()
        Email.configureEmailValidation()
        Email.delegate = self
        firstName.delegate = self
        secondName.delegate = self
        Password.delegate = self
        ConfPassword.delegate = self
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

        Email.inputAccessoryView = toolbar
        firstName.inputAccessoryView = toolbar
        secondName.inputAccessoryView = toolbar
        Password.inputAccessoryView = toolbar
        ConfPassword.inputAccessoryView = toolbar
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
        Email.resignFirstResponder()
        firstName.resignFirstResponder()
        secondName.resignFirstResponder()
        Password.resignFirstResponder()
        ConfPassword.resignFirstResponder()
    }
    
    
    @IBOutlet weak var secondName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var ConfPassword: UITextField!
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }


    var IsPasswordStrong = false
    var IsConfPasswordStrong = false
    func estimatePassword(_ password: String) -> PasswordStrength {
            if password.count >= 8 {
                IsPasswordStrong = true
                IsConfPasswordStrong = true
                return .strong
            }else{
                IsPasswordStrong = false
                IsConfPasswordStrong = false
                return .weak
            }
        }
    
    @IBAction func CreateAccount(_ sender: Any) {
        if CheckInternet.Connection(){
            if self.firstName.text?.trimmingCharacters(in: .whitespaces) != "" && self.secondName.text?.trimmingCharacters(in: .whitespaces) != "" && self.Email.text?.trimmingCharacters(in: .whitespaces) != "" && self.Password.text?.trimmingCharacters(in: .whitespaces) != "" && self.ConfPassword.text?.trimmingCharacters(in: .whitespaces) != ""{
                guard let email = Email.text, isValidEmail(email) else {
                    if XLanguage.get() == .English{
                        self.showDrop(title: "", message: "Please enter a valid email address")
                    }else if XLanguage.get() == .Arabic{
                        self.showDrop(title: "", message: "يرجى إدخال عنوان بريد إلكتروني صالح")
                    }else{
                        self.showDrop(title: "", message: "تکایە ناونیشانی ئیمەیڵێکی دروست دابنێ")
                    }
                    return
                }
                
                
                if self.Password.text! != self.ConfPassword.text!{
                    if XLanguage.get() == .English{
                        self.showDrop(title: "", message: "The password must be more than 8 letters")
                    }else if XLanguage.get() == .Arabic{
                        self.showDrop(title: "", message: "كلمة المرور غير متطابقة")
                    }else{
                        self.showDrop(title: "", message: "وشەی نهێنی هاوتا نییە")
                    }
                    self.showDrop(title: "", message: "Password not match")
                    return
                }
                
                
                if self.IsPasswordStrong == false{
                    if XLanguage.get() == .English{
                        self.showDrop(title: "", message: "The password must be more than 8 letters")
                    }else if XLanguage.get() == .Arabic{
                        self.showDrop(title: "", message: "يجب أن تكون كلمة المرور أكثر من 8 أحرف")
                    }else{
                        self.showDrop(title: "", message: "وشەی نهێنی دەبێت لە ٨ پیت زیاتر بێت")
                    }
                    return
                }
                
                
                LoginAPi.Registration(email: self.Email.text!, Password: self.Password.text!, firstname: self.firstName.text!, lastname: self.secondName.text!, password_confirmation: self.ConfPassword.text!) { status in
                    UserDefaults.standard.setValue("true", forKey: "login")
                    UserDefaults.standard.setValue(self.Email.text!, forKey: "phone")
                   
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! TabbarView
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    
                    self.present(vc, animated: true)
                }
                
                
                
            }else{
                if self.firstName.text! == ""{
                    if XLanguage.get() == .English{
                        self.showDrop(title: "", message: "Please write your first name")
                    }else if XLanguage.get() == .Arabic{
                        self.showDrop(title: "", message: "الرجاء كتابة اسمك الاول")
                    }else{
                        self.showDrop(title: "", message: "تکایە ناوی یەکەمت بنووسە")
                    }
                    return
                }
                
                if self.Email.text! == ""{
                    if XLanguage.get() == .English{
                        self.showDrop(title: "", message: "Please enter your Email")
                    }else if XLanguage.get() == .Arabic{
                        self.showDrop(title: "", message: "الرجاء إدخال برید الکتروني")
                    }else{
                        self.showDrop(title: "", message: "تکایە ئیمەیلەکەت بنووسە")
                    }
                    return
                }
                
                
                if self.Password.text! == ""{
                    if XLanguage.get() == .English{
                        self.showDrop(title: "", message: "Please enter your password")
                    }else if XLanguage.get() == .Arabic{
                        self.showDrop(title: "", message: "الرجاء إدخال كلمة المرور الخاصة بك")
                    }else{
                        self.showDrop(title: "", message: "تکایە وشەی نهێنی بنوسە")
                    }
                    
                    return
                }
                
                if self.ConfPassword.text! == ""{
                    if XLanguage.get() == .English{
                        self.showDrop(title: "", message: "Please enter confirmed password")
                    }else if XLanguage.get() == .Arabic{
                        self.showDrop(title: "", message: "الرجاء إدخال كلمة المرور الخاصة بك")
                    }else{
                        self.showDrop(title: "", message: "تکایە وشەی نهێنی پشتڕاستکردنەوە دابنێ")
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
    
    
    
    var ConfPassIsHide = true
    @IBOutlet weak var HideConfPass: UIButton!
    @IBOutlet weak var HidePass: UIButton!
    var PassIsHide = true
    @IBAction func HidePass(_ sender: UIButton) {
        if sender.tag == 0{
            if self.PassIsHide == true{
                PassIsHide = false
                self.HidePass.setImage(UIImage(named: "eye"), for: .normal)
                self.Password.isSecureTextEntry = false
            }else{
                PassIsHide = true
                self.HidePass.setImage(UIImage(named: "eye-slash"), for: .normal)
                self.Password.isSecureTextEntry = true
            }
        }else{
            if self.ConfPassIsHide == true{
                ConfPassIsHide = false
                self.HideConfPass.setImage(UIImage(named: "eye"), for: .normal)
                self.ConfPassword.isSecureTextEntry = false
            }else{
                ConfPassIsHide = true
                self.HideConfPass.setImage(UIImage(named: "eye-slash"), for: .normal)
                self.ConfPassword.isSecureTextEntry = true
            }
        }
    }
    
}

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}


extension UITextField {
    func configureEmailValidation() {
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.keyboardType = .emailAddress
        self.addTarget(self, action: #selector(validateEmail), for: .editingChanged)
    }
    
    @objc private func validateEmail() {
        if let text = self.text, !text.isEmpty {
            if isValidEmail(text) {
                // Valid email - visual feedback
                self.layer.borderWidth = 1.0
                self.layer.borderColor = UIColor.systemGreen.cgColor
                self.layer.cornerRadius = 5.0
            } else {
                // Invalid email - visual feedback
                self.layer.borderWidth = 1.0
                self.layer.borderColor = UIColor.systemRed.cgColor
                self.layer.cornerRadius = 5.0
            }
        } else {
            // Empty field - reset appearance
            self.layer.borderWidth = 0.0
        }
    }
}
