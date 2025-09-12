//
//  Movie.swift
//  OneTV
//
//  Created by Botan Amedi on 06/03/2025.
//

import UIKit
import AVFoundation
import AudioToolbox
import MBRadioCheckboxButton
import EFInternetIndicator
import CRRefresh
import SwiftyJSON
class Movie: UIViewController ,InternetStatusIndicable, UIScrollViewDelegate{
    
    
    
    var internetConnectionIndicator: EFInternetIndicator.InternetViewIndicator?

    @IBOutlet weak var MostViewed: CheckboxButton!
    @IBOutlet weak var Newest: CheckboxButton!
    @IBOutlet weak var FilterCategoryCollection: UICollectionView!
    @IBOutlet weak var SecondYear: UITextField!
    @IBOutlet weak var FirstYear: UITextField!
    @IBOutlet weak var FilterView: UIView!
    @IBOutlet weak var DismissFilter: UIButton!
    @IBOutlet weak var FilterViewBottom: NSLayoutConstraint!
    
    
    @IBAction func DismissFilter(_ sender: Any) {
        self.ShowFillter.isEnabled = true
        self.Search.isEnabled = true
        self.Categories.isUserInteractionEnabled = true
        self.MovieCollection.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.2) {
            self.FilterViewBottom.constant = 400
            self.view.layoutIfNeeded()
        }
        
        

    }
    
    
    var nextt = ""
    var isLoading = false
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == MovieCollection else { return }
        let pos = scrollView.contentOffset.y
        let contentHeight = self.MovieCollection.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
            if pos > (contentHeight - 50) - scrollViewHeight {
                if isLoading == false && self.nextt != "" {
                    self.getMoviewsNext()
                    isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.isLoading = false
                    })
                }
        }
    }
    
    
    @IBAction func SeeResult(_ sender: Any) {
        if CheckInternet.Connection() {
            self.Filter(subcategoryId: selectedFilter?.id, isNewest: Newest.isOn ? "true" : "", isMostviewed: MostViewed.isOn ? "true" : "", from: FirstYear.text!, to: SecondYear.text!)
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
    
    
    func Filter(subcategoryId: Int?, isNewest: String?, isMostviewed: String?, from: String?, to: String?) {
            var urlComponents = URLComponents(string: "https://one-tv.net/api/movies-filter")!
            
            var queryItems = urlComponents.queryItems ?? []
            
            if let category_id = subcategoryId , category_id != 0{
                queryItems.append(URLQueryItem(name: "subcategoryId", value: String(category_id)))
            }
            
            if let newst = isNewest, newst != "" {
                queryItems.append(URLQueryItem(name: "isNewest", value: String(newst)))
            }
            
            if let most = isMostviewed, most != "" {
                queryItems.append(URLQueryItem(name: "isMostviewed", value: String(most)))
            }
            
            if let from = from, from != "" {
                queryItems.append(URLQueryItem(name: "from", value: String(from)))
            }
            
            if let to = to, to != "" {
                queryItems.append(URLQueryItem(name: "to", value: String(to)))
            }
            
            urlComponents.queryItems = queryItems

            let url = urlComponents.url

            print(url ?? URL(fileURLWithPath: ""))
            
            self.selectedFilter = nil
            self.selectedCategory = nil
            HomeAPI.GetFiltterMovies(url: url ?? URL(fileURLWithPath: "")) { items in
                self.MovieArray = items
                self.MovieCollection.cr.endHeaderRefresh()
                self.MovieCollection.reloadData()
                self.ShowFillter.isEnabled = true
                self.Search.isEnabled = true
                self.Categories.isUserInteractionEnabled = true
                self.MovieCollection.isUserInteractionEnabled = true
                UIView.animate(withDuration: 0.2) {
                    self.FilterViewBottom.constant = 400
                    self.view.layoutIfNeeded()
                }
            }
    }
    
    @IBOutlet weak var ShowFillter: UIBarButtonItem!
    @IBAction func ShowFillter(_ sender: Any) {
        self.ShowFillter.isEnabled = false
        self.Search.isEnabled = false
        self.Categories.isUserInteractionEnabled = false
        self.MovieCollection.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.2) {
            self.FilterViewBottom.constant = -20
            self.view.layoutIfNeeded()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if XLanguage.get() == .English{
            self.MostViewed.setTitle("Most Viewed", for: .normal)
            self.Newest.setTitle("Newest", for: .normal)
            self.Newest.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 12)!
            self.MostViewed.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 12)!
        }else if XLanguage.get() == .Arabic{
            self.MostViewed.setTitle("الأكثر مشاهدة", for: .normal)
            self.Newest.setTitle("الأحدث", for: .normal)
            self.Newest.titleLabel?.font = UIFont(name: "PeshangDes2", size: 12)!
            self.MostViewed.titleLabel?.font = UIFont(name: "PeshangDes2", size: 12)!
        }else{
            self.MostViewed.setTitle("زۆرترین بینراو", for: .normal)
            self.Newest.setTitle("نوێترین", for: .normal)
            self.Newest.titleLabel?.font = UIFont(name: "PeshangDes2", size: 12)!
            self.MostViewed.titleLabel?.font = UIFont(name: "PeshangDes2", size: 12)!
        }
   
    }
    
    
    @IBOutlet weak var Search: UIBarButtonItem!
    @IBAction func Search(_ sender: Any) {
        
        
    }
    
    
    @IBOutlet weak var MoviewTitile: UIBarButtonItem!
    
    @IBOutlet weak var MovieCollection: UICollectionView!
    var FilterArray : [CategoriesObject] = []
    var CategoriesArray : [CategoriesObject] = []
    var selectedCategory : CategoriesObject?
    var selectedFilter : CategoriesObject?
    var MovieArray: [Item] = []
    @IBOutlet weak var Categories: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.MovieCollection.delegate = self
        self.FilterViewBottom.constant = 400
        
        MoviewTitile.setTitleTextAttributes(
                [
                    NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 25)!,
                    NSAttributedString.Key.foregroundColor: UIColor.white
                ], for: .normal)
        
        FilterCategoryCollection.register(UINib(nibName: "FilltersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        Categories.register(UINib(nibName: "FilltersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        MovieCollection.register(UINib(nibName: "MovieAndSeriesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        
        
        getMoviews()
        getCategories()
        getCategoriesForFilter()
        MovieCollection.cr.addHeadRefresh(animator: FastAnimator(), handler: { [self] in
            getMoviews()
            getCategories()
            getCategoriesForFilter()
        })
        
    }
    
    private var lastTapTime: TimeInterval = 0
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    var numberOfItemsPerRow: CGFloat = 2
    let spacingBetweenCells: CGFloat = 10
    
    
    func getCategories(){
        CategoriesAPi.getCateegories { categories in
            self.CategoriesArray.append(CategoriesObject(id: 0, name: "ALL", status: 1, createdAt: "", updatedAt: ""))
            self.CategoriesArray.append(contentsOf: categories)
            self.Categories.reloadData()
            self.Categories.cr.endHeaderRefresh()
        }
    }
    
    func getCategoriesForFilter(){
        CategoriesAPi.getCateegories { categories in
            self.FilterArray.append(contentsOf: categories)
            self.FilterCategoryCollection.reloadData()
        }
    }
    
    
    func getMoviews(){
        if CheckInternet.Connection(){
            HomeAPI.GetMovies { movies, next in
                self.nextt = next
                self.MovieArray = movies
                self.MovieCollection.cr.endHeaderRefresh()
                self.MovieCollection.reloadData()
            }
        }
    }
    
    func getMoviewsNext(){
        if CheckInternet.Connection(){
            HomeAPI.GetMoviesNext(self.nextt) { movies, next in
                self.nextt = next
                self.MovieArray.append(contentsOf: movies)
                self.MovieCollection.cr.endHeaderRefresh()
                self.MovieCollection.reloadData()
            }
        }
    }
    
    
    
    func getbycategory(_ id: Int){
        var request = URLRequest(url: URL(string: "https://one-tv.net/api/movies-filter?subcategoryId=\(id)")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let jsonData = JSON(data)
            print(jsonData)
            let movies = jsonData["data"]["movies"]
            let free_zone = movies["data"].arrayValue
            
            var FreeZone = [Item]()
            for free in free_zone {
                let id = free["id"].intValue
                let categoryId = free["category_id"].intValue
                let subCategoryId = free["sub_category_id"].intValue
                let slug = free["slug"].stringValue
                let title = free["title"].stringValue
                let previewText = free["preview_text"].stringValue
                let description = free["description"].stringValue
                let itemType = free["item_type"].intValue
                let status = free["status"].intValue
                let single = free["single"].intValue
                let trending = free["trending"].intValue
                let featured = free["featured"].intValue
                let version = free["version"].intValue
                let tags = free["tags"].stringValue
                let ratings = free["ratings"].stringValue
                let view = free["view"].intValue
                let isTrailer = free["is_trailer"].intValue
                let rentPrice = free["rent_price"].stringValue
                let rentalPeriod = free["rental_period"].intValue
                let excludePlan = free["exclude_plan"].intValue
                let createdAt = free["created_at"].stringValue
                let updatedAt = free["updated_at"].stringValue
                let ispaid = free["is_paid"].intValue
                let awards = free["awards"].stringValue
                let revenue = free["revenue"].stringValue
                let budget = free["budget"].stringValue
                let images = ImagePaths(landscape: free["image"]["landscape"].stringValue, portrait: free["image"]["portrait"].stringValue)
                let team = Team(director: free["team"]["director"].stringValue, producer: free["team"]["producer"].stringValue, casts: free["team"]["casts"].stringValue, genres: free["team"]["genres"].stringValue, language: free["team"]["language"].stringValue)
                let category = Category(id: free["category"]["id"].intValue, name: free["category"]["name"].stringValue, status: free["category"]["status"].intValue, createdAt: free["category"]["created_at"].stringValue, updatedAt: free["category"]["updated_at"].stringValue)
                let subCategory = SubCategory(id: free["sub_category"]["id"].intValue, name: free["sub_category"]["name"].stringValue, categoryId: free["sub_category"]["category_id"].intValue, status: free["sub_category"]["status"].intValue, createdAt: free["sub_category"]["created_at"].stringValue, updatedAt: free["sub_category"]["updated_at"].stringValue)

                let freeZone = Item(id: id, categoryId: categoryId, subCategoryId: subCategoryId, slug: slug, title: title, previewText: previewText, description: description, team: team, image: images, itemType: itemType, status: status, single: single, trending: trending, featured: featured, version: version, tags: tags, ratings: ratings, view: view, isTrailer: isTrailer, rentPrice: rentPrice, rentalPeriod: rentalPeriod, excludePlan: excludePlan, createdAt: createdAt, updatedAt: updatedAt, category: category, subCategory: subCategory, isPaid: ispaid, awards: awards, revenue: revenue, budget: budget)
                FreeZone.append(freeZone)
            }
            
            DispatchQueue.main.async {
                self.MovieArray = FreeZone
                self.MovieCollection.reloadData()
            }
        }

        task.resume()
    }
    
}

extension Movie : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.Categories{
            if CategoriesArray.count == 0 {
                return 0
            }
            
            return CategoriesArray.count
        }
        
        if collectionView == self.FilterCategoryCollection{
            if FilterArray.count == 0 {
                return 0
            }
            
            return FilterArray.count
        }
        
        if collectionView == self.MovieCollection{
            if MovieArray.count == 0 {
                return 0
            }
            
            return MovieArray.count
        }
 
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.Categories{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FilltersCollectionViewCell
            cell.Name.text = CategoriesArray[indexPath.row].name
            if selectedCategory?.id == CategoriesArray[indexPath.row].id{
                cell.FilterView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.FilterView.layer.borderWidth = 1
                cell.FilterView.layer.cornerRadius = 16
            }else{
                cell.FilterView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                cell.FilterView.layer.borderWidth = 0.7
                cell.FilterView.layer.cornerRadius = 16
            }
            return cell
        }
        
        
        if collectionView == self.FilterCategoryCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FilltersCollectionViewCell
            cell.Name.text = FilterArray[indexPath.row].name
            if selectedFilter?.id == FilterArray[indexPath.row].id{
                cell.FilterView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.FilterView.layer.borderWidth = 1
                cell.FilterView.layer.cornerRadius = 16
            }else{
                cell.FilterView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                cell.FilterView.layer.borderWidth = 0.7
                cell.FilterView.layer.cornerRadius = 16
            }
            return cell
        }
 
        
        if collectionView == self.MovieCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieAndSeriesCollectionCell
            let urlString = self.MovieArray[indexPath.row].image.portrait
            let url = URL(string: "https://one-tv.net/assets/images/item/portrait/\(urlString)")
            cell.Imagee?.sd_setImage(with: url, completed: nil)
            cell.TypeView.isHidden = true
            return cell
        }
        
    
        
        return UICollectionViewCell()

    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.Categories{
            let text = self.CategoriesArray[indexPath.row].name
            let width = self.estimatedFrame(text: text, font: UIFont.systemFont(ofSize: 14)).width
            return CGSize(width: width + 45, height: 50)
        }
        
        if collectionView == self.FilterCategoryCollection{
            let text = self.FilterArray[indexPath.row].name
            let width = self.estimatedFrame(text: text, font: UIFont.systemFont(ofSize: 14)).width
            return CGSize(width: width + 45, height: 50)
        }
 
        
        if collectionView == self.MovieCollection{
            
            
            let isPad = UIDevice.current.userInterfaceIdiom == .pad
            let isLandscape = UIDevice.current.orientation.isLandscape

            var numberOfItemsPerRow: CGFloat = 2
            var itemHeight: CGFloat = 300

            if isPad {
                numberOfItemsPerRow = 4
                itemHeight = 400
            } else if isLandscape {
                numberOfItemsPerRow = 4
                itemHeight = 330
            }
            
            
            let totalSpacing = (numberOfItemsPerRow * sectionInsets.left) + ((numberOfItemsPerRow - 1) * 10)
            let width = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
            return CGSize(width: width, height: itemHeight)
        }
        

        return CGSize()

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.Categories{
            return UIEdgeInsets(top: 0.0, left: 10.0, bottom: 10.0, right: 10.0)
        }
        
        if collectionView == self.FilterCategoryCollection{
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
        
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
        if collectionView == self.Categories || collectionView == self.FilterCategoryCollection {
            return 0
        }
        
        return 10
    }


    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        AudioServicesPlaySystemSound(1519)
        
        let currentTime = Date().timeIntervalSince1970
        guard currentTime - lastTapTime > 0.8 else { return } // 0.5s delay
        lastTapTime = currentTime
        
        if collectionView == self.MovieCollection{
            
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
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    if let loadingIndicator = self.view.viewWithTag(999) as? UIActivityIndicatorView {
                        loadingIndicator.removeFromSuperview()
                    }
                    
                    myVC.is_series = (remark == "episode_video")
                    myVC.EpisodesArray = episodes
                    myVC.RecommendedArray = related
                    myVC.Series = items
                    myVC.title = self.MovieArray[indexPath.row].title
                    
                    myVC.modalPresentationStyle = .overFullScreen
                    self.present(myVC, animated: true)
                }
            }
            
        }
        
        if collectionView == Categories{
            self.selectedCategory = CategoriesArray[indexPath.row]
            if CategoriesArray[indexPath.row].id == 0{
                self.getMoviews()
            }else{
                getbycategory(self.CategoriesArray[indexPath.row].id)
            }
            self.Categories.reloadData()
        }
        
        
        if collectionView == FilterCategoryCollection{
            self.selectedFilter = FilterArray[indexPath.row]
            self.FilterCategoryCollection.reloadData()
        }
      
    
    }
    
}


