//
//  XLanguages.swift
//  IQ Flowers
//
//  Created by Botan Amedi on 06/12/2024.
//

//
//  XLanguages.swift
//  rollTest
//
//  Created by Botan Amedi on 18/01/2021.
//

import UIKit

class XLanguage {
    
    enum LanguageEnum : String {
        case Kurdish
        case English
        case Arabic
        case none
    }
    
    
    static func set(Language : LanguageEnum){
    UserDefaults.standard.set(Language.rawValue, forKey: "lang")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LanguageChanged"), object: nil)
    }
    static func get()->LanguageEnum{
        if let lang = UserDefaults.standard.value(forKey: "lang") as? String{
            if lang == "Arabic"{
                return .Arabic
            }else if lang == "Kurdish"{
                return .Kurdish
            }else if lang == "English"{
                return .English
            }
        }
        return .none
    }
    
}


class Languagebutton: UIButton{
    @IBInspectable var ArabicTextSize : CGFloat = 0{
        didSet{
            update()
        }
    }
    
    @IBInspectable var EnglishTextSize : CGFloat = 0{
        didSet{
            update()
        }
    }
    
    
    @IBInspectable var ArabicText : String = ""{
        didSet{
            update()
        }
    }
    @IBInspectable var KurdishText : String = ""{
        didSet{
            update()
        }
    }
    @IBInspectable var EnglishText : String = ""{
        didSet{
            update()
        }
    }
    
    @objc func update(){
        
        if XLanguage.get() == .Arabic{
            self.setTitle(self.ArabicText , for: .normal)
            self.titleLabel?.font = UIFont(name: "PeshangDes2", size: ArabicTextSize)!
        }else if XLanguage.get() == .Kurdish{
            self.setTitle(self.KurdishText , for: .normal)
            self.titleLabel?.font = UIFont(name: "PeshangDes2", size: ArabicTextSize)!
        }else if XLanguage.get() == .English{
            self.setTitle(self.EnglishText , for: .normal)
            self.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: ArabicTextSize)!
        }
        
    }
     
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(Languagebutton.update), name: NSNotification.Name(rawValue: "LanguageChanged"), object: nil)
    }
}





class LanguageTabBarItem: UITabBarItem{
    
    @IBInspectable var ArabicText : String = ""{
        didSet{
            update()
        }
    }
    @IBInspectable var KurdishText : String = ""{
        didSet{
            update()
        }
    }
    @IBInspectable var EnglishText : String = ""{
        didSet{
            update()
        }
    }
    
    @objc func update(){
        if XLanguage.get() == .Arabic{
            self.title = ArabicText
            self.setTitleTextAttributes(
                [
                    NSAttributedString.Key.font: UIFont(name: "PeshangDes2", size: 11)!,
                    NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)
                ], for: .normal)
        }else if XLanguage.get() == .Kurdish{
            self.title = KurdishText
            self.setTitleTextAttributes(
                [
                    NSAttributedString.Key.font: UIFont(name: "PeshangDes2", size: 11)!,
                    NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)
                ], for: .normal)
        }else if XLanguage.get() == .English{
            self.title = EnglishText
            self.setTitleTextAttributes(
                [
                    NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 11)!,
                    NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)
                ], for: .normal)
         
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(LanguageTabBarItem.update), name: NSNotification.Name(rawValue: "LanguageChanged"), object: nil)
    }
    
}




class LanguageLable: UILabel{
    
    @IBInspectable var ArabicTextSize : CGFloat = 0{
        didSet{
            update()
        }
    }
    
    @IBInspectable var EnglishTextSize : CGFloat = 0{
        didSet{
            update()
        }
    }

    @IBInspectable var ArabicText : String = ""{
        didSet{
            update()
        }
    }
    @IBInspectable var KurdishText : String = ""{
        didSet{
            update()
        }
    }
    @IBInspectable var EnglishText : String = ""{
        didSet{
            update()
        }
    }
    
    @objc func update(){
       
        if XLanguage.get() == .Arabic{
            self.text = ArabicText
            self.font = UIFont(name: "PeshangDes2", size: ArabicTextSize)!
        }else if XLanguage.get() == .Kurdish{
            self.text = KurdishText
            self.font = UIFont(name: "PeshangDes2", size: ArabicTextSize)!
        }else if XLanguage.get() == .English{
            self.text = EnglishText
            self.font = UIFont(name: "ArialRoundedMTBold", size: EnglishTextSize)!
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(LanguageLable.update), name: NSNotification.Name(rawValue: "LanguageChanged"), object: nil)
    }
}



class LanguagePlaceHolder: UITextField{
    
    @IBInspectable var ArabicTextSize : CGFloat = 0{
        didSet{
            update()
        }
    }
    
    @IBInspectable var EnglishTextSize : CGFloat = 0{
        didSet{
            update()
        }
    }
    
    
    @IBInspectable var ArabicText : String = ""{
        didSet{
            update()
        }
    }
    @IBInspectable var KurdishText : String = ""{
        didSet{
            update()
        }
    }
    @IBInspectable var EnglishText : String = ""{
        didSet{
            update()
        }
    }
    
