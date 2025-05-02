//
//  LanguagesVC.swift
//  OneTV
//
//  Created by Botan Amedi on 01/05/2025.
//

import UIKit

class LanguagesVC: UIViewController {
    
    @IBOutlet weak var LanguagesTableView: UITableView!{didSet{self.LanguagesTableView.delegate = self; self.LanguagesTableView.dataSource = self}}
    var LanguagesArray : [languages] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        LanguagesTableView.register(UINib(nibName: "SettingsTableViewTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.LanguagesArray.append(languages(id: 1, name: "English"))
        self.LanguagesArray.append(languages(id: 2, name: "کوردی"))
        self.LanguagesArray.append(languages(id: 3, name: "العربیة"))
        LanguagesTableView.reloadData()
    }
    
}

extension LanguagesVC : UITableViewDelegate , UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if LanguagesArray.count == 0{
            return 0
        }
        return LanguagesArray.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SettingsTableViewTableViewCell
        cell.Name.text = LanguagesArray[indexPath.row].name
        
        if indexPath.row == 0{
            cell.Name.font = UIFont(name: "ArialRoundedMTBold", size: 13)!
        }else{
            cell.Name.font = UIFont(name: "PeshangDes2", size: 13)!
        }
        
        
        if UserDefaults.standard.integer(forKey: "Selectedlanguage") == LanguagesArray[indexPath.row].id{
            cell.Imagee.isHidden = false
        }else{
            cell.Imagee.isHidden = true
        }
        
        return cell
    }

   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            XLanguage.set(Language: .English)
            UserDefaults.standard.setValue("English", forKey: "lang")
            UserDefaults.standard.setValue(LanguagesArray[indexPath.row].id, forKey: "Selectedlanguage")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LanguageChanged"), object: nil )
            self.navigationController?.popViewController(animated: true)
        }
        if indexPath.row == 1{
            XLanguage.set(Language: .Kurdish)
            UserDefaults.standard.setValue("Kurdish", forKey: "lang")
            UserDefaults.standard.setValue(LanguagesArray[indexPath.row].id, forKey: "Selectedlanguage")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LanguageChanged"), object: nil)
            self.navigationController?.popViewController(animated: true)
        }
        if indexPath.row == 2{
            XLanguage.set(Language: .Arabic)
            UserDefaults.standard.setValue("Arabic", forKey: "lang")
            UserDefaults.standard.setValue(LanguagesArray[indexPath.row].id, forKey: "Selectedlanguage")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LanguageChanged"), object: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
}






class languages{
    var id : Int
    var name : String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
