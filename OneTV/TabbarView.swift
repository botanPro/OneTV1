//
//  TabbarView.swift
//  OneTV
//
//  Created by Botan Amedi on 17/04/2025.
//

import UIKit

class TabbarView: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if XLanguage.get() == .English{print("English")
            tabBar.items![0].title = "Home"
            tabBar.items![1].title = "Movies"
            tabBar.items![2].title = "Series"
            tabBar.items![3].title = "Profile"
           
            tabBar.items![0].setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 11)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)], for: .normal)
            tabBar.items![1].setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 11)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)], for: .normal)
            tabBar.items![2].setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 11)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)], for: .normal)
            tabBar.items![3].setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 11)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)], for: .normal)
            
        }else if XLanguage.get() == .Arabic{print("Arabic")
            tabBar.items![0].title = "الرئيسية"
            tabBar.items![1].title = "الأفلام"
            tabBar.items![2].title = "المسلسلات"
            tabBar.items![3].title = "الملف الشخصي"
            
            tabBar.items![0].setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "PeshangDes2", size: 11)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)], for: .normal)
            tabBar.items![1].setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "PeshangDes2", size: 11)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)], for: .normal)
            tabBar.items![2].setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "PeshangDes2", size: 11)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)], for: .normal)
            tabBar.items![3].setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "PeshangDes2", size: 11)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)], for: .normal)
        }else{print("Kurdish")
            tabBar.items![0].title = "سەرەکی"
            tabBar.items![1].title = "فیلمەکان"
            tabBar.items![2].title = "زنجیرەکان"
            tabBar.items![3].title = "پرۆفایل"
            
            tabBar.items![0].setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "PeshangDes2", size: 11)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)], for: .normal)
            tabBar.items![1].setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "PeshangDes2", size: 11)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)], for: .normal)
            tabBar.items![2].setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "PeshangDes2", size: 11)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)], for: .normal)
            tabBar.items![3].setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "PeshangDes2", size: 11)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)], for: .normal)
        }

        
    }
    
    
    @objc func update(){
        if XLanguage.get() == .English{print("English")
            tabBar.items![0].title = "Home"
            tabBar.items![1].title = "Movies"
            tabBar.items![2].title = "Series"
            tabBar.items![3].title = "Profile"
           
            tabBar.items![0].setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 11)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)], for: .normal)
            tabBar.items![1].setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 11)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)], for: .normal)
            tabBar.items![2].setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 11)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)], for: .normal)
            tabBar.items![3].setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 11)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)], for: .normal)
            
        }else if XLanguage.get() == .Arabic{print("Arabic")
            tabBar.items![0].title = "الرئيسية"
            tabBar.items![1].title = "الأفلام"
            tabBar.items![2].title = "المسلسلات"
            tabBar.items![3].title = "الملف الشخصي"
            
            tabBar.items![0].setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "PeshangDes2", size: 11)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)], for: .normal)
            tabBar.items![1].setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "PeshangDes2", size: 11)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)], for: .normal)
            tabBar.items![2].setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "PeshangDes2", size: 11)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)], for: .normal)
            tabBar.items![3].setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "PeshangDes2", size: 11)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)], for: .normal)
        }else{print("Kurdish")
            tabBar.items![0].title = "سەرەکی"
            tabBar.items![1].title = "فیلمەکان"
            tabBar.items![2].title = "زنجیرەکان"
            tabBar.items![3].title = "پرۆفایل"
            
            tabBar.items![0].setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "PeshangDes2", size: 11)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)], for: .normal)
            tabBar.items![1].setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "PeshangDes2", size: 11)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)], for: .normal)
            tabBar.items![2].setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "PeshangDes2", size: 11)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)], for: .normal)
            tabBar.items![3].setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "PeshangDes2", size: 11)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.8049960732, blue: 0.9077830315, alpha: 1)], for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name(rawValue: "LanguageChanged"), object: nil)
    }
    

}
