//
//  Home.swift
//  OneTV
//
//  Created by Botan Amedi on 06/03/2025.
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
import SwiftyJSON
import Drops


class Home: UIViewController, WatchTappedDelegate ,InternetStatusIndicable{

    
    
    var internetConnectionIndicator: EFInternetIndicator.InternetViewIndicator?
    
    
    
    func watch_tapped(_ id: Int,_ is_paid: Int) {
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
        
        
        
        if CheckInternet.Connection(){
            if is_paid == 1{
                if UserDefaults.standard.string(forKey: "login") == "true"{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let myVC = storyboard.instantiateViewController(withIdentifier: "PlaySeriesVC") as! PlaySeriesVC
                    LoginAPi.getUserInfo { info in
                        if info.planId == 0{
                            DispatchQueue.main.async { // Ensure UI updates are on main thread
                                if let loadingIndicator = self.view.viewWithTag(999) as? UIActivityIndicatorView {
                                    loadingIndicator.removeFromSuperview()
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let myVC = storyboard.instantiateViewController(withIdentifier: "SubscribePlaneVC") as! SubscribePlaneVC
                                    myVC.modalPresentationStyle = .overFullScreen
                                    self.present(myVC, animated: true)
                                }
                            }
                            
                        }else{
                            HomeAPI.GetPaidItemById(i_id: id, episode_id: 0) { items, remark, episodes, related, Astatus in
                                if Astatus == "success"{
                                    if remark == "episode_video"{
                                        myVC.is_series = true
                                        myVC.EpisodesArray = episodes
                                    }else{
                                        myVC.is_series = false
                                    }
                                    
                                    myVC.RecommendedArray = related
                                    myVC.Series = items
                                    myVC.title = items.title
                                    DispatchQueue.main.async { // Ensure UI updates are on main thread
                                        if let loadingIndicator = self.view.viewWithTag(999) as? UIActivityIndicatorView {
                                            loadingIndicator.removeFromSuperview()
                                            self.navigationController?.pushViewController(myVC, animated: true)
                                        }
                                    }
                                    
                                }else{
                                    DispatchQueue.main.async { // Ensure UI updates are on main thread
                                        if let loadingIndicator = self.view.viewWithTag(999) as? UIActivityIndicatorView {
                                            loadingIndicator.removeFromSuperview()
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            let myVC = storyboard.instantiateViewController(withIdentifier: "SubscribePlaneVC") as! SubscribePlaneVC
                                            myVC.modalPresentationStyle = .overFullScreen
                                            self.present(myVC, animated: true)
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                }else{
                    DispatchQueue.main.async { // Ensure UI updates are on main thread
                        if let loadingIndicator = self.view.viewWithTag(999) as? UIActivityIndicatorView {
                            loadingIndicator.removeFromSuperview()
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let myVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                            myVC.modalPresentationStyle = .fullScreen
                            self.present(myVC, animated: true)
                        }
                    }
                    
                }
            }else{
                HomeAPI.GetFreeItemById(i_id: id) { [weak self] items, remark, episodes, related in
                    guard let self = self else { return }
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let myVC = storyboard.instantiateViewController(withIdentifier: "PlaySeriesVC") as! PlaySeriesVC
                    DispatchQueue.main.async {
                        if let loadingIndicator = self.view.viewWithTag(999) as? UIActivityIndicatorView {
                            loadingIndicator.removeFromSuperview()
                        }
                        
                        myVC.is_series = (remark == "episode_video")
                        myVC.EpisodesArray = episodes
                        myVC.RecommendedArray = related
                        myVC.Series = items
                        myVC.title = items.title
                        
                        myVC.modalPresentationStyle = .overFullScreen
                        self.present(myVC, animated: true)
                        
                    }
                }
            }
            
        }else{
            DispatchQueue.main.async { // Ensure UI updates are on main thread
                if let loadingIndicator = self.view.viewWithTag(999) as? UIActivityIndicatorView {
                    loadingIndicator.removeFromSuperview()
                }
            }
            if XLanguage.get() == .English{
                self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"No internet connection.", remoteHostName: "magic.com")
                
            }else if XLanguage.get() == .Arabic{
                self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"لا يوجد اتصال بالإنترنت.", remoteHostName: "magic.com")
                
            }else{
                self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"هێلی ئینترنێت نیە", remoteHostName: "magic.com")
            }
        }
        
    }
    
    
    func showDrop(title: String, message: String) {
        let drop = Drop(
            title: title,
            subtitle: message,
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
    
    
    
    
    func wish_tapped(_ id: Int) {
        let currentTime = Date().timeIntervalSince1970
        guard currentTime - lastTapTime > 0.8 else { return }
        lastTapTime = currentTime
        print(id)
        if CheckInternet.Connection(){
            if UserDefaults.standard.string(forKey: "login") == "true"{
                var request = URLRequest(url: URL(string: "https://one-tv.net/api/add-wishlist?item_id=\(id)")!,timeoutInterval: Double.infinity)
                request.addValue("Bearer \(openCartApi.token)", forHTTPHeaderField: "Authorization")
                request.httpMethod = "POST"
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data else {
                        print(String(describing: error))
                        return
                    }
                    
                    print(String(data: data, encoding: .utf8)!)
                    let jsonData = JSON(data)
                    let success = jsonData["status"].stringValue
                    if success == "success"{
                        if XLanguage.get() == .English{
                            self.showDrop(title: "", message: "Added to wishlist")
                        }else if XLanguage.get() == .Arabic{
                            self.showDrop(title: "", message: "تمت الإضافة إلى قائمة المفضلة")
                        }else{
                            self.showDrop(title: "", message: "زیادکرا بۆ لیستی ئارەزووەکان")
                        }
                    }else{
                        let sms = jsonData["message"]["error"].stringValue
                        self.showDrop(title: sms, message: "")
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
            if XLanguage.get() == .English{
                self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"No internet connection.", remoteHostName: "magic.com")
                
            }else if XLanguage.get() == .Arabic{
                self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"لا يوجد اتصال بالإنترنت.", remoteHostName: "magic.com")
                
            }else{
                self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"هێلی ئینترنێت نیە", remoteHostName: "magic.com")
            }
        }
    }
    
    
    
    func didTouch(pager: CHIBasePageControl, index: Int) {
        print(pager, index)
    }
    
    
    @IBOutlet weak var ReklamCollection: UICollectionView!
    @IBOutlet weak var ReviewdCollection: UICollectionView!
    @IBOutlet weak var MostCollection: UICollectionView!
    @IBOutlet weak var FreeCollection: UICollectionView!
    @IBOutlet weak var NewstCollection: UICollectionView!
    @IBOutlet weak var LiveTVCollection: UICollectionView!
    @IBOutlet weak var SliderCollection: UICollectionView!
    
    
    var ReviewdArray: [Item] = []
    var MostArray: [Item] = []
    var FreeArray: [Item] = []
    var NewsrArray: [Item] = []
    var ReklamArray: [Item] = []
    
    
    @IBOutlet weak var OneTitile: UIBarButtonItem!
    
    @IBOutlet weak var PageController: CHIPageControlJaloro!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    var LiveArray : [Channel] = []
    var sliderImages : [Slider] = []
    
    @IBOutlet weak var SubScribeView: UIView!
    
    
    
    @IBAction func Favorites(_ sender: Any) {
        if UserDefaults.standard.string(forKey: "login") == "true"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myVC = storyboard.instantiateViewController(withIdentifier: "Wishlist") as! Wishlist
            self.navigationController?.pushViewController(myVC, animated: true)
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            myVC.modalPresentationStyle = .fullScreen
            self.present(myVC, animated: true)
        }
    }
    
    
    @IBAction func Notification(_ sender: Any) {
        if UserDefaults.standard.string(forKey: "login") == "true"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myVC = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
            self.navigationController?.pushViewController(myVC, animated: true)
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            myVC.modalPresentationStyle = .fullScreen
            self.present(myVC, animated: true)
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(GetSildesChangeLangs), name: NSNotification.Name(rawValue: "LanguageChanged"), object: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        GetSildes()
        GetTVs()
        getFree()
        getHomeDashboard()
        PageController.radius = 0
        PageController.tintColor = #colorLiteral(red: 0.02222905494, green: 0.4373427629, blue: 0.4898250103, alpha: 1)
        PageController.currentPageTintColor = #colorLiteral(red: 0, green: 0.719253242, blue: 0.8110727668, alpha: 1)
        PageController.padding = 6
        
        self.SubScribeView.isHidden = true
        
        
        ScrollView.cr.addHeadRefresh(animator: FastAnimator(), handler: { [self] in
            GetSildes()
            GetTVs()
            getFree()
            getHomeDashboard()
        })
        
        OneTitile.setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 25)!,
                NSAttributedString.Key.foregroundColor: UIColor.white
            ], for: .normal)
        
        
        
        ReviewdCollection.register(UINib(nibName: "MovieAndSeriesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        MostCollection.register(UINib(nibName: "MovieAndSeriesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        FreeCollection.register(UINib(nibName: "MovieAndSeriesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        NewstCollection.register(UINib(nibName: "MovieAndSeriesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        LiveTVCollection.register(UINib(nibName: "LiveTVCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        ReklamCollection.register(UINib(nibName: "ReklamCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        SliderCollection.register(UINib(nibName: "SliderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == SliderCollection {
            let pageWidth = SliderCollection.frame.width
            let currentScrollPosition = scrollView.contentOffset.x
            let fractionalPage = currentScrollPosition / pageWidth
            PageController.progress = Double(fractionalPage)
        }
    }
    
    
    
    @IBAction func ShowMoreLive(_ sender: Any) {
        
    }
    
    @IBAction func ShowMoreFree(_ sender: Any) {
        
    }
    
    func GetSildes(){
        SlidesObjectAPI.GetSlideImage { slides in
            self.sliderImages = slides.data.sliders
            
            for (i, slide) in self.sliderImages.enumerated(){
                if slide.item.itemType == 1{
                    if XLanguage.get() == .English{
                        if slide.item.isPaid == 0{
                            self.sliderImages[i].lable = "Free movie for you"
                        }else{
                            self.sliderImages[i].lable = "Available with subscription"
                        }
                    }else if XLanguage.get() == .Arabic{
                        if slide.item.isPaid == 0{
                            self.sliderImages[i].lable = "فيلم مجاني لك"
                        }else{
                            self.sliderImages[i].lable = "متوفر مع الاشتراك"
                        }
                    }else{
                        if slide.item.isPaid == 0{
                            self.sliderImages[i].lable = "فیلمی بێ بەرامبەر بۆ تو"
                        }else{
                            self.sliderImages[i].lable = "لەگەڵ بەشداریکردن بەردەستە"
                        }
                    }
                }else{
                    if XLanguage.get() == .English{
                        if slide.item.isPaid == 0{
                            self.sliderImages[i].lable = "Free series for you"
                        }else{
                            self.sliderImages[i].lable = "Available with subscription"
                        }
                    }else if XLanguage.get() == .Arabic{
                        if slide.item.isPaid == 0{
                            self.sliderImages[i].lable = "مسلسل مجاني لك"
                        }else{
                            self.sliderImages[i].lable = "متوفر مع الاشتراك"
                        }
                    }else{
                        if slide.item.isPaid == 0{
                            self.sliderImages[i].lable = "زنجیرەی بێ بەرامبەر بۆ تو"
                        }else{
                            self.sliderImages[i].lable = "لەگەڵ بەشداریکردن بەردەستە"
                        }
                    }
                }
            }
            
            self.PageController.numberOfPages = self.sliderImages.count
            self.ScrollView.cr.endHeaderRefresh()
            self.SliderCollection.reloadData()
        }
    }
    
    @objc func GetSildesChangeLangs(){
        SlidesObjectAPI.GetSlideImage { slides in
            self.sliderImages = slides.data.sliders
            
            for (i, slide) in self.sliderImages.enumerated(){
                if slide.item.itemType == 1{
                    if XLanguage.get() == .English{
                        if slide.item.isPaid == 0{
                            self.sliderImages[i].lable = "Free movie for you"
                        }else{
                            self.sliderImages[i].lable = "Available with subscription"
                        }
                    }else if XLanguage.get() == .Arabic{
                        if slide.item.isPaid == 0{
                            self.sliderImages[i].lable = "فيلم مجاني لك"
                        }else{
                            self.sliderImages[i].lable = "متوفر مع الاشتراك"
                        }
                    }else{
                        if slide.item.isPaid == 0{
                            self.sliderImages[i].lable = "فیلمی بێ بەرامبەر بۆ تو"
                        }else{
                            self.sliderImages[i].lable = "لەگەڵ بەشداریکردن بەردەستە"
                        }
                    }
                }else{
                    if XLanguage.get() == .English{
                        if slide.item.isPaid == 0{
                            self.sliderImages[i].lable = "Free series for you"
                        }else{
                            self.sliderImages[i].lable = "Available with subscription"
                        }
                    }else if XLanguage.get() == .Arabic{
                        if slide.item.isPaid == 0{
                            self.sliderImages[i].lable = "مسلسل مجاني لك"
                        }else{
                            self.sliderImages[i].lable = "متوفر مع الاشتراك"
                        }
                    }else{
                        if slide.item.isPaid == 0{
                            self.sliderImages[i].lable = "زنجیرەی بێ بەرامبەر بۆ تو"
                        }else{
                            self.sliderImages[i].lable = "لەگەڵ بەشداریکردن بەردەستە"
                        }
                    }
                }
            }
            
            self.PageController.numberOfPages = self.sliderImages.count
            self.ScrollView.cr.endHeaderRefresh()
            self.SliderCollection.reloadData()
        }
    }
    
    
    func GetTVs(){
        self.self.LiveArray.removeAll()
        GetHomeTVAPI.GetHomeTV(completion:  { tvs, chanels in
            for channel in chanels{
                self.LiveArray.append(contentsOf: channel.channels)
            }
            self.ScrollView.cr.endHeaderRefresh()
            self.LiveTVCollection.reloadData()
        })
    }
    
    
    func getFree(){
        //        if CheckInternet.Connection(){
        //            HomeAPI.GetHomeFree { free in
        //                self.FreeArray = free
        //                self.ScrollView.cr.endHeaderRefresh()
        //                self.FreeCollection.reloadData()
        //            }
        //        }
    }
    
    
    func getHomeDashboard(){
        if CheckInternet.Connection(){
            HomeAPI.GetHome { trailer, most, newest, featured, reviewd in
                self.FreeArray = trailer
                self.MostArray = most
                self.NewsrArray = newest
                self.ReklamArray = featured
                self.ReviewdArray = reviewd
                self.ScrollView.cr.endHeaderRefresh()
                self.MostCollection.reloadData()
                self.FreeCollection.reloadData()
                self.NewstCollection.reloadData()
                self.ReklamCollection.reloadData()
                self.ReviewdCollection.reloadData()
            }
        }
    }
    
    private var lastTapTime: TimeInterval = 0
    
    
    private func formatViews(_ views: Int) -> String {
        if views >= 1_000_000 {
            return String(format: "%.1fM", Double(views) / 1_000_000)
        } else if views >= 1_000 {
            return String(format: "%.1fK", Double(views) / 1_000)
        }
        return "\(views)"
    }
}





extension Home : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.SliderCollection{
            if self.sliderImages.count == 0 {
                return 0
            }
            
            return self.sliderImages.count
        }
        
        
        if collectionView == self.LiveTVCollection{
            if self.LiveArray.count == 0 {
                return 0
            }
            
            return self.LiveArray.count
        }
        
        
        if collectionView == self.FreeCollection{
            if FreeArray.count == 0 {
                return 0
            }
            
            return FreeArray.count
        }
        
        if collectionView == self.NewstCollection{
            if NewsrArray.count == 0 {
                return 0
            }
            
            return NewsrArray.count
        }
        
        if collectionView == self.ReklamCollection{
            if ReklamArray.count == 0 {
                return 0
            }
            
            return ReklamArray.count
        }
        
        if collectionView == self.MostCollection{
            if MostArray.count == 0 {
                return 0
            }
            
            return MostArray.count
        }
        
        if collectionView == self.ReviewdCollection{
            if ReviewdArray.count == 0 {
                return 0
            }
            
            return ReviewdArray.count
        }
        
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.SliderCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SliderCollectionViewCell
            let urlString = sliderImages[indexPath.row].item.image.portrait
            let url = URL(string: "https://one-tv.net/assets/images/item/portrait/\(urlString)")
            cell.Imagee?.sd_setImage(with: url, completed: nil)
            cell.Name.text = sliderImages[indexPath.row].item.title
            cell.genres.text = sliderImages[indexPath.row].lable
            
            cell.Rate.text = sliderImages[indexPath.row].item.ratings
            cell.Views.text = self.formatViews(sliderImages[indexPath.row].item.view)
            
            let urlString1 = sliderImages[indexPath.row].image_png
            let url1 = URL(string: "https://one-tv.net/assets/images/slider/png/\(urlString1)")
            cell.ImagePNG?.sd_setImage(with: url1, completed: nil)
            
            cell.item_id = sliderImages[indexPath.row].item.id
            cell.is_paid = sliderImages[indexPath.row].item.isPaid
            cell.delegate = self
            
            return cell
        }
        
        
        if collectionView == self.LiveTVCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LiveTVCollectionCell
            cell.EpisodeLable.isHidden = true
            let urlString = self.LiveArray[indexPath.row].image
            let url = URL(string: "https://one-tv.net/assets/images/television/\(urlString)")
            cell.Imagee?.sd_setImage(with: url, completed: nil)
            return cell
        }
        
        
        if collectionView == self.FreeCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieAndSeriesCollectionCell
            let urlString = self.FreeArray[indexPath.row].image.portrait
            let url = URL(string: "https://one-tv.net/assets/images/item/portrait/\(urlString)")
            print("Free url is : \(urlString)")
            cell.Imagee?.sd_setImage(with: url, completed: nil)
            cell.TypeView.isHidden = true
            return cell
        }
        
        if collectionView == self.NewstCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieAndSeriesCollectionCell
            let urlString = self.NewsrArray[indexPath.row].image.portrait
            let url = URL(string: "https://one-tv.net/assets/images/item/portrait/\(urlString)")
            cell.Imagee?.sd_setImage(with: url, completed: nil)
            cell.TypeView.isHidden = true
            
            return cell
        }
        
        if collectionView == self.ReklamCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ReklamCollectionCell
            let urlString = self.ReklamArray[indexPath.row].image.landscape
            let url = URL(string: "https://one-tv.net/assets/images/item/landscape/\(urlString)")
            cell.Imagee?.sd_setImage(with: url, completed: nil)
            
            return cell
        }
        
        if collectionView == self.MostCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieAndSeriesCollectionCell
            let urlString = self.MostArray[indexPath.row].image.portrait
            let url = URL(string: "https://one-tv.net/assets/images/item/portrait/\(urlString)")
            cell.Imagee?.sd_setImage(with: url, completed: nil)
            cell.TypeView.isHidden = true
            return cell
        }
        