    @objc func update(){
        
        if XLanguage.get() == .Arabic{
            self.placeholder = ArabicText
            self.font = UIFont(name: "PeshangDes2", size: ArabicTextSize)!
        }else if XLanguage.get() == .Kurdish{
            self.placeholder = KurdishText
            self.font = UIFont(name: "PeshangDes2", size: ArabicTextSize)!
        }else if XLanguage.get() == .English{
            self.placeholder = EnglishText
            self.font = UIFont(name: "ArialRoundedMTBold", size: EnglishTextSize)!
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(LanguagePlaceHolder.update), name: NSNotification.Name(rawValue: "LanguageChanged"), object: nil)
    }
}



class LanguageNvigationItem: UINavigationItem{
    

    @IBInspectable var ArabicText : String = ""{
        didSet{
            update()
        }
    }
    @IBInspectable var KurdishText : String = ""{
        didSet{
            update()
        }
    }
    @IBInspectable var EnglishText : String = ""{
        didSet{
            update()
        }
    }
    
    @objc func update(){
        if XLanguage.get() == .Arabic{
            self.title = ArabicText
        }else if XLanguage.get() == .Kurdish{
            self.title = KurdishText
        }else if XLanguage.get() == .English{
            self.title = EnglishText
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(LanguageNvigationItem.update), name: NSNotification.Name(rawValue: "LanguageChanged"), object: nil)
    }
}


class LanguageBarItem: UIBarButtonItem{
    
    
    @IBInspectable var ArabicTextSize : CGFloat = 0{
        didSet{
            update()
        }
    }
    
    @IBInspectable var EnglishTextSize : CGFloat = 0{
        didSet{
            update()
        }
    }
    
    
    
    @IBInspectable var ArabicText : String = ""{
        didSet{
            update()
        }
    }
    @IBInspectable var KurdishText : String = ""{
        didSet{
            update()
        }
    }
    @IBInspectable var EnglishText : String = ""{
        didSet{
            update()
        }
    }
    
    @objc func update(){
        
        if XLanguage.get() == .Arabic{
            self.title = ArabicText
            self.setTitleTextAttributes(
                [
                    NSAttributedString.Key.font: UIFont(name: "PeshangDes2", size: ArabicTextSize)!,
                    NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)
                ], for: .normal)
        }else if XLanguage.get() == .Kurdish{
            self.setTitleTextAttributes(
                [
                    NSAttributedString.Key.font: UIFont(name: "PeshangDes2", size: ArabicTextSize)!,
                    NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)
                ], for: .normal)
            self.title = KurdishText
        }else if XLanguage.get() == .English{
            self.setTitleTextAttributes(
                [
                    NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: EnglishTextSize)!,
                    NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)
                ], for: .normal)
            self.title = EnglishText
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(LanguageBarItem.update), name: NSNotification.Name(rawValue: "LanguageChanged"), object: nil)
}
}








class NavigationBarLang: UINavigationBar{
    
    
    @IBInspectable var ArabicTextSize : CGFloat = 0{
        didSet{
            update()
        }
    }
    
    @IBInspectable var EnglishTextSize : CGFloat = 0{
        didSet{
            update()
        }
    }
    
    
    
    @objc func update(){
        
        if XLanguage.get() == .Arabic{
            self.titleTextAttributes =
            [
                NSAttributedString.Key.font: UIFont(name: "PeshangDes2", size: ArabicTextSize)!,
                NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.07560480386, green: 0.2257080078, blue: 0.3554315865, alpha: 1)
            ]
        }else if XLanguage.get() == .Kurdish{
            self.titleTextAttributes =
            [
                NSAttributedString.Key.font: UIFont(name: "PeshangDes2", size: ArabicTextSize)!,
                NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.07560480386, green: 0.2257080078, blue: 0.3554315865, alpha: 1)
            ]
        }else if XLanguage.get() == .English{
            self.titleTextAttributes =
            [
                NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: EnglishTextSize)!,
                NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.07560480386, green: 0.2257080078, blue: 0.3554315865, alpha: 1)
            ]
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(NavigationBarLang.update), name: NSNotification.Name(rawValue: "LanguageChanged"), object: nil)
    }
}








class LanguageSegment: UISegmentedControl{
    
    @IBInspectable var ArabicText0 : String = ""{
        didSet{
            update()
        }
    }
    @IBInspectable var KurdishText0 : String = ""{
        didSet{
            update()
        }
    }
    @IBInspectable var EnglishText0 : String = ""{
        didSet{
            update()
        }
    }
    
    @IBInspectable var ArabicText1 : String = ""{
        didSet{
            update()
        }
    }
    @IBInspectable var KurdishText1 : String = ""{
        didSet{
            update()
        }
    }
    @IBInspectable var EnglishText1 : String = ""{
        didSet{
            update()
        }
    }
    
    @objc func update(){
        
        if XLanguage.get() == .Arabic{
            self.setTitle(ArabicText0, forSegmentAt: 0)
            self.setTitle(ArabicText1, forSegmentAt: 1)
        }else if XLanguage.get() == .Kurdish{
            self.setTitle(KurdishText0, forSegmentAt: 0)
            self.setTitle(KurdishText1, forSegmentAt: 1)
        }else if XLanguage.get() == .English{
            self.setTitle(EnglishText0, forSegmentAt: 0)
            self.setTitle(EnglishText1, forSegmentAt: 1)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(LanguageSegment.update), name: NSNotification.Name(rawValue: "LanguageChanged"), object: nil)
}
}


