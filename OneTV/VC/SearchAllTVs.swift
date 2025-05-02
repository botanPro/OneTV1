//
//  SearchAllTVs.swift
//  OneTV
//
//  Created by Botan Amedi on 02/05/2025.
//

import UIKit
import AVFoundation
import AudioToolbox
import EFInternetIndicator

class SearchAllTVs: UIViewController ,UITextFieldDelegate,InternetStatusIndicable{
    @IBOutlet weak var SearchText: UITextField!
    @IBOutlet weak var AllTVsCollectionView: UICollectionView!
    var internetConnectionIndicator: EFInternetIndicator.InternetViewIndicator?

    private var lastTapTime: TimeInterval = 0
    
    var workitem = WorkItem()
    var SearchCount : Int = 1
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    var numberOfItemsPerRow: CGFloat = 3
    let spacingBetweenCells: CGFloat = 10
    var groupedChannels: [(category: String, channels: [Channel])] = []

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if CheckInternet.Connection(){
            if textField.text == "" {
                self.groupedChannels.removeAll()
                self.getAllLiveTVs()
                SearchCount = 1
            }else{
                if SearchCount == 1{
                    SearchCount = 2
                }else{
                    self.AllTVsCollectionView.reloadData()
                }
                workitem.perform(after: 0.3) { [self] in
                    GetHomeTVAPI.SearchAllChannels(text: textField.text!) { tvResponses, channels in
                        guard let response = tvResponses.first else { return }
                        
                        self.groupedChannels = response.data.televisions.flatMap { tvData in
                            tvData.data.map { cat in
                                print("Category: \(cat.name)")
                                return (category: cat.name, channels: cat.channels)
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.AllTVsCollectionView.reloadData()
                        }
                        print("category count: \(self.groupedChannels.count)")
                    }
                }
            }
        }
    
        return true
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllLiveTVs()
        self.SearchText.delegate = self
        AllTVsCollectionView.register(UINib(nibName: "LiveTVHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        AllTVsCollectionView.register(UINib(nibName: "LiveTVCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
    }
    
    
    func getAllLiveTVs(){
        GetHomeTVAPI.GetAllChannels { tvResponses, channels in
            guard let response = tvResponses.first else { return }
            
            self.groupedChannels = response.data.televisions.flatMap { tvData in
                tvData.data.map { cat in
                    print("Category: \(cat.name)")
                    return (category: cat.name, channels: cat.channels)
                }
            }
            
            DispatchQueue.main.async {
                self.AllTVsCollectionView.reloadData()
            }
            print("category count: \(self.groupedChannels.count)")
        }
    }

}



extension SearchAllTVs : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return groupedChannels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.AllTVsCollectionView {
            if groupedChannels.isEmpty || section >= groupedChannels.count || groupedChannels[section].channels.isEmpty {
                return 0
            }
            return groupedChannels[section].channels.count
        }
        return 0
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.AllTVsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LiveTVCollectionCell
            
            // Make sure we don't go out of bounds
            guard indexPath.section < groupedChannels.count,
                  indexPath.row < groupedChannels[indexPath.section].channels.count else {
                return cell
            }
            
            let channel = groupedChannels[indexPath.section].channels[indexPath.row]
            cell.EpisodeLable.isHidden = false
            
            let urlString = "https://one-tv.net/assets/images/television/\(channel.image)"
            cell.Imagee.sd_setImage(with: URL(string: urlString), completed: nil)
            cell.Imagee.contentMode = .scaleToFill
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if collectionView == self.AllTVsCollectionView {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! LiveTVHeaderView
                
                // Make sure we don't go out of bounds
                if indexPath.section < groupedChannels.count {
                    header.titleLabel.text = groupedChannels[indexPath.section].category + " Channels"
                }
                return header
            }
        }
        return UICollectionReusableView()
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == self.AllTVsCollectionView {
            return CGSize(width: collectionView.bounds.width, height: 75)
        }
        return CGSize.zero // No header for Categories collection view
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let totalSpacing = (3 * sectionInsets.left) + ((3 - 1) * 10)
        let width = (collectionView.bounds.width - totalSpacing) / 3
        return CGSize(width: width, height: 120)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }


     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
     }

    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        AudioServicesPlaySystemSound(1519)
        
        let currentTime = Date().timeIntervalSince1970
        guard currentTime - lastTapTime > 0.8 else { return } // 0.8s delay
        lastTapTime = currentTime
        
        
        if collectionView == self.AllTVsCollectionView {
            guard indexPath.section < groupedChannels.count,
                  indexPath.row < groupedChannels[indexPath.section].channels.count else {
                return
            }
            
            guard indexPath.section < groupedChannels.count,
                  indexPath.row < groupedChannels[indexPath.section].channels.count else {
                return
            }

            if groupedChannels[indexPath.section].channels[indexPath.row].isPaid == 0{
                DispatchQueue.main.async {
                    let loadingIndicator = UIActivityIndicatorView(style: .large)
                    loadingIndicator.center = self.view.center
                    loadingIndicator.startAnimating()
                    loadingIndicator.tag = 999 // For easy reference
                    self.view.addSubview(loadingIndicator)
                }
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let myVC = storyboard.instantiateViewController(withIdentifier: "LiveTvShow") as! LiveTvShow
                myVC.url = groupedChannels[indexPath.section].channels[indexPath.row].url
                myVC.title = groupedChannels[indexPath.section].channels[indexPath.row].title
                DispatchQueue.main.async { // Ensure UI updates are on main thread
                    if let loadingIndicator = self.view.viewWithTag(999) as? UIActivityIndicatorView {
                        loadingIndicator.removeFromSuperview()
                        self.navigationController?.pushViewController(myVC, animated: true)
                    }
                }
                
                
            }else{
                
                if UserDefaults.standard.string(forKey: "login") == "true"{
                    DispatchQueue.main.async {
                        let loadingIndicator = UIActivityIndicatorView(style: .large)
                        loadingIndicator.center = self.view.center
                        loadingIndicator.startAnimating()
                        loadingIndicator.tag = 999 // For easy reference
                        self.view.addSubview(loadingIndicator)
                    }
                    
                    LoginAPi.getUserInfo { info in
                        if info.planId == 0{
                            DispatchQueue.main.async {
                                if let loadingIndicator = self.view.viewWithTag(999) as? UIActivityIndicatorView {
                                    loadingIndicator.removeFromSuperview()
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let myVC = storyboard.instantiateViewController(withIdentifier: "SubscribePlaneVC") as! SubscribePlaneVC
                                    myVC.modalPresentationStyle = .overFullScreen
                                    self.present(myVC, animated: true)
                                }
                            }
                        }else{
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let myVC = storyboard.instantiateViewController(withIdentifier: "LiveTvShow") as! LiveTvShow
                            myVC.url = self.groupedChannels[indexPath.section].channels[indexPath.row].url
                            myVC.title = self.groupedChannels[indexPath.section].channels[indexPath.row].title
                            DispatchQueue.main.async { // Ensure UI updates are on main thread
                                if let loadingIndicator = self.view.viewWithTag(999) as? UIActivityIndicatorView {
                                    loadingIndicator.removeFromSuperview()
                                    self.navigationController?.pushViewController(myVC, animated: true)
                                }
                            }
                        }
                    }
                }else{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let myVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    myVC.modalPresentationStyle = .fullScreen
                    self.present(myVC, animated: true)
                }
                
            }
            
        }
        

    }
}
