//
//  CatagoryCollectionViewCell.swift
//  shoppingg
//
//  Created by Botan Amedi on 6/23/20.
//  Copyright © 2020 com.saucepanStory. All rights reserved.
//

import UIKit


class HomeCatagoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var Vieww: UIView!
    @IBOutlet weak var CatImagee: UIImageView!
    @IBOutlet weak var CatNamee: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.Style(vieww: self.CatImagee)
    }
    
    func Style(vieww : UIImageView){
        vieww.layer.borderWidth = 0.5
        vieww.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        vieww.layer.cornerRadius = CatImagee.bounds.width / 2
    }
    

    
}