        if collectionView == self.ReviewdCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieAndSeriesCollectionCell
            let urlString = self.ReviewdArray[indexPath.row].image.portrait
            let url = URL(string: "https://one-tv.net/assets/images/item/portrait/\(urlString)")
            cell.Imagee?.sd_setImage(with: url, completed: nil)
            cell.TypeView.isHidden = true
            return cell
        }
        
        
        return UICollectionViewCell()
        
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.LiveTVCollection{
            return CGSize(width: 100, height: 100)
        }
        
        if collectionView == self.SliderCollection{
            return CGSize(width: collectionView.frame.width, height: 640)
        }
        
        if collectionView == self.FreeCollection{
            return CGSize(width: 148, height: 215)
        }
        
        if collectionView == self.NewstCollection{
            return CGSize(width: 190, height: 300)
        }
        
        if collectionView == self.ReklamCollection{
            return CGSize(width: 333, height: 130)
        }
        
        if collectionView == self.MostCollection{
            return CGSize(width: 148, height: 215)
        }
        
        if collectionView == self.ReviewdCollection{
            return CGSize(width: 148, height: 215)
        }
        return CGSize()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        
        if collectionView == self.SliderCollection{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.SliderCollection{
            return 0
        }
        return 10
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        AudioServicesPlaySystemSound(1519)
        let currentTime = Date().timeIntervalSince1970
        guard currentTime - lastTapTime > 0.8 else { return } // 0.5s delay
        lastTapTime = currentTime
        
        
        
        
        
        if collectionView == self.LiveTVCollection{
            if self.LiveArray[indexPath.row].isPaid == 0{
                DispatchQueue.main.async {
                    let loadingIndicator = UIActivityIndicatorView(style: .large)
                    loadingIndicator.center = self.view.center
                    loadingIndicator.startAnimating()
                    loadingIndicator.tag = 999 // For easy reference
                    self.view.addSubview(loadingIndicator)
                }
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let myVC = storyboard.instantiateViewController(withIdentifier: "LiveTvShow") as! LiveTvShow
                myVC.url = self.LiveArray[indexPath.row].url
                myVC.title = self.LiveArray[indexPath.row].title
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
                            myVC.url = self.LiveArray[indexPath.row].url
                            myVC.title = self.LiveArray[indexPath.row].title
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
        
        
        
        if collectionView == self.FreeCollection {
            // Show loading indicator
            let loadingIndicator = UIActivityIndicatorView(style: .large)
            loadingIndicator.center = self.view.center
            loadingIndicator.startAnimating()
            loadingIndicator.tag = 999
            self.view.addSubview(loadingIndicator)
            
            let selectedItem = self.FreeArray[indexPath.row]
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let myVC = storyboard.instantiateViewController(withIdentifier: "PlaySeriesVC") as? PlaySeriesVC else {
                loadingIndicator.removeFromSuperview()
                return
            }
            
            HomeAPI.GetFreeItemById(i_id: selectedItem.id) { [weak self] items, remark, episodes, related in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    if let loadingIndicator = self.view.viewWithTag(999) as? UIActivityIndicatorView {
                        loadingIndicator.removeFromSuperview()
                    }
                    
                    myVC.is_series = (remark == "episode_video")
                    myVC.EpisodesArray = episodes
                    myVC.RecommendedArray = related
                    myVC.Series = items
                    myVC.title = selectedItem.title
                    
                    myVC.modalPresentationStyle = .overFullScreen
                    self.present(myVC, animated: true)
                    
                }
            }
        }
        
        
        
        if collectionView == self.NewstCollection{
            if UserDefaults.standard.string(forKey: "login") == "true"{
                DispatchQueue.main.async {
                    let loadingIndicator = UIActivityIndicatorView(style: .large)
                    loadingIndicator.center = self.view.center
                    loadingIndicator.startAnimating()
                    loadingIndicator.tag = 999 // For easy reference
                    self.view.addSubview(loadingIndicator)
                }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let myVC = storyboard.instantiateViewController(withIdentifier: "PlaySeriesVC") as! PlaySeriesVC
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
                        HomeAPI.GetPaidItemById(i_id: self.NewsrArray[indexPath.row].id, episode_id: 0) { items, remark, episodes, related, Astatus in
                            if Astatus == "success"{
                                if remark == "episode_video"{
                                    myVC.is_series = true
                                    myVC.EpisodesArray = episodes
                                }else{
                                    myVC.is_series = false
                                }
                                myVC.RecommendedArray = related
                                myVC.Series = items
                                myVC.title = self.NewsrArray[indexPath.row].title
                                DispatchQueue.main.async { // Ensure UI updates are on main thread
                                    if let loadingIndicator = self.view.viewWithTag(999) as? UIActivityIndicatorView {
                                        loadingIndicator.removeFromSuperview()
                                        myVC.modalPresentationStyle = .overFullScreen
                                        self.present(myVC, animated: true)
                                    }
                                }
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
        
        
        if collectionView == self.MostCollection{
            if UserDefaults.standard.string(forKey: "login") == "true"{
                DispatchQueue.main.async {
                    let loadingIndicator = UIActivityIndicatorView(style: .large)
                    loadingIndicator.center = self.view.center
                    loadingIndicator.startAnimating()
                    loadingIndicator.tag = 999 // For easy reference
                    self.view.addSubview(loadingIndicator)
                }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let myVC = storyboard.instantiateViewController(withIdentifier: "PlaySeriesVC") as! PlaySeriesVC
                LoginAPi.getUserInfo { info in
                    if info.planId == 0{
                        DispatchQueue.main.async { // Ensure UI updates are on main thread
                            if let loadingIndicator = self.view.viewWithTag(999) as? UIActivityIndicatorView {
                                loadingIndicator.removeFromSuperview()
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let myVC = storyboard.instantiateViewController(withIdentifier: "SubscribePlaneVC") as! SubscribePlaneVC
                                myVC.modalPresentationStyle = .overFullScreen
                                self.present(myVC, animated: true)
                            }
                        }
                        
                    }else{
                        HomeAPI.GetPaidItemById(i_id: self.MostArray[indexPath.row].id, episode_id: 0) { items, remark, episodes, related, Astatus in
                            if Astatus == "success"{
                                if remark == "episode_video"{
                                    myVC.is_series = true
                                    myVC.EpisodesArray = episodes
                                }else{
                                    myVC.is_series = false
                                }
                                
                                myVC.RecommendedArray = related
                                myVC.Series = items
                                myVC.title = self.MostArray[indexPath.row].title
                                DispatchQueue.main.async { // Ensure UI updates are on main thread
                                    if let loadingIndicator = self.view.viewWithTag(999) as? UIActivityIndicatorView {
                                        loadingIndicator.removeFromSuperview()
                                        myVC.modalPresentationStyle = .overFullScreen
                                        self.present(myVC, animated: true)
                                    }
                                }
                                
                            }else{
                                DispatchQueue.main.async { // Ensure UI updates are on main thread
                                    if let loadingIndicator = self.view.viewWithTag(999) as? UIActivityIndicatorView {
                                        loadingIndicator.removeFromSuperview()
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let myVC = storyboard.instantiateViewController(withIdentifier: "SubscribePlaneVC") as! SubscribePlaneVC
                                        myVC.modalPresentationStyle = .overFullScreen
                                        self.present(myVC, animated: true)
                                    }
                                }
                                
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
        
        
        if collectionView == self.ReviewdCollection{
            if UserDefaults.standard.string(forKey: "login") == "true"{
                DispatchQueue.main.async {
                    let loadingIndicator = UIActivityIndicatorView(style: .large)
                    loadingIndicator.center = self.view.center
                    loadingIndicator.startAnimating()
                    loadingIndicator.tag = 999 // For easy reference
                    self.view.addSubview(loadingIndicator)
                }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let myVC = storyboard.instantiateViewController(withIdentifier: "PlaySeriesVC") as! PlaySeriesVC
                LoginAPi.getUserInfo { info in
                    if info.planId == 0{
                        DispatchQueue.main.async { // Ensure UI updates are on main thread
                            if let loadingIndicator = self.view.viewWithTag(999) as? UIActivityIndicatorView {
                                loadingIndicator.removeFromSuperview()
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let myVC = storyboard.instantiateViewController(withIdentifier: "SubscribePlaneVC") as! SubscribePlaneVC
                                myVC.modalPresentationStyle = .overFullScreen
                                self.present(myVC, animated: true)
                            }
                        }
                        
                    }else{
                        HomeAPI.GetPaidItemById(i_id: self.ReviewdArray[indexPath.row].id, episode_id: 0) { items, remark, episodes, related, Astatus in
                            if Astatus == "success"{
                                if remark == "episode_video"{
                                    myVC.is_series = true
                                    myVC.EpisodesArray = episodes
                                }else{
                                    myVC.is_series = false
                                }
                                
                                myVC.RecommendedArray = related
                                myVC.Series = items
                                myVC.title = self.ReviewdArray[indexPath.row].title
                                DispatchQueue.main.async { // Ensure UI updates are on main thread
                                    if let loadingIndicator = self.view.viewWithTag(999) as? UIActivityIndicatorView {
                                        loadingIndicator.removeFromSuperview()
                                        myVC.modalPresentationStyle = .overFullScreen
                                        self.present(myVC, animated: true)
                                    }
                                }
                                
                            }else{
                                DispatchQueue.main.async { // Ensure UI updates are on main thread
                                    if let loadingIndicator = self.view.viewWithTag(999) as? UIActivityIndicatorView {
                                        loadingIndicator.removeFromSuperview()
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let myVC = storyboard.instantiateViewController(withIdentifier: "SubscribePlaneVC") as! SubscribePlaneVC
                                        myVC.modalPresentationStyle = .overFullScreen
                                        self.present(myVC, animated: true)
                                    }
                                }
                                
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
