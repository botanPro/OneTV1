//
//  WishlistTableViewCell.swift
//  OneTV
//
//  Created by Botan Amedi on 09/03/2025.
//

import UIKit

class WishlistTableViewCell: UITableViewCell {
    @IBOutlet weak var Delete: UIButton!
    
    @IBOutlet weak var Desc: UITextView!
    @IBOutlet weak var Views: UILabel!
    @IBOutlet weak var Rate: UILabel!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Imagee: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
