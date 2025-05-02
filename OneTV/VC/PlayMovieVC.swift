//
//  PlayMovieVC.swift
//  OneTV
//
//  Created by Botan Amedi on 08/03/2025.
//

import UIKit
import AVFoundation
import AudioToolbox
class PlayMovieVC: UIViewController {

    
    @IBOutlet weak var WatchView: UIView!
    @IBOutlet weak var TeamView: UIView!
    
    @IBOutlet weak var DescHeight: NSLayoutConstraint!
    @IBOutlet weak var Desc: UITextView!
    @IBOutlet weak var DescriptionB: UIButton!
    @IBOutlet weak var TeamB: UIButton!
    @IBOutlet weak var Awards: UILabel!
    @IBOutlet weak var Budget: UILabel!
    @IBOutlet weak var Revenue: UILabel!
    @IBOutlet weak var Imagee: UIImageView!
    
    @IBOutlet weak var Views: UILabel!
    @IBOutlet weak var Rate: UILabel!
    @IBOutlet weak var Name: UILabel!
    
    @IBOutlet weak var PlayView: UIView!
    
    @IBOutlet weak var Year: UILabel!
    
    @IBOutlet weak var RecommendedCollection: UICollectionView!
    
    
    var RecommendedArray: [String] = []
    var Movie: Item?
    
    
    
    
    
    @IBAction func Watch(_ sender: Any) {
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.WatchView.layer.cornerRadius = 21.5
        self.WatchView.backgroundColor = .clear
        self.WatchView.layer.borderColor = UIColor.white.cgColor
        self.WatchView.layer.borderWidth = 1

        self.TeamB.backgroundColor = .clear
        self.TeamB.layer.borderColor = UIColor.white.cgColor
        self.TeamB.layer.borderWidth = 1
        

        self.DescriptionB.backgroundColor = .clear
        self.DescriptionB.layer.borderColor = UIColor.white.cgColor
        self.DescriptionB.layer.borderWidth = 1
        
        self.DescriptionB.backgroundColor = #colorLiteral(red: 0.02222905494, green: 0.4373427629, blue: 0.4898250103, alpha: 1)
        self.DescriptionB.setTitleColor(.white, for: .normal)
        self.DescriptionB.layer.cornerRadius = 20
        
        self.TeamB.backgroundColor = .white
        self.TeamB.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        self.TeamB.layer.cornerRadius = 20
        
        self.TeamView.isHidden = true
        self.Desc.isHidden = false
        

        RecommendedCollection.register(UINib(nibName: "MovieAndSeriesCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        
        
        if let movie = Movie {
            self.Name.text = movie.title
            self.Rate.text = "\(movie.ratings)"
            self.Views.text = formatViews(movie.view)
            self.Year.text = "Languages | \(movie.team.language) • \(movie.team.genres)"
            if XLanguage.get() == .English{
                self.CostTextView.text = "Director:\(movie.team.director),\n\(movie.team.casts)"
            } else if XLanguage.get() == .Arabic{
                self.CostTextView.text = "المخرج:\(movie.team.director),\n\(movie.team.casts)"
            } else {
                self.CostTextView.text = "بەڕێوەبەر:\(movie.team.director),\n\(movie.team.casts)"
            }
            self.Desc.text = movie.description
            let urlString = movie.image.portrait
            let url = URL(string: "https://one-tv.net/assets/images/item/portrait/\(urlString)")
            self.Imagee.sd_setImage(with: url)
        }
        
        
        
        
        if let text1 = CostTextView.attributedText {
            let mutableAttributedText = NSMutableAttributedString(attributedString: text1)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .justified
            
            mutableAttributedText.addAttribute(.paragraphStyle,
                                             value: paragraphStyle,
                                             range: NSRange(location: 0, length: mutableAttributedText.length))
            
            CostTextView.attributedText = mutableAttributedText
        }
        
        
        
        if let text = Desc.attributedText {
            let mutableAttributedText = NSMutableAttributedString(attributedString: text)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .justified
            
            mutableAttributedText.addAttribute(.paragraphStyle,
                                             value: paragraphStyle,
                                             range: NSRange(location: 0, length: mutableAttributedText.length))
            
            Desc.attributedText = mutableAttributedText
        }
        
    }
    
    
    func formatViews(_ views: Int) -> String {
        if views >= 1_000_000 {
            return String(format: "%.1fM", Double(views) / 1_000_000)
        } else if views >= 1_000 {
            return String(format: "%.1fK", Double(views) / 1_000)
        } else {
            return "\(views)"
        }
    }



    @IBAction func AddToFav(_ sender: Any) {
        
    }
    
    
    @IBAction func DescriptionB(_ sender: Any) {
        self.DescriptionB.backgroundColor = #colorLiteral(red: 0.02222905494, green: 0.4373427629, blue: 0.4898250103, alpha: 1)
        self.DescriptionB.setTitleColor(.white, for: .normal)
        self.DescriptionB.layer.cornerRadius = 20
        
        self.TeamB.backgroundColor = .white
        self.TeamB.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        self.TeamB.layer.cornerRadius = 20
        
        self.TeamView.isHidden = true
        self.Desc.isHidden = false
    }
    
    @IBAction func TeamB(_ sender: Any) {
        self.DescriptionB.backgroundColor = .white
        self.DescriptionB.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        self.DescriptionB.layer.cornerRadius = 20
        
        self.TeamB.backgroundColor = #colorLiteral(red: 0.02222905494, green: 0.4373427629, blue: 0.4898250103, alpha: 1)
        self.TeamB.setTitleColor(.white, for: .normal)
        self.TeamB.layer.cornerRadius = 20
        
        self.TeamView.isHidden = false
        self.Desc.isHidden = true
    }
    
    
    @IBOutlet weak var CostTextView: UITextView!
    @IBOutlet weak var CostHeight: NSLayoutConstraint!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.2) {
                let size = self.Desc.sizeThatFits(CGSize(width: self.Desc.frame.width, height: CGFloat.greatestFiniteMagnitude))
                self.DescHeight.constant = size.height
                
                
                let size1 = self.CostTextView.sizeThatFits(CGSize(width: self.CostTextView.frame.width, height: CGFloat.greatestFiniteMagnitude))
                self.CostHeight.constant = size1.height
            }
        }
    }
    
}



extension PlayMovieVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if collectionView == self.RecommendedCollection{
            if RecommendedArray.count == 0 {
                return 5
            }
            
            return RecommendedArray.count
        }
        

        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
        
        if collectionView == self.RecommendedCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieAndSeriesCollectionCell
            return cell
        }
     
        
        return UICollectionViewCell()

    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
 
        
        if collectionView == self.RecommendedCollection{
            return CGSize(width: 148, height: 215)
        }

        return CGSize()

    }


     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         if collectionView == self.RecommendedCollection{
             return UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
         }
         return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         if collectionView == self.RecommendedCollection{
             return 10
         }
         return 0
     }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        AudioServicesPlaySystemSound(1519)
        

    }
    
}

