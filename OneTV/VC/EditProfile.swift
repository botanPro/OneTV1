//
//  EditProfile.swift
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



class EditProfile: UIViewController , UITextFieldDelegate, UITextViewDelegate, InternetStatusIndicable{
    var internetConnectionIndicator: EFInternetIndicator.InternetViewIndicator?

    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var SecondName: UITextField!
    @IBOutlet weak var FirstName: UITextField!
    
    
    
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var Stackbottom: NSLayoutConstraint!
    
    
    @IBOutlet weak var dismiss: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHiden), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        addDoneButtonOnKeyboard()

        SecondName.delegate = self
        FirstName.delegate = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
  
    
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

        SecondName.inputAccessoryView = toolbar
        FirstName.inputAccessoryView = toolbar
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
        FirstName.resignFirstResponder()
        SecondName.resignFirstResponder()
    }
    
    
    
    @IBAction func Save(_ sender: Any) {
        if CheckInternet.Connection() == true{
            LoadingView()
            if FirstName.text?.trimmingCharacters(in: .whitespaces) != "" && SecondName.text?.trimmingCharacters(in: .whitespaces) != ""{
//                UserDefaults.standard.setValue(token_type, forKey: "token")
//                UserDefaults.standard.setValue(user["id"].string ?? "", forKey: "user_id")
//                UserDefaults.standard.setValue("\(user["firstname"].string ?? "") \(user["lastname"].string ?? "")", forKey: "user_name")
//                UserDefaults.standard.setValue(user["firstname"].string ?? "", forKey: "first_name")
//                UserDefaults.standard.setValue(user["lastname"].string ?? "", forKey: "last_name")
//                UserDefaults.standard.setValue(user["id"].string ?? "", forKey: "user_email")
//                openCartApi.token = UserDefaults.standard.string(forKey: "token") ?? ""
            }else{
                
            }
        }else{
            
        }
        
    }
    
}
