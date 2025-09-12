//
//  NotificationVC.swift
//  OneTV
//
//  Created by Botan Amedi on 26/04/2025.
//

import UIKit
import EmptyDataSet_Swift
class NotificationVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    var NotificationArray : [NotificationsObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.estimatedRowHeight = 96
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        GetNotification()
    }
    
    
    func GetNotification(){
        if CheckInternet.Connection(){
            LoginAPi.GetNotification { nots in
                self.NotificationArray = nots
                self.tableView.reloadData()
            }
        }
    }


}


extension NotificationVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if NotificationArray.count == 0{
            self.tableView.emptyDataSetView { view in
                let originalImage = UIImage(named: "Enable Push Notifications@4x")
         
                let scaledImage = originalImage?.resizedImage(newHeight: 200)
                view.titleLabelString(NSAttributedString.init(string: "", attributes: [NSAttributedString.Key.font : UIFont.init(name: "HelveticaNeue-Bold", size: 18)!, NSAttributedString.Key.foregroundColor : UIColor.black]))
                    .detailLabelString(NSAttributedString.init(string: "", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14,weight: .regular), NSAttributedString.Key.foregroundColor : UIColor.gray]))
                    .image(scaledImage)
            }
            return 0
        }
        return NotificationArray.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NotificationTableViewCell
        if NotificationArray.count != 0{
            cell.Updatee(notif: self.NotificationArray[indexPath.row])
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        let verticalPadding: CGFloat = 3

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 0
        maskLayer.backgroundColor = UIColor.white.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
    
}


