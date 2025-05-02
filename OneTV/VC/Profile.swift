//
//  Profile.swift
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


class Profile: UIViewController , UITextFieldDelegate, UITextViewDelegate, InternetStatusIndicable{

    
    var internetConnectionIndicator:InternetViewIndicator?
    @IBOutlet weak var NameWordView: UIView!
    @IBOutlet weak var SubscribeCodeView: UIView!
    
    @IBOutlet weak var InfoStack: UIStackView!
    
    
    @IBOutlet weak var DeleteAccountStack: UIStackView!
    @IBOutlet weak var SubscriptionStack: UIView!
    
    @IBOutlet weak var logOutStack: UIStackView!
    
    @IBOutlet weak var LoginView: UIView!
    @IBOutlet var LoginTopAction: UITapGestureRecognizer!
    
    
    @IBAction func LoginTopAction(_ sender: Any) {
        
    }
    
    
    
    
    
    
    @IBOutlet weak var EXPView: UIView!
    
    
    
    
    @IBOutlet weak var LastStack: UIView!
    
    
    @IBOutlet weak var Email: UILabel!
    @IBOutlet weak var Name: UILabel!
    
    @IBOutlet weak var SelectedLangs: LanguageLable!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if XLanguage.get() == .English{
            self.SelectedLangs.text = "English"
        }else if XLanguage.get() == .Arabic{
            self.SelectedLangs.text = "العربية"
        }else{
            self.SelectedLangs.text = "کوردی"
        }
        
