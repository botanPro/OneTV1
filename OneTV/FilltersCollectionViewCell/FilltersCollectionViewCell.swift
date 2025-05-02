//
//  FilltersCollectionViewCell.swift
//  IQ Flowers
//
//  Created by Botan Amedi on 05/12/2024.
//

import UIKit

class FilltersCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Iconee: UIImageView!
    @IBOutlet weak var FilterView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        FilterView.layer.borderWidth = 0.7
        FilterView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        FilterView.layer.cornerRadius = 16
    }

}
