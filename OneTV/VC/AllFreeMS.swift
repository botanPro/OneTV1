//
//  AllFreeMS.swift
//  OneTV
//
//  Created by Botan Amedi on 16/04/2025.
//

import UIKit
import AVFoundation
import AudioToolbox
import MBRadioCheckboxButton


class AllFreeMS: UIViewController, UIScrollViewDelegate{
    @IBOutlet weak var MovieSeriesCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        MovieSeriesCollection.register(UINib(nibName: "MovieAndSeriesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        getHomeDashboard()
        self.MovieSeriesCollection.delegate = self
    }
    

    
    var nextt = ""
    func getHomeDashboard(){
        if CheckInternet.Connection(){
            HomeAPI.GetHomeFree { free, next in
                self.nextt = next
                self.MovieArray = free
                self.MovieSeriesCollection.reloadData()
            }
        }
    }
    
    
    func getHomeDashboardNext(){
        if CheckInternet.Connection(){
            HomeAPI.GetHomeFreeNext(url: self.nextt) { free, next in
                self.nextt = next
                self.MovieArray.append(contentsOf: free)
                self.isLoading = false
                self.MovieSeriesCollection.reloadData()
            }
        }
    }
    
    
    
    var isLoading = false
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == MovieSeriesCollection else { return }
        let pos = scrollView.contentOffset.y
        let contentHeight = self.MovieSeriesCollection.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
            if pos > (contentHeight - 50) - scrollViewHeight {
                if isLoading == false && self.nextt != "" {
                    self.getHomeDashboardNext()
                    isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.isLoading = false
                    })
                }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.MovieSeriesCollection.collectionViewLayout.invalidateLayout()
        })
    }

    
    
    
    
    private var lastTapTime: TimeInterval = 0
    
    var MovieArray: [Item] = []
    
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 11.0, bottom: 0.0, right: 11.0)
    var numberOfItemsPerRow: CGFloat = 3
    let spacingBetweenCells: CGFloat = 11
    
}

extension AllFreeMS : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if MovieArray.count == 0 {
            return 0
        }
        
        return MovieArray.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieAndSeriesCollectionCell
        let urlString = self.MovieArray[indexPath.row].image.portrait
        let url = URL(string: "https://one-tv.net/assets/images/item/portrait/\(urlString)")
        cell.Imagee?.sd_setImage(with: url, completed: nil)
        cell.TypeView.isHidden = true
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            
            let isPad = UIDevice.current.userInterfaceIdiom == .pad
            let isLandscape = UIDevice.current.orientation.isLandscape

            var numberOfItemsPerRow: CGFloat = 3
            var itemHeight: CGFloat = 180

            if isPad {
                numberOfItemsPerRow = 6
                itemHeight = 245
            } else if isLandscape {
                numberOfItemsPerRow = 5
                itemHeight = 210
            }

            let totalSpacing = (numberOfItemsPerRow + 1) * sectionInsets.left
            let itemWidth = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow

            return CGSize(width: itemWidth, height: itemHeight)
        

        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    }
    
    
    func estimatedFrame(text: String, font: UIFont) -> CGRect {
        let size = CGSize(width: 200, height: 1000) // temporary size
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size,
                                                   options: options,
                                                   attributes: [NSAttributedString.Key.font: font],
                                                   context: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.spacingBetweenCells
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        AudioServicesPlaySystemSound(1519)
        let currentTime = Date().timeIntervalSince1970
        guard currentTime - lastTapTime > 0.8 else { return } // 0.5s delay
        lastTapTime = currentTime
        
        DispatchQueue.main.async {
            let loadingIndicator = UIActivityIndicatorView(style: .large)
            loadingIndicator.center = self.view.center
            loadingIndicator.startAnimating()
            loadingIndicator.tag = 999 // For easy reference
            self.view.addSubview(loadingIndicator)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "PlaySeriesVC") as! PlaySeriesVC
        HomeAPI.GetFreeItemById(i_id: self.MovieArray[indexPath.row].id) { [weak self] items, remark, episodes, related in
            if remark == "episode_video"{
                myVC.is_series = true
                myVC.EpisodesArray = episodes
            }else{
                myVC.is_series = false
            }
            myVC.RecommendedArray = related
            myVC.Series = items
            myVC.title = self?.MovieArray[indexPath.row].title
            DispatchQueue.main.async { // Ensure UI updates are on main thread
                if let loadingIndicator = self?.view.viewWithTag(999) as? UIActivityIndicatorView {
                    loadingIndicator.removeFromSuperview()
                    myVC.modalPresentationStyle = .overFullScreen
                    self?.present(myVC, animated: true)
                }
            }
            
        }
        
        
    }
    
    
}


