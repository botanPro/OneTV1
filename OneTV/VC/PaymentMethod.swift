//
//  PaymentMethod.swift
//  OneTV
//
//  Created by Botan Amedi on 19/04/2025.
//

import UIKit
import BSImagePicker
import Photos
import EFInternetIndicator
import Drops
class PaymentMethod: UIViewController ,InternetStatusIndicable{
    
    
    
    var internetConnectionIndicator: EFInternetIndicator.InternetViewIndicator?


    @IBOutlet weak var UserPhone: UITextField!
    @IBOutlet weak var TransImage: UIImageView!
    @IBOutlet weak var SendLable: UILabel!
    @IBOutlet weak var PhoneNumber: UILabel!
    
    
    
    var planid = 0
    var price = ""
    var number = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TransImage.isHidden = true
        
        self.SendLable.text = "Send \(self.price.currencyFormatting()) to this number with FIB"
        self.PhoneNumber.text = self.number
        
    }
    
    
    
    
    
    var SelectedAssets = [PHAsset]()
    var Images : [UIImage] = []
    var ImageUrl : [String] = []
    @IBAction func UploadImage(_ sender: Any) {
        self.SelectedAssets.removeAll()
        let vc = BSImagePickerViewController()
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
        }, deselect: { (asset: PHAsset) -> Void in
        }, cancel: { (assets: [PHAsset]) -> Void in
        }, finish: { (assets: [PHAsset]) -> Void in
            for i in 0..<assets.count{
                self.SelectedAssets.append(assets[i])
                print(self.SelectedAssets)
            }
            self.getAllImages()
        }, completion: nil)
    }
    
    
    
    func getAllImages() -> Void {
        if SelectedAssets.count != 0{
            for i in 0..<SelectedAssets.count{
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.isSynchronous = true
                manager.requestImage(for: SelectedAssets[i], targetSize: CGSize(width: 512, height: 512), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                    thumbnail = result!
                })
                self.TransImage.isHidden = false
                self.Images.append(thumbnail)
                self.TransImage.image = thumbnail
            }
        }
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
    
    
    private var lastTapTime: TimeInterval = 0
    @IBAction func Submit(_ sender: Any) {
        let currentTime = Date().timeIntervalSince1970
        guard currentTime - lastTapTime > 1 else { return } // 0.5s delay
        lastTapTime = currentTime
        if CheckInternet.Connection() == true{
            if self.Images.count != 0 && self.UserPhone.text != ""{
                if UserDefaults.standard.string(forKey: "login") == "true"{
                    guard let image = self.TransImage.image,
                          let imageData = image.jpegData(compressionQuality: 0.8) else {
                        print("Could not get image data")
                        return
                    }
                    
                    let url = URL(string: "https://one-tv.net/api/deposit/insert?plan_id=\(self.planid)&phone=\(self.UserPhone.text!)")!
                    var request = URLRequest(url: url, timeoutInterval: Double.infinity)
                    
                    // Set the authorization header
                    request.addValue("Bearer \(openCartApi.token)", forHTTPHeaderField: "Authorization")
                    request.httpMethod = "POST"
                    
                    // Generate boundary string
                    let boundary = "Boundary-\(UUID().uuidString)"
                    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                    
                    // Create the multipart form data body
                    var body = Data()
                    
                    // Add image data
                    body.append("--\(boundary)\r\n".data(using: .utf8)!)
                    body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
                    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                    body.append(imageData)
                    body.append("\r\n".data(using: .utf8)!)
                    
                    // Close the body
                    body.append("--\(boundary)--\r\n".data(using: .utf8)!)
                    
                    request.httpBody = body
                    
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        if let error = error {
                            print("Error: \(error)")
                            return
                        }
                        
                        guard let data = data else {
                            print("No data received")
                            return
                        }
                        
                        if let responseString = String(data: data, encoding: .utf8) {
                            print("Response: \(responseString)")
                            
                            
                            
                            let successMessage = """
                            Thank you for your submission. 
                            For security verification, we're sending an activation code to your WhatsApp number. 
                            
                            1. Check your WhatsApp messages
                            2. Enter the code in your Profile section
                            3. Complete your account setup
                            """
                            
                            if XLanguage.get() == .English{
                                self.showDrop(title: """
                            Thank you for your submission. 
                            For security verification, we're sending an activation code to your WhatsApp number. 
                            
                            1. Check your WhatsApp messages
                            2. Enter the code in your Profile section
                            3. Complete your account setup
                            """, message: successMessage)
                            }else if XLanguage.get() == .Arabic{
                                self.showDrop(title: """
                            سوپاس بۆ پێشکەشکردنەکەت. 
                            بۆ پشتڕاستکردنەوەی ئاسایش، ئێمە کۆدی چالاککردن دەنێرین بۆ ژمارەی واتسئەپەکەت. 

                            1. نامەکانی واتسئەپەکەت بپشکنە 
                            2. کۆدەکە لە بەشی Profile داخڵ بکە 
                            3. ڕێکخستنی ئەکاونتەکەت تەواو بکە
                            """, message: successMessage)
                            }else{
                                self.showDrop(title: """
                            شكرًا لمشاركتك.
                            للتحقق الأمني، سنرسل رمز تفعيل إلى رقم واتساب الخاص بك.

                            1. تحقق من رسائل واتساب الخاصة بك.
                            2. أدخل الرمز في ملفك الشخصي.
                            3. أكمل إعداد حسابك.
                            """, message: successMessage)
                            }
                            
                            DispatchQueue.main.async {
                                let alert = UIAlertController(
                                    title: "Request Submitted",
                                    message: successMessage,
                                    preferredStyle: .alert
                                )
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                                    
                                    self.navigationController?.popViewController(animated: true)
                                }))
                                self.present(alert, animated: true)
                            }
                            
                            
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
                if self.Images.count != 0{
                    if XLanguage.get() == .English{
                        self.showDrop(title: "", message: "Please upload transection image")
                    }else if XLanguage.get() == .Arabic{
                        self.showDrop(title: "", message: "يرجى تحميل صورة المعاملة")
                    }else{
                        self.showDrop(title: "", message: "تکایە وێنەی مامەڵەکە ئەپلۆد بکەن.")
                    }
                    return
                }
                
                
                if self.UserPhone.text! == ""{
                    if XLanguage.get() == .English{
                        self.showDrop(title: "", message: "Please enter your phone number")
                    }else if XLanguage.get() == .Arabic{
                        self.showDrop(title: "", message: "الرجاء إدخال رقم هاتفك")
                    }else{
                        self.showDrop(title: "", message: "تکایە ژمارەی تەلەفۆنەکەت بنووسە")
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
    
    
    
}
