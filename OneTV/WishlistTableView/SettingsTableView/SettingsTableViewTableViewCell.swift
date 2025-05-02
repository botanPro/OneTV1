//
//  SettingsTableViewTableViewCell.swift
//  RealEstates
//
//  Created by botan pro on 4/17/21.
//

import UIKit

class SettingsTableViewTableViewCell: UITableViewCell {

    @IBOutlet weak var Imagee: UIImageView!
    @IBOutlet weak var Vieww: UIView!
    @IBOutlet weak var Name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.masksToBounds = true
        self.Vieww.layer.cornerRadius = 13
        self.Vieww.layer.shadowColor = UIColor.darkGray.cgColor
        self.Vieww.layer.borderWidth = 0.3
        self.Vieww.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.Vieww.layer.shadowOffset = .zero
        self.Vieww.layer.shadowRadius = 12.0
        self.Vieww.layer.shadowOpacity = 0.1
        self.Vieww.layer.masksToBounds = false
    }

}
