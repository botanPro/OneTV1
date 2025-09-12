//
//  SearchMovie.swift
//  OneTV
//
//  Created by Botan Amedi on 11/03/2025.
//

import UIKit
import AVFoundation
import AudioToolbox
import EFInternetIndicator
class SearchMovie: UIViewController ,UITextFieldDelegate,InternetStatusIndicable{
    @IBOutlet weak var SearchText: UITextField!
    var internetConnectionIndicator: EFInternetIndicator.InternetViewIndicator?
    
    @IBOutlet weak var TableView: UITableView!
    var Array : [Item] = []
    
    
    
    var workitem = WorkItem()
    var SearchCount : Int = 1
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if CheckInternet.Connection(){
            if textField.text == "" {
                self.Array.removeAll()
                self.getMoviews()
                SearchCount = 1
            }else{
                if SearchCount == 1{
                    SearchCount = 2
                }else{
                    self.TableView.reloadData()
                }
                workitem.perform(after: 0.3) { [self] in
                    HomeAPI.SearchMovies(text: textField.text!) { items in
                        self.Array = items
                        self.TableView.reloadData()
                    }
                }
            }
        }
    
        return true
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.TableView.register(UINib(nibName: "WishlistTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.SearchText.delegate = self
        getMoviews()
    }

    func getMoviews(){
        if CheckInternet.Connection(){
            HomeAPI.GetMovies { movies, next in
                self.Array = movies
                self.TableView.reloadData()
            }
        }
    }
    
    private func formatViews(_ views: Int) -> String {
        if views >= 1_000_000 {
            return String(format: "%.1fM", Double(views) / 1_000_000)
        } else if views >= 1_000 {
            return String(format: "%.1fK", Double(views) / 1_000)
        }
        return "\(views)"
    }
    private var lastTapTime: TimeInterval = 0
}

extension SearchMovie : UITableViewDelegate , UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Array.count == 0{
            
            return 0
        }
        
        return Array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! WishlistTableViewCell
        cell.Delete.isHidden = true
        cell.Name.text =  Array[indexPath.row].title
        cell.Desc.text =  Array[indexPath.row].description
        let urlString = self.Array[indexPath.row].image.portrait
        let url = URL(string: "https://one-tv.net/assets/images/item/portrait/\(urlString)")
        cell.Imagee?.sd_setImage(with: url, completed: nil)
        cell.Rate.text =  "\(Array[indexPath.row].ratings)"
        cell.Views.text = formatViews(Array[indexPath.row].view)
        cell.Delete.tag = Array[indexPath.row].id
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        
        HomeAPI.GetFreeItemById(i_id: self.Array[indexPath.row].id) { [weak self] items, remark, episodes, related in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let loadingIndicator = self.view.viewWithTag(999) as? UIActivityIndicatorView {
                    loadingIndicator.removeFromSuperview()
                }
                
                myVC.is_series = (remark == "episode_video")
                myVC.EpisodesArray = episodes
                myVC.RecommendedArray = related
                myVC.Series = items
                myVC.title = self.Array[indexPath.row].title
                
                myVC.modalPresentationStyle = .overFullScreen
                self.present(myVC, animated: true)
            }
            
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 240
        }
        
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
            let verticalPadding: CGFloat = 8
            
            let maskLayer = CALayer()
            maskLayer.cornerRadius = 0
            maskLayer.backgroundColor = UIColor.white.cgColor
            maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
            cell.layer.mask = maskLayer
        }
        
    }
    
}
