//
//  Wishlist.swift
//  OneTV
//
//  Created by Botan Amedi on 09/03/2025.
//

import UIKit
import AVFoundation
import AudioToolbox
import SwiftyJSON
class Wishlist: UIViewController {

    @IBOutlet weak var TableView: UITableView!
    var WishArray : [Item] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TableView.register(UINib(nibName: "WishlistTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")

        
        HomeAPI.GetWishlist { items in
            self.WishArray = items
            self.TableView.reloadData()
        }
        
        
        
    }
    
    
    
    @objc func DeleteItem(sender: UIButton){
        let id = sender.tag
        var request = URLRequest(url: URL(string: "https://one-tv.net/api/remove-wishlist?item_id=\(id)")!,timeoutInterval: Double.infinity)
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
                DispatchQueue.main.async {
                    HomeAPI.GetWishlist { items in
                        self.WishArray = items
                        self.TableView.reloadData()
                    }
                }
            }
        }

        task.resume()
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


extension Wishlist : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if WishArray.count == 0{
            return 0
        }
        return WishArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! WishlistTableViewCell
        if self.WishArray.count != 0{
            cell.Name.text =  WishArray[indexPath.row].title
            cell.Desc.text =  WishArray[indexPath.row].description
            let urlString = self.WishArray[indexPath.row].image.portrait
            let url = URL(string: "https://one-tv.net/assets/images/item/portrait/\(urlString)")
            cell.Imagee?.sd_setImage(with: url, completed: nil)
            cell.Rate.text =  "\(WishArray[indexPath.row].ratings)"
            cell.Views.text = formatViews(WishArray[indexPath.row].view)
            cell.Delete.tag = WishArray[indexPath.row].id
            cell.Delete.addTarget(self, action: #selector(DeleteItem), for: .touchUpInside)
        }

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
        if self.WishArray[indexPath.row].isPaid == 1{
            if UserDefaults.standard.string(forKey: "login") == "true"{
                
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
                        HomeAPI.GetPaidItemById(i_id: self.WishArray[indexPath.row].id, episode_id: 0) { items, remark, episodes, related, Astatus in
                            if Astatus == "success"{
                                if remark == "episode_video"{
                                    myVC.is_series = true
                                    myVC.EpisodesArray = episodes
                                }else{
                                    myVC.is_series = false
                                }
                                myVC.RecommendedArray = related
                                myVC.Series = items
                                myVC.title = self.WishArray[indexPath.row].title
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
            HomeAPI.GetFreeItemById(i_id: self.WishArray[indexPath.row].id) { [weak self] items, remark, episodes, related in
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

