//
//  SliderCollectionViewCell.swift
//  OneTV
//
//  Created by Botan Amedi on 18/04/2025.
//

import UIKit




protocol WatchTappedDelegate: AnyObject {
    func watch_tapped(_ id : Int,_ is_paid : Int)
    func wish_tapped(_ id : Int)
  }


class SliderCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {

    @IBOutlet weak var Views: UILabel!
    @IBOutlet weak var Rate: UILabel!
    @IBOutlet weak var ImagePNG: UIImageView!
    @IBOutlet weak var AddToWish: UIView!
    @IBOutlet weak var Watch: UIView!
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Imagee: UIImageView!
    weak var delegate : WatchTappedDelegate?
    
    
    var is_paid = 0
    var item_id = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        if XLanguage.get() == .English{
            self.genres.font =  UIFont(name: "ArialRoundedMTBold", size: 15)!
        }else{
            self.genres.font =  UIFont(name: "PeshangDes2", size: 14)!
        }
        
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(WatchTap(recognizer:)))
        tapGesture1.delegate = self
        Watch.isUserInteractionEnabled = true
        Watch.addGestureRecognizer(tapGesture1)
        
        
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(WishTap(recognizer:)))
        tapGesture.delegate = self
        AddToWish.isUserInteractionEnabled = true
        AddToWish.addGestureRecognizer(tapGesture)
        
        
        
        
        
    }
    
    

    
    @objc func WatchTap(recognizer:UITapGestureRecognizer) {
        self.delegate?.watch_tapped(item_id, is_paid)
    }
    
    
    @objc func WishTap(recognizer:UITapGestureRecognizer) {
        self.delegate?.wish_tapped(item_id)
    }

}
