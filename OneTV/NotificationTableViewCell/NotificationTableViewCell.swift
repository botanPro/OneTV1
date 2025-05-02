//
//  NotificationTableViewCell.swift
//  Etisal RX
//
//  Created by Botan Amedi on 03/10/2023.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var Imagee: UIImageView!
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
        self.time.text = formatNotificationDate(notif.date)
        self.Imagee.image = UIImage(named: "push-notifications-svgrepo-com")
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}


class NotificationsObject{
    var description = ""
    var date = ""
    var title = ""
    var image : String?
    
    init(description : String , date: String, title: String, image: String) {
        self.description = description
        self.date = date
        self.title = title
        self.image = image
    }
}



func formatNotificationDate(_ dateString: String) -> String {
    // Create date formatter for the input format
    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    guard let date = isoFormatter.date(from: dateString) else {
        return dateString // Return original if parsing fails
    }
    
    let calendar = Calendar.current
    let now = Date()
    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: now)
    
    // If less than 1 hour ago, show just the time
    if let hour = components.hour, hour == 0,
       let minute = components.minute, minute < 60 {
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        return timeFormatter.string(from: date)
    }
    
    // Relative formatting for recent dates
    if let hour = components.hour, hour > 0 {
        if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else if hour < 24 {
            return "\(hour)h ago"
        }
    }
    
    if let day = components.day, day > 0 {
        if day < 7 {
            return "\(day)d ago"
        }
    }
    
    // Default formatting for older dates
    let dateFormatter = DateFormatter()
    if calendar.isDate(date, equalTo: now, toGranularity: .year) {
        // Same year - show month and day
        dateFormatter.dateFormat = "MMM d"
    } else {
        // Different year - show short date
        dateFormatter.dateStyle = .short
    }
    
    return dateFormatter.string(from: date)
}
