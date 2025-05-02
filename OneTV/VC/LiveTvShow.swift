//
//  LiveTvShow.swift
//  OneTV
//
//  Created by Botan Amedi on 10/04/2025.
//

import UIKit
import AVKit
import AVFoundation

class LiveTvShow: UIViewController {

    
    
    var url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.LoadingView()
        // M3U8 URL
        let streamURL = URL(string: self.url)!

        // Create an AVPlayer
        let player = AVPlayer(url: streamURL)

        // Create AVPlayerViewController and present it
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.view.frame = self.view.bounds

        // Add the playerViewController as a child
        self.addChild(playerViewController)
        self.view.addSubview(playerViewController.view)
        playerViewController.didMove(toParent: self)

        // Auto-play the video
        self.alert.dismiss(animated: true, completion: {
            player.play()
        })
     
    }

    
    
    var alert = UIAlertController()
    var loadingLableMessage = "Loading..."
    
    
    func LoadingView() {
        if XLanguage.get() == .English {
            loadingLableMessage = "Please wait..."
        } else if XLanguage.get() == .Arabic {
            loadingLableMessage = "جاري الإنتضار..."
        } else {
            loadingLableMessage = "تکایە چاوەروانبە..."
        }
        alert = UIAlertController(title: nil, message: self.loadingLableMessage, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
}