            if UserDefaults.standard.string(forKey: "login") == "true"{
                DispatchQueue.main.async {
                LoginAPi.getUserInfo { [weak self] info in
                    guard let self = self else { return }
                    self.Name.text = info.username
                    self.Email.text = info.mobile
                   
                    if info.planId == 0{
                        self.RemainingLable.isHidden = true
                        self.EXPView.isHidden = true
                    }else{
                        self.RemainingLable.isHidden = false
                        self.RemainingLable.text = info.exp
                        self.EXPView.isHidden = false
                    }
                }
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SubscribeCodeView.layer.cornerRadius = 21.5
        self.SubscribeCodeView.backgroundColor = .clear
        self.SubscribeCodeView.layer.borderColor = UIColor.white.cgColor
        self.SubscribeCodeView.layer.borderWidth = 1
        self.NameWordView.layer.cornerRadius = self.NameWordView.bounds.width / 2
       
  
        self.EXPView.isHidden = true
        self.RemainingLable.isHidden = true
        self.DeleteAccountStack.isHidden = true
        self.SubscriptionStack.isHidden = true
        self.SubscribeCodeView.isHidden = true
        self.logOutStack.isHidden = true
        self.InfoStack.isHidden = true
        self.LoginView.isHidden = true
        self.LastStack.isHidden = true
        
        if UserDefaults.standard.string(forKey: "login") == "true"{
            self.DeleteAccountStack.isHidden = false
            self.logOutStack.isHidden = false
            self.InfoStack.isHidden = false
            //self.TopImageView.constant = 312
            self.LastStack.isHidden = false
            
        }else{
            self.LoginView.isHidden = false
           // self.TopImageView.constant = 210
        }
    }
    @IBOutlet weak var RemainingLable: UILabel!
    
    @IBAction func GoToAboutUs(_ sender: Any) {
        LoginAPi.GetAboutPage { result in
            DispatchQueue.main.async {
                if result.isEmpty {
                    // Show error message if no data
                    let alert = UIAlertController(
                        title: "Error",
                        message: "Could not load about pages",
                        preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                } else {
                    let combinedVC = CombinedAboutViewController(aboutPages: result)
                    combinedVC.title = "About Us"
                    self.navigationController?.pushViewController(combinedVC, animated: true)
                }
            }
        }
    }
    
    @IBAction func Privacy(_ sender: Any) {
        LoginAPi.GetPrivacyPage { result in
            DispatchQueue.main.async {
                if result.isEmpty {
                    // Show error message if no data
                    let alert = UIAlertController(
                        title: "Error",
                        message: "Could not load about pages",
                        preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                } else {
                    let combinedVC = CombinedAboutViewController(aboutPages: result)
                    combinedVC.title = "Privacy Policy"
                    self.navigationController?.pushViewController(combinedVC, animated: true)
                }
            }
        }
        
    }
    
    
    
    var messagee = ""
    var Action = ""
    var cancel = ""
    var logoutT = ""
    var logoutM = ""
    
    @IBAction func LogOut(_ sender: Any) {
        if CheckInternet.Connection(){
            if XLanguage.get() == .English{
                self.logoutT = "Logout?"
                self.logoutM = "Are you sure you want to logout?"
                self.Action = "Logout"
                self.cancel = "No"
            }else if XLanguage.get() == .Arabic{
                self.logoutT = "حذف الحساب"
                self.logoutM = "هل أنت متأكد من أنك تريد تسجيل الخروج؟"
                self.Action = "تسجيل الخروج"
                self.cancel = "لا"
            }else{
                self.logoutT = "دەرچوون؟"
                self.logoutM = "دڵنیای کە دەتەوێت دەربچیت؟"
                self.Action = "چوونە دەرەوە"
                self.cancel = "نەخێر"
            }
            let myAlert = UIAlertController(title: logoutT, message: logoutM, preferredStyle: UIAlertController.Style.alert)
            myAlert.addAction(UIAlertAction(title: Action, style: .default, handler: { (UIAlertAction) in
            LoginAPi.LogOut { status in
                DispatchQueue.main.async {
                    if status == "success"{
                        UserDefaults.standard.set("false", forKey: "login")
                        UserDefaults.standard.set("", forKey: "token")
                        openCartApi.token = ""
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let myVC = storyboard.instantiateViewController(withIdentifier: "Home") as! TabbarView
                        myVC.modalPresentationStyle = .overFullScreen
                        myVC.modalTransitionStyle = .crossDissolve
                        self.present(myVC, animated: true)
                    }
                }
            }
            }))
            myAlert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
            self.present(myAlert, animated: true, completion: nil)
            
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
    
    
    
    
    @IBAction func DeleteAccount(_ sender: Any) {
        if CheckInternet.Connection(){
            if XLanguage.get() == .English{
                self.logoutT = "Account Deletion"
                self.logoutM = "Are you sure you want to delete your account?"
                self.Action = "I'm sure"
                self.cancel = "No"
            }else if XLanguage.get() == .Arabic{
                self.logoutT = "حذف الحساب"
                self.logoutM = "هل أنت متأكد أنك تريد حذف حسابك؟"
                self.Action = "انا متأكد"
                self.cancel = "لا"
            }else{
                self.logoutT = "سڕینەوەی ئەکاونت"
                self.logoutM = "دڵنیای کە دەتەوێت ئەکاونتەکەت بسڕیتەوە؟"
                self.Action = "من دڵنیام"
                self.cancel = "نەخێر"
            }
            
            let myAlert = UIAlertController(title: logoutT, message: logoutM, preferredStyle: UIAlertController.Style.alert)
            myAlert.addAction(UIAlertAction(title: Action, style: .default, handler: { (UIAlertAction) in
            LoginAPi.DeleteAccount { status in
                DispatchQueue.main.async {
                    if status == "success"{
                        UserDefaults.standard.set("false", forKey: "login")
                        UserDefaults.standard.set("", forKey: "token")
                        openCartApi.token = ""
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let myVC = storyboard.instantiateViewController(withIdentifier: "Home") as! TabbarView
                        myVC.modalPresentationStyle = .overFullScreen
                        myVC.modalTransitionStyle = .crossDissolve
                        self.present(myVC, animated: true)
                    }
                }
            }
            }))
            myAlert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
            self.present(myAlert, animated: true, completion: nil)
            
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
