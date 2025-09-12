//
//  AllLiveTvs.swift
//  OneTV
//
//  Created by Botan Amedi on 10/04/2025.
//

import UIKit
import AVFoundation
import AudioToolbox
import FSPagerView
import SDWebImage
import AZDialogView
import EFInternetIndicator
import CRRefresh

import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseMessaging
import CHIPageControl

class AllLiveTvs: UIViewController {
    @IBOutlet weak var AllTVsCollectionView: UICollectionView!
    
    @IBOutlet weak var Categories: UICollectionView!
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    var numberOfItemsPerRow: CGFloat = 3
    let spacingBetweenCells: CGFloat = 10
    var selectedCategory = ""
    var categoryArray : [String] = []
    var LiveArray : [LiveTVResponse] = []
    var groupedChannels: [(category: String, channels: [Channel])] = []
    private var lastTapTime: TimeInterval = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Categories.register(UINib(nibName: "FilltersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        // Register header views for both collection views
        AllTVsCollectionView.register(UINib(nibName: "LiveTVHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        Categories.register(UINib(nibName: "LiveTVHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        
        AllTVsCollectionView.register(UINib(nibName: "LiveTVCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        getAllLiveTVs()
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
                self.Categories.reloadData()
            }
            print("category count: \(self.groupedChannels.count)")
        }
    }
    

}

extension AllLiveTvs : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == Categories {
            return 1 // Categories collection view has only one section
        }
        return groupedChannels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == Categories {
            return groupedChannels.count // Return the number of categories
        }
        
        if collectionView == self.AllTVsCollectionView {
            if groupedChannels.isEmpty || section >= groupedChannels.count || groupedChannels[section].channels.isEmpty {
                return 0
            }
            return groupedChannels[section].channels.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == Categories {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FilltersCollectionViewCell
            
            // Make sure we don't go out of bounds
            guard indexPath.item < groupedChannels.count else {
                return cell
            }
            
            cell.Name.text = groupedChannels[indexPath.item].category
            if selectedCategory == groupedChannels[indexPath.item].category {
                cell.FilterView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.FilterView.layer.borderWidth = 1
                cell.FilterView.layer.cornerRadius = 16
            } else {
                cell.FilterView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                cell.FilterView.layer.borderWidth = 0.7
                cell.FilterView.layer.cornerRadius = 16
            }
            return cell
        }
        
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
    
    func estimatedFrame(text: String, font: UIFont) -> CGRect {
        let size = CGSize(width: 200, height: 1000) // temporary size
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size,
                                                   options: options,
                                                   attributes: [NSAttributedString.Key.font: font],
                                                   context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.Categories {
            // Make sure we don't go out of bounds
            guard indexPath.item < groupedChannels.count else {
                return CGSize(width: 100, height: 50)
            }
            
            let text = groupedChannels[indexPath.item].category
            let width = self.estimatedFrame(text: text, font: UIFont.systemFont(ofSize: 14)).width
            return CGSize(width: width + 45, height: 50)
        }
        
        
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        let isLandscape = UIDevice.current.orientation.isLandscape

        var numberOfItemsPerRow: CGFloat = 3
        var itemHeight: CGFloat = 120

        if isPad {
            numberOfItemsPerRow = 6
            itemHeight = 120
        } else if isLandscape {
            numberOfItemsPerRow = 5
            itemHeight = 120
        }
        
        
        let totalSpacing = (numberOfItemsPerRow * sectionInsets.left) + ((numberOfItemsPerRow - 1) * 10)
        let width = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
        return CGSize(width: width, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.Categories {
            return 0
        }
        return 10
    }


     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         if collectionView == self.Categories {
             return UIEdgeInsets(top: 0.0, left: 10.0, bottom: 10.0, right: 10.0)
         }
         return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
     }

    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        AudioServicesPlaySystemSound(1519)
        
        
        if collectionView == self.AllTVsCollectionView {
            let currentTime = Date().timeIntervalSince1970
            guard currentTime - lastTapTime > 0.8 else { return } // 0.8s delay
            lastTapTime = currentTime
            
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
        
        
        if collectionView == Categories {
            guard indexPath.item < groupedChannels.count else {
                return
            }
            
            self.selectedCategory = groupedChannels[indexPath.item].category
            self.Categories.reloadData()
            
            if let sectionIndex = groupedChannels.firstIndex(where: { $0.category == selectedCategory }) {
                // Get the layout attributes for the header of this section
                DispatchQueue.main.async {
                    // Using async to ensure the layout is updated
                    if let attributes = self.AllTVsCollectionView.collectionViewLayout.layoutAttributesForSupplementaryView(
                        ofKind: UICollectionView.elementKindSectionHeader,
                        at: IndexPath(item: 0, section: sectionIndex)) {
                        
                        // Get the frame of the header
                        let headerRect = attributes.frame
                        
                        // Scroll to position the header at the top
                        self.AllTVsCollectionView.setContentOffset(CGPoint(x: 0, y: headerRect.origin.y), animated: true)
                    } else {
                        // Fallback: if can't get header attributes, try to scroll to the first item
                        if self.groupedChannels[sectionIndex].channels.count > 0 {
                            let indexPath = IndexPath(item: 0, section: sectionIndex)
                            self.AllTVsCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
                        }
                    }
                }
            }
        }
    }
}
