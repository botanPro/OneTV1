//
//  NotificationTableViewCell.swift
//  Etisal RX
//
//  Created by Botan Amedi on 03/10/2023.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var SubTitle: UILabel!
    @IBOutlet weak var Titile: UILabel!
    @IBOutlet weak var ContainerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }
    
    
    func Updatee(notif : NotificationsObject){
        self.Titile.text = notif.title
        self.SubTitle.text = notif.description
        self.time.text = notif.date
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
