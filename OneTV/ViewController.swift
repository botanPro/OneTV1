////
////  ViewController.swift
////  OneTV
////
////  Created by Botan Amedi on 06/03/2025.
////
//
//
//
//import UIKit
//import SwiftyJSON
//import EFInternetIndicator
//import AVFoundation
//import AVKit
//import Drops
//import MediaPlayer
//class ViewController: UIViewController, InternetStatusIndicable, AVAssetResourceLoaderDelegate {
//    
//    // MARK: - Properties
//    var internetConnectionIndicator: InternetViewIndicator?
//    var player: AVPlayer?
//    var playerVC: AVPlayerViewController?
//    var blurView: UIVisualEffectView?
//    var loadingIndicator: UIActivityIndicatorView?
//    var currentPlayer: AVPlayer?
//    var lastTapTime: TimeInterval = 0
//    var isScreenRecording = false
//    
//    var videoQualities: [VideoSizeObject] = []
//    var selectedQualityIndex = 0
//    
//    // MARK: - IBOutlets
//    @IBOutlet weak var Imagee: UIImageView!
//    @IBOutlet weak var WatchView: UIView!
//    @IBOutlet weak var TeamView: UIView!
//    @IBOutlet weak var DescHeight: NSLayoutConstraint!
//    @IBOutlet weak var Desc: UITextView!
//    @IBOutlet weak var DescriptionB: UIButton!
//    @IBOutlet weak var TeamB: UIButton!
//    @IBOutlet weak var Awards: UILabel!
//    @IBOutlet weak var Budget: UILabel!
//    @IBOutlet weak var Revenue: UILabel!
//    @IBOutlet weak var Views: UILabel!
//    @IBOutlet weak var Rate: UILabel!
//    @IBOutlet weak var Name: UILabel!
//    @IBOutlet weak var PlayView: UIView!
//    @IBOutlet weak var EpisodesColleciton: UICollectionView!
//    @IBOutlet weak var RecommendedCollection: UICollectionView!
//    @IBOutlet weak var CostTextView: UITextView!
//    @IBOutlet weak var year: UILabel!
//    @IBOutlet weak var Director: UILabel!
//    @IBOutlet weak var EpisodeStack: UIStackView!
//    @IBOutlet weak var Watchlable: UILabel!
//    @IBOutlet weak var CostHeight: NSLayoutConstraint!
//    
//    // Data properties
//    var Series: Item?
//    var is_trailer = false
//    var is_series = false
//    var itemID = 0
//    var episodeID = 0
//    
//    var RecommendedArray: [Item] = []
//    var EpisodesArray: [Episode] = []
//    
//    
//    
//    
//    @IBOutlet weak var scrollView: UIScrollView!
//    
//    
//    
//    @IBAction func Dismiss(_ sender: Any) {
//        self.dismiss(animated: true)
//    }
//    
//    
//    
//    // MARK: - View Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        setupObservers()
//        loadInitialData()
//        checkScreenRecordingStatus()
//
//        
//        // Configure scroll view
//        scrollView.delegate = self
//        scrollView.alwaysBounceVertical = true
//        scrollView.contentInsetAdjustmentBehavior = .never
//        
//    }
//    
//    // Present the view controller
//    static func present(from presentingVC: UIViewController) {
//        let vc = PlaySeriesVC()
//        vc.modalPresentationStyle = .overFullScreen
//        presentingVC.present(vc, animated: true)
//    }
//
//
//
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        adjustTextViewsHeight()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//            super.viewWillAppear(animated)
//            checkScreenRecordingStatus()
//        }
//    
//    deinit {
//        removeObservers()
//    }
//    
//    private func setupScreenRecordingObserver() {
//           NotificationCenter.default.addObserver(
//               self,
//               selector: #selector(screenCaptureDidChange),
//               name: UIScreen.capturedDidChangeNotification,
//               object: nil
//           )
//       }
//       
//       @objc private func screenCaptureDidChange() {
//           checkScreenRecordingStatus()
//       }
//    
//    
//    private func checkScreenRecordingStatus() {
//         DispatchQueue.main.async {
//             self.isScreenRecording = UIScreen.main.isCaptured
//             
//             if self.isScreenRecording {
//                 self.blockVideoPlayback()
//                 self.showScreenRecordingAlert()
//             } else {
//                 self.removeBlurEffect()
//             }
//         }
//     }
//    
//    private func blockVideoPlayback() {
//         // Pause current playback
//         player?.pause()
//         
//         // Add blur overlay
//         addBlurEffect()
//         
//         // Disable player controls
//         playerVC?.showsPlaybackControls = false
//        
//     }
//    
//    private func addBlurEffect() {
//        guard playerVC?.contentOverlayView != nil else { return }
//        
//        let blurEffect = UIBlurEffect(style: .dark)
//        blurView = UIVisualEffectView(effect: blurEffect)
//        blurView?.frame = playerVC?.view.bounds ?? view.bounds
//        playerVC?.contentOverlayView?.addSubview(blurView!)
//        
//        // Add warning message
//        let label = UILabel()
//        if XLanguage.get() == .English{
//        label.text = "Screen recording detected\nTurn off to continue watching"
//        }else if XLanguage.get() == .Arabic{
//            label.text = "تم اكتشاف تسجيل الشاشة\nأوقف التشغيل لمواصلة المشاهدة"
//        }else{
//            label.text = "تۆمارکردنی شاشە دۆزراوەتەوە\nبکوژێنەرەوە بۆ بەردەوامبوون لە سەیرکردن"
//        }
//        label.numberOfLines = 0
//        label.textAlignment = .center
//        label.textColor = .white
//        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
//        blurView?.contentView.addSubview(label)
//        
//        label.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            label.centerXAnchor.constraint(equalTo: blurView!.contentView.centerXAnchor),
//            label.centerYAnchor.constraint(equalTo: blurView!.contentView.centerYAnchor),
//            label.leadingAnchor.constraint(equalTo: blurView!.contentView.leadingAnchor, constant: 20),
//            label.trailingAnchor.constraint(equalTo: blurView!.contentView.trailingAnchor, constant: -20)
//        ])
//    }
//    
//    private func removeBlurEffect() {
//          blurView?.removeFromSuperview()
//          blurView = nil
//          playerVC?.showsPlaybackControls = true
//      }
//    
//    
//
//    
//    // MARK: - Setup Methods
//    private func setupUI() {
//        WatchView.layer.cornerRadius = 21.5
//        WatchView.backgroundColor = .clear
//        WatchView.layer.borderColor = UIColor.white.cgColor
//        WatchView.layer.borderWidth = 1
//        
//        TeamB.backgroundColor = .clear
//        TeamB.layer.borderColor = UIColor.white.cgColor
//        TeamB.layer.borderWidth = 1
//        TeamB.layer.cornerRadius = 20
//        
//        DescriptionB.backgroundColor = .clear
//        DescriptionB.layer.borderColor = UIColor.white.cgColor
//        DescriptionB.layer.borderWidth = 1
//        DescriptionB.layer.cornerRadius = 20
//        
//        DescriptionB.backgroundColor = #colorLiteral(red: 0.02222905494, green: 0.4373427629, blue: 0.4898250103, alpha: 1)
//        DescriptionB.setTitleColor(.white, for: .normal)
//        DescriptionB.layer.cornerRadius = 20
//        
//        TeamB.backgroundColor = .white
//        TeamB.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
//        TeamB.layer.cornerRadius = 20
//        
//        TeamView.isHidden = true
//        Desc.isHidden = false
//        
//        registerCollectionViewCells()
//    }
//    
//    private func configurePlayer(with url: URL) {
//        // 1. Create player item
//        let asset = AVURLAsset(url: url)
//        let playerItem = AVPlayerItem(asset: asset)
//        
//        // 2. Create player
//        player = AVPlayer(playerItem: playerItem)
//        currentPlayer = player
//        
//        // 3. Configure player view controller
//        playerVC = AVPlayerViewController()
//        playerVC?.player = player
//        playerVC?.showsPlaybackControls = true
//        playerVC?.videoGravity = .resizeAspect
//        
//        playerVC?.allowsPictureInPicturePlayback = false
//        playerVC?.updatesNowPlayingInfoCenter = false
//        
//        // 4. Present properly
//        playerVC?.modalPresentationStyle = .fullScreen
//        playerVC?.view.frame = view.bounds
//        
//        playerVC?.requiresLinearPlayback = true  // Prevents scrubbing
//        playerVC?.setValue(false, forKey: "requiresLinearPlayback") // If neede
//        
//        // 5. Add security
//        secureVideoView()
//        
//        // 6. Present and play
//        if let vc = playerVC {
//            present(vc, animated: true) {
//                self.player?.play()
//            }
//        }
//        
//        // 7. Add observers
//        addPlayerObservers()
//    }
//    
//    private func setupObservers() {
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(screenCaptureDidChange),
//            name: UIScreen.capturedDidChangeNotification,
//            object: nil
//        )
//    }
//    
//    private func addPlayerObservers() {
//        player?.addObserver(self,
//                          forKeyPath: "status",
//                          options: [.new],
//                          context: nil)
//    }
//    
//    private func removeObservers() {
//        NotificationCenter.default.removeObserver(self)
//        currentPlayer?.removeObserver(self, forKeyPath: "status")
//    }
//    
//    private func registerCollectionViewCells() {
//        RecommendedCollection.register(
//            UINib(nibName: "MovieAndSeriesCollectionCell", bundle: nil),
//            forCellWithReuseIdentifier: "cell"
//        )
//        EpisodesColleciton.register(
//            UINib(nibName: "LiveTVCollectionCell", bundle: nil),
//            forCellWithReuseIdentifier: "cell"
//        )
//    }
//    
//    func formatBudget(_ budget: String) -> String {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        formatter.maximumFractionDigits = 0
//        
//        if let budgetValue = Double(budget) {
//            let formattedBudget = formatter.string(from: NSNumber(value: budgetValue))
//            return formattedBudget ?? budget
//        }
//        
//        return budget
//    }
//
//
//    
//    private func loadInitialData() {
//        EpisodeStack.isHidden = !is_series
//        if XLanguage.get() == .English{
//            Watchlable.font = UIFont(name: "ArialRoundedMTBold", size: 14)!
//            Watchlable.text = is_series ? "Watch Episode 1" : "Watch Movie"
//        }else if XLanguage.get() == .Arabic{
//            Watchlable.font = UIFont(name: "PeshangDes2", size: 14)!
//            Watchlable.text = is_series ? "شاهد الحلقة 1" : "شاهد الفيلم"
//        }else{
//            Watchlable.font = UIFont(name: "PeshangDes2", size: 14)!
//            Watchlable.text = is_series ? "ئەڵقەی یەکەم ببینە" : "سەیری فیلم بکە"
//        }
//            
//       
//        
//        if !EpisodesArray.isEmpty {
//            episodeID = EpisodesArray[0].id
//            if XLanguage.get() == .English{
//                Watchlable.font = UIFont(name: "ArialRoundedMTBold", size: 14)!
//                Watchlable.text = "Watch Episode 1"
//            }else if XLanguage.get() == .Arabic{
//                Watchlable.font = UIFont(name: "PeshangDes2", size: 14)!
//                Watchlable.text = "شاهد الحلقة 1"
//            }else{
//                Watchlable.font = UIFont(name: "PeshangDes2", size: 14)!
//                Watchlable.text = "ئەڵقەی یەکەم ببینە"
//            }
//        }
//        
//        //Watchlable.text = is_trailer ? "Watch Trailer" : Watchlable.text
//        
//        guard let series = Series else { return }
//        
//        itemID = series.id
//        Name.text = series.title
//        self.Awards.text = series.awards
//        self.Budget.text = formatBudget(series.budget)
//        self.Revenue.text = formatBudget(series.revenue)
//        Rate.text = "\(series.ratings)"
//        Views.text = formatViews(series.view)
//        year.text = "Languages | \(series.team.language) • \(series.team.genres)"
//        CostTextView.text = series.team.casts
//        if XLanguage.get() == .English{
//            self.Director.text = "Director:\(series.team.director),\n\(series.team.casts)"
//        } else if XLanguage.get() == .Arabic{
//            self.Director.text = "المخرج:\(series.team.director),\n\(series.team.casts)"
//        } else {
//            self.Director.text = "بەڕێوەبەر:\(series.team.director),\n\(series.team.casts)"
//        }
//        Desc.text = series.description
//        
//        let urlString = series.image.portrait
//        let url = URL(string: "https://one-tv.net/assets/images/item/portrait/\(urlString)")
//        Imagee.sd_setImage(with: url)
//        
//        EpisodesColleciton.reloadData()
//        RecommendedCollection.reloadData()
//        
//        justifyTextViews()
//    }
//    
//    private func adjustTextViewsHeight() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            UIView.animate(withDuration: 0.2) {
//                let descSize = self.Desc.sizeThatFits(
//                    CGSize(width: self.Desc.frame.width,
//                           height: CGFloat.greatestFiniteMagnitude))
//                self.DescHeight.constant = descSize.height
//                
//                let costSize = self.CostTextView.sizeThatFits(
//                    CGSize(width: self.CostTextView.frame.width,
//                           height: CGFloat.greatestFiniteMagnitude))
//                self.CostHeight.constant = costSize.height
//            }
//        }
//    }
//    
//    private func justifyTextViews() {
//        [CostTextView, Desc].forEach { textView in
//            if let text = textView?.attributedText {
//                let mutableAttributedText = NSMutableAttributedString(attributedString: text)
//                let paragraphStyle = NSMutableParagraphStyle()
//                paragraphStyle.alignment = .justified
//                
//                mutableAttributedText.addAttribute(
//                    .paragraphStyle,
//                    value: paragraphStyle,
//                    range: NSRange(location: 0, length: mutableAttributedText.length)
//                )
//                
//                textView?.attributedText = mutableAttributedText
//            }
//        }
//    }
//    
//    // MARK: - Video Playback
//    @IBAction func Watch(_ sender: Any) {
//        let currentTime = Date().timeIntervalSince1970
//        guard currentTime - lastTapTime > 0.8 else { return }
//        lastTapTime = currentTime
//        
//        guard CheckInternet.Connection() else {
//            showNoInternetAlert()
//            return
//        }
//        
//        checkScreenRecordingStatus()
//        
//        guard !isScreenRecording else {
//            showScreenRecordingAlert()
//            return
//        }
//        
//        showLoadingIndicator()
//        
//        print(self.itemID)
//        print(episodeID)
//        
//        
//        HomeAPI.PlayVideo(item_id: itemID, episode_id: episodeID) { [weak self] videos, remark, status in
//            guard let self = self else { return }
//            
//            DispatchQueue.main.async {
//                self.loadingIndicator?.removeFromSuperview()
//                self.checkScreenRecordingStatus()
//                guard !self.isScreenRecording else {
//                    self.showScreenRecordingAlert()
//                    return
//                }
//                
//                guard status == "success" else {
//                    self.showErrorAlert(message: "Failed to load video")
//                    return
//                }
//                
//                self.videoQualities = videos.sorted { $0.size > $1.size }
//                
//                if self.videoQualities.count > 1 {
//                    self.showQualitySelection()
//                } else if let firstVideo = self.videoQualities.first, let url = URL(string: firstVideo.url) {
//                    self.playVideo(url: url)
//                } else {
//                    self.showErrorAlert(message: "No video available")
//                }
//            }
//            
//            
//        }
//    }
//    
//    private func showQualitySelection() {
//        var title = ""
//        var cancel = ""
//        if XLanguage.get() == .English{
//            title = "Select Video Quality"
//        cancel = "Cancel"
//        }else if XLanguage.get() == .Arabic{
//            title = "اختر جودة الفيديو"
//            cancel = "إلغاء"
//        }else{
//            title = "کوالێتی ڤیدیۆ هەڵبژێرە"
//            cancel = "ڕەتکردنەوە"
//        }
//        let alert = UIAlertController(
//            title: title,
//            message: nil,
//            preferredStyle: .actionSheet
//        )
//        
//        for (index, quality) in videoQualities.enumerated() {
//            alert.addAction(UIAlertAction(
//                title: "\(quality.size)p",
//                style: .default,
//                handler: { [weak self] _ in
//                    self?.selectedQualityIndex = index
//                    if let url = URL(string: quality.url) {
//                        self?.playVideo(url: url)
//                    }
//                }
//            ))
//        }
//        
//        alert.addAction(UIAlertAction(title: cancel, style: .cancel))
//        
//        // For iPad support
//        if let popoverController = alert.popoverPresentationController {
//            popoverController.sourceView = self.view
//            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
//            popoverController.permittedArrowDirections = []
//        }
//        
//        present(alert, animated: true)
//    }
//    
//    private func setupPlayer(with url: URL) {
//        let asset = AVURLAsset(url: url)
//        asset.resourceLoader.setDelegate(self, queue: .main)
//        
//        let playerItem = AVPlayerItem(asset: asset)
//        player = AVPlayer(playerItem: playerItem)
//        currentPlayer = player
//        
//        disableExternalPlayback()
//    }
//
//    private func playVideo(url: URL) {
//        
//        guard !isScreenRecording else {
//                   showScreenRecordingAlert()
//                   return
//               }
//        
//        
//        // Clean up previous player
//        player?.pause()
//        playerVC?.player = nil
//        playerVC?.dismiss(animated: false)
//        
//        // Setup new player with proper configuration
//        setupPlayer(with: url)
//        
//        // Configure and present player view controller
//        setupPlayerViewController()
//        presentPlayer()
//        
//        // Add observers
//        addPlayerObservers()
//    }
//    
//    private func disableExternalPlayback() {
//           // Disable AirPlay
//           player?.allowsExternalPlayback = false
//           
//           // For older iOS versions
//           if #available(iOS 11.0, *) {
//               player?.usesExternalPlaybackWhileExternalScreenIsActive = false
//           }
//           
//           // Disable casting options
//           let airplayButton = MPVolumeView(frame: .zero)
//           airplayButton.showsVolumeSlider = false
//           airplayButton.showsRouteButton = false
//           view.addSubview(airplayButton)
//       }
//    
//    
//    private func presentPlayer() {
//        guard let playerVC = playerVC else { return }
//        
//        // Present full screen
//        playerVC.modalPresentationStyle = .fullScreen
//        
//        // For proper layout
//        playerVC.view.frame = view.bounds
//        playerVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        
//        present(playerVC, animated: true) { [weak self] in
//            self?.player?.play()
//            //self?.addEpisodesButton()
//            // Make sure episode peeks after a short delay (allows player UI to settle)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                if let episodeContainerView = self?.episodeContainerView,
//                   let constraint = self?.episodeContainerBottomConstraint {
//                    UIView.animate(withDuration: 0.5) {
//                        constraint.constant = (self?.episodeContainerHeight ?? 180) - 40 // Show peek
//                        episodeContainerView.superview?.layoutIfNeeded()
//                    }
//                }
//            }
//        }
//    }
//    
//    
//    private func addEpisodesButton() {
//        guard let overlayView = playerVC?.contentOverlayView else { return }
//        
//        let episodesButton = UIButton(type: .system)
//        var buttonTitle = "Episodes"
//        if XLanguage.get() == .Arabic {
//            buttonTitle = "الحلقات"
//        } else if XLanguage.get() == .Kurdish {
//            buttonTitle = "ئەڵقەکان"
//        }
//        episodesButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
//        episodesButton.setTitle(buttonTitle, for: .normal)
//        episodesButton.tintColor = .white
//        episodesButton.backgroundColor = UIColor(red: 0.02, green: 0.44, blue: 0.49, alpha: 0.8)
//        episodesButton.layer.cornerRadius = 10
//        episodesButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
//        episodesButton.addTarget(self, action: #selector(episodesButtonTapped), for: .touchUpInside)
//        
//        episodesButton.translatesAutoresizingMaskIntoConstraints = false
//        overlayView.addSubview(episodesButton)
//        
//        NSLayoutConstraint.activate([
//            episodesButton.bottomAnchor.constraint(equalTo: overlayView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
//            episodesButton.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -20)
//        ])
//    }
//
//    @objc private func episodesButtonTapped() {
//        toggleEpisodePanel()
//    }
//    
//    private var episodeContainerView: UIView?
//    private var episodeCollectionView: UICollectionView?
//    private var episodeContainerHeight: CGFloat = 300
//    private var episodeContainerBottomConstraint: NSLayoutConstraint?
//    private var lastPanPosition: CGFloat = 0
//    private var isEpisodeViewVisible = false
//
//    private func setupPlayerViewController() {
//        playerVC = AVPlayerViewController()
//        playerVC?.player = player
//        playerVC?.showsPlaybackControls = true // Make sure controls are enabled
//        playerVC?.videoGravity = .resizeAspect // For proper aspect ratio
//        playerVC?.allowsPictureInPicturePlayback = false
//        
//        if #available(iOS 14.0, *) {
//            playerVC?.canStartPictureInPictureAutomaticallyFromInline = false
//        }
//        
//        // Check if series has episodes, only setup collection view if needed
//        if is_series && !EpisodesArray.isEmpty {
//            setupEpisodeCollectionInPlayer()
//        }
//    }
//    
//    private func setupEpisodeCollectionInPlayer() {
//        guard let overlayView = playerVC?.contentOverlayView else { return }
//        
//        // Create container view for episodes
//        episodeContainerView = UIView()
//        guard let episodeContainerView = episodeContainerView else { return }
//        episodeContainerView.backgroundColor = UIColor(white: 0, alpha: 0.7) // Semi-transparent background
//        episodeContainerView.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Add drag handle
//        let handleView = UIView()
//        handleView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
//        handleView.translatesAutoresizingMaskIntoConstraints = false
//        handleView.layer.cornerRadius = 2.5
//        episodeContainerView.addSubview(handleView)
//        
//        // Add episode title label
//        let titleLabel = UILabel()
//        var titleText = "Episodes"
//        if XLanguage.get() == .Arabic {
//            titleText = "الحلقات"
//        } else if XLanguage.get() == .Kurdish {
//            titleText = "ئەڵقەکان"
//        }
//        titleLabel.text = titleText
//        titleLabel.textColor = .white
//        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        episodeContainerView.addSubview(titleLabel)
//        
//        // Create collection view flow layout
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.itemSize = CGSize(width: 120, height: 180)
//        layout.minimumInteritemSpacing = 10
//        layout.minimumLineSpacing = 10
//        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        
//        // Create collection view
//        episodeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        guard let episodeCollectionView = episodeCollectionView else { return }
//        episodeCollectionView.backgroundColor = .clear
//        episodeCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        episodeCollectionView.showsHorizontalScrollIndicator = false
//        episodeCollectionView.register(EpisodePlayerCell.self, forCellWithReuseIdentifier: "EpisodePlayerCell")
//        
//        // IMPORTANT: Make sure these delegate connections are set
//        episodeCollectionView.delegate = self
//        episodeCollectionView.dataSource = self
//        
//        // Add better visual feedback for selection
//        episodeCollectionView.allowsSelection = true
//        
//        episodeContainerView.addSubview(episodeCollectionView)
//        
//        // Add pan gesture recognizer for sliding the view
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
//        episodeContainerView.addGestureRecognizer(panGesture)
//        
//        // Add tap gesture to handle view
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
//        handleView.addGestureRecognizer(tapGesture)
//        handleView.isUserInteractionEnabled = true // Ensure handle is interactive
//        
//        // Add container to overlay view
//        overlayView.addSubview(episodeContainerView)
//        
//        // Set constraints
//        NSLayoutConstraint.activate([
//            // Handle view constraints
//            handleView.topAnchor.constraint(equalTo: episodeContainerView.topAnchor, constant: 8),
//            handleView.centerXAnchor.constraint(equalTo: episodeContainerView.centerXAnchor),
//            handleView.widthAnchor.constraint(equalToConstant: 40),
//            handleView.heightAnchor.constraint(equalToConstant: 5),
//            
//            // Title label constraints
//            titleLabel.topAnchor.constraint(equalTo: handleView.bottomAnchor, constant: 8),
//            titleLabel.leadingAnchor.constraint(equalTo: episodeContainerView.leadingAnchor, constant: 16),
//            
//            // Collection view constraints
//            episodeCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
//            episodeCollectionView.leadingAnchor.constraint(equalTo: episodeContainerView.leadingAnchor),
//            episodeCollectionView.trailingAnchor.constraint(equalTo: episodeContainerView.trailingAnchor),
//            episodeCollectionView.bottomAnchor.constraint(equalTo: episodeContainerView.bottomAnchor),
//            
//            // Container constraints
//            episodeContainerView.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor),
//            episodeContainerView.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor),
//            episodeContainerView.heightAnchor.constraint(equalToConstant: episodeContainerHeight),
//        ])
//        
//        // Add bottom constraint separately so we can animate it
//        let peekHeight: CGFloat = 40 // Show 40 points of the panel initially
//        episodeContainerBottomConstraint = episodeContainerView.bottomAnchor.constraint(
//            equalTo: overlayView.bottomAnchor,
//            constant: episodeContainerHeight - peekHeight) // Show a peek initially
//        episodeContainerBottomConstraint?.isActive = true
//        isEpisodeViewVisible = false
//    }
//    
//    private func addPulsingUpArrow(to containerView: UIView) {
////        let arrowSize: CGFloat = 20
////        let arrowView = UIImageView(frame: CGRect(x: 0, y: 0, width: arrowSize, height: arrowSize))
////
////        // Create an upward arrow
////        UIGraphicsBeginImageContextWithOptions(CGSize(width: arrowSize, height: arrowSize), false, 0)
////        let context = UIGraphicsGetCurrentContext()!
////        context.setFillColor(UIColor.white.cgColor)
////        context.move(to: CGPoint(x: 0, y: arrowSize))
////        context.addLine(to: CGPoint(x: arrowSize, y: arrowSize))
////        context.addLine(to: CGPoint(x: arrowSize/2, y: 0))
////        context.closePath()
////        context.fillPath()
////        let arrowImage = UIGraphicsGetImageFromCurrentImageContext()
////        UIGraphicsEndImageContext()
////
////        arrowView.image = arrowImage
////        arrowView.translatesAutoresizingMaskIntoConstraints = false
////        containerView.addSubview(arrowView)
////
////        NSLayoutConstraint.activate([
////            arrowView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
////            arrowView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12)
////        ])
////
////        // Add pulsating animation
////        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse], animations: {
////            arrowView.transform = CGAffineTransform(translationX: 0, y: -5)
////        }, completion: nil)
//    }
//    
//    
//    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
//        guard let containerView = episodeContainerView,
//              let constraint = episodeContainerBottomConstraint else { return }
//        
//        let translation = gesture.translation(in: containerView.superview)
//        
//        switch gesture.state {
//        case .began:
//            lastPanPosition = constraint.constant
//            
//        case .changed:
//            // Calculate new position, keeping within bounds
//            var newPosition = lastPanPosition - translation.y
//            newPosition = min(newPosition, episodeContainerHeight) // Don't slide beyond hidden position
//            newPosition = max(newPosition, 0) // Don't slide beyond fully visible position
//            
//            // Update constraint with animation to make it smoother
//            UIView.animate(withDuration: 0.1, animations: {
//                constraint.constant = newPosition
//                containerView.superview?.layoutIfNeeded()
//            })
//            
//        case .ended, .cancelled:
//            // Determine if view should snap to visible or hidden position
//            let velocity = gesture.velocity(in: containerView.superview).y
//            let finalPosition: CGFloat
//            
//            // If swipe velocity is significant or if panel is more than halfway, complete the action
//            if (velocity < -300) || (constraint.constant < episodeContainerHeight/2 && velocity > -200) {
//                // Fast upward swipe or panel is more than half visible
//                finalPosition = 0
//                isEpisodeViewVisible = true
//            } else {
//                // Keep a peek visible (don't fully hide)
//                finalPosition = episodeContainerHeight - 40 // Keep 40pt visible
//                isEpisodeViewVisible = false
//            }
//            
//            // Animate to final position with spring effect for natural feel
//            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
//                constraint.constant = finalPosition
//                containerView.superview?.layoutIfNeeded()
//            }, completion: nil)
//            
//        default:
//            break
//        }
//    }
//
//    
//    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
//        print("Handle tap gesture received")
//        toggleEpisodePanel()
//    }
//
//    // 5. Improve toggle function for the panel
//    private func toggleEpisodePanel() {
//        guard let containerView = episodeContainerView,
//              let constraint = episodeContainerBottomConstraint else { return }
//        
//        isEpisodeViewVisible = !isEpisodeViewVisible
//        let finalPosition = isEpisodeViewVisible ? 0 : episodeContainerHeight - 40 // Keep 40pt visible when collapsed
//        
//        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
//            constraint.constant = finalPosition
//            containerView.superview?.layoutIfNeeded()
//        }, completion: nil)
//    }
//    
//    private func addQualityButtonToPlayer() {
//        let qualityButton = UIButton(type: .system)
//        let currentQuality = videoQualities[selectedQualityIndex].size
//        qualityButton.setTitle("\(currentQuality)p ▼", for: .normal)
//        qualityButton.tintColor = .white
//        qualityButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        qualityButton.layer.cornerRadius = 4
//        qualityButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
//        qualityButton.addTarget(self, action: #selector(qualityButtonTapped), for: .touchUpInside)
//        
//        qualityButton.translatesAutoresizingMaskIntoConstraints = false
//        playerVC?.contentOverlayView?.addSubview(qualityButton)
//        
//        NSLayoutConstraint.activate([
//            qualityButton.topAnchor.constraint(equalTo: playerVC!.contentOverlayView!.topAnchor, constant: 16),
//            qualityButton.trailingAnchor.constraint(equalTo: playerVC!.contentOverlayView!.trailingAnchor, constant: -16)
//        ])
//    }
//    
//    @objc private func qualityButtonTapped() {
//        player?.pause()
//        playerVC?.dismiss(animated: true) {
//            self.showQualitySelection()
//        }
//    }
//    
//    // MARK: - Security Measures
//    private func secureVideoView() {
//        DispatchQueue.main.async {
//            let field = UITextField()
//            field.isSecureTextEntry = true
//            field.translatesAutoresizingMaskIntoConstraints = false
//            self.playerVC?.view.addSubview(field)
//            
//            NSLayoutConstraint.activate([
//                field.centerYAnchor.constraint(equalTo: self.playerVC!.view.centerYAnchor),
//                field.centerXAnchor.constraint(equalTo: self.playerVC!.view.centerXAnchor)
//            ])
//            
//            self.playerVC?.view.layer.superlayer?.addSublayer(field.layer)
//            field.layer.sublayers?.first?.addSublayer(self.playerVC!.view.layer)
//        }
//    }
//    
//    private func checkForScreenRecording() {
//        if UIScreen.main.isCaptured {
//            addBlurEffect()
//            showScreenRecordingAlert()
//        }
//    }
//
//    
//
//    
//
//    
//    // MARK: - Helper Methods
//    private func showLoadingIndicator() {
//        loadingIndicator = UIActivityIndicatorView(style: .large)
//        loadingIndicator?.center = view.center
//        loadingIndicator?.startAnimating()
//        view.addSubview(loadingIndicator!)
//    }
//    
//    private func formatViews(_ views: Int) -> String {
//        if views >= 1_000_000 {
//            return String(format: "%.1fM", Double(views) / 1_000_000)
//        } else if views >= 1_000 {
//            return String(format: "%.1fK", Double(views) / 1_000)
//        }
//        return "\(views)"
//    }
//    
//    private func showNoInternetAlert() {
//        let message: String
//        switch XLanguage.get() {
//        case .English: message = "No internet connection."
//        case .Arabic: message = "لا يوجد اتصال بالإنترنت."
//        default: message = "هێلی ئینترنێت نیە"
//        }
//        
//        startMonitoringInternet(
//            backgroundColor: UIColor.red,
//            style: .cardView,
//            textColor: UIColor.white,
//            message: message,
//            remoteHostName: "magic.com"
//        )
//    }
//    
//    private func showErrorAlert(message: String) {
//        let alert = UIAlertController(
//            title: "Error",
//            message: message,
//            preferredStyle: .alert
//        )
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
//    }
//    
//    private func showScreenRecordingAlert() {
//        var title = ""
//        var message = ""
//        if XLanguage.get() == .English{
//            title = "Screen Recording Detected"
//            message = "Turn off screen recording to continue watching."
//        }else if XLanguage.get() == .Arabic{
//            title = "تم اكتشاف تسجيل الشاشة"
//            message = "قم بإيقاف تسجيل الشاشة لمتابعة المشاهدة."
//        }else{
//            title = "تۆمارکردنی شاشە دۆزراوەتەوە"
//            message = "بکوژێنەرەوە بۆ بەردەوامبوون لە سەیرکردن."
//        }
//        let drop = Drop(
//            title: title,
//            subtitle: message,
//            icon: UIImage(named: "attention"),
//            action: .init { Drops.hideCurrent() },
//            position: .top,
//            duration: 3.0,
//            accessibility: "Alert: Screen Recording Detected"
//        )
//        Drops.show(drop)
//    }
//    
//    
//    
//    func showDrop(title: String, message: String) {
//        let drop = Drop(
//            title: title,
//            subtitle: message,
//            icon: UIImage(named: "attention"),
//            action: .init {
//                print("Drop tapped")
//                Drops.hideCurrent()
//            },
//            position: .top,
//            duration: 3.0,
//            accessibility: "Alert: Title, Subtitle"
//        )
//        Drops.show(drop)
//    }
//    
//    
//    // MARK: - IBActions
//    @IBAction func AddToFav(_ sender: Any) {
//        let id = self.itemID
//        print(id)
//        if UserDefaults.standard.string(forKey: "login") != "true" {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//            loginVC.modalPresentationStyle = .fullScreen
//            self.present(loginVC, animated: true)
//        }else{
//            let currentTime = Date().timeIntervalSince1970
//            guard currentTime - lastTapTime > 0.8 else { return }
//            lastTapTime = currentTime
//            
//            if CheckInternet.Connection(){
//                if UserDefaults.standard.string(forKey: "login") == "true"{
//                    var request = URLRequest(url: URL(string: "https://one-tv.net/api/add-wishlist?item_id=\(id)")!,timeoutInterval: Double.infinity)
//                    request.addValue("Bearer \(openCartApi.token)", forHTTPHeaderField: "Authorization")
//                    request.httpMethod = "POST"
//
//                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                      guard let data = data else {
//                        print(String(describing: error))
//                        return
//                      }
//                        
//                      print(String(data: data, encoding: .utf8)!)
//                        let jsonData = JSON(data)
//                        let success = jsonData["status"].stringValue
//                        if success == "success"{
//                            if XLanguage.get() == .English{
//                                self.showDrop(title: "", message: "Added to wishlist")
//                            }else if XLanguage.get() == .Arabic{
//                                self.showDrop(title: "", message: "تمت الإضافة إلى قائمة المفضلة")
//                            }else{
//                                self.showDrop(title: "", message: "زیادکرا بۆ لیستی ئارەزووەکان")
//                            }
//                        }else{
//                            let sms = jsonData["message"]["error"].stringValue
//                            self.showDrop(title: sms, message: "")
//                        }
//                    }
//                    task.resume()
//                }else{
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let myVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//                    myVC.modalPresentationStyle = .fullScreen
//                    self.present(myVC, animated: true)
//                }
//            }else{
//                if XLanguage.get() == .English{
//                    self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"No internet connection.", remoteHostName: "magic.com")
//                    
//                }else if XLanguage.get() == .Arabic{
//                    self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"لا يوجد اتصال بالإنترنت.", remoteHostName: "magic.com")
//                    
//                }else{
//                    self.startMonitoringInternet(backgroundColor:UIColor.red, style: .cardView, textColor:UIColor.white, message:"هێلی ئینترنێت نیە", remoteHostName: "magic.com")
//                }
//            }
//        }
//        // Add favorite logic here
//    }
//    
//    @IBAction func DescriptionB(_ sender: Any) {
//        DescriptionB.backgroundColor = #colorLiteral(red: 0.02222905494, green: 0.4373427629, blue: 0.4898250103, alpha: 1)
//        DescriptionB.setTitleColor(.white, for: .normal)
//        
//        TeamB.backgroundColor = .white
//        TeamB.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
//        
//        TeamView.isHidden = true
//        Desc.isHidden = false
//    }
//    
//    @IBAction func TeamB(_ sender: Any) {
//        DescriptionB.backgroundColor = .white
//        DescriptionB.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
//        
//        TeamB.backgroundColor = #colorLiteral(red: 0.02222905494, green: 0.4373427629, blue: 0.4898250103, alpha: 1)
//        TeamB.setTitleColor(.white, for: .normal)
//        
//        TeamView.isHidden = false
//        Desc.isHidden = true
//    }
//    
//    // MARK: - Player Status Observer
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "status" {
//            DispatchQueue.main.async { [self] in
//                if player?.status == .readyToPlay {
//                    checkScreenRecordingStatus()
//                    guard !isScreenRecording else {
//                        blockVideoPlayback()
//                        return
//                    }
//                    player?.play()
//                    print("Player is ready to play")
//                } else if player?.status == .failed {
//                    print("Player failed to load video")
//                    loadingIndicator?.removeFromSuperview()
//                    showErrorAlert(message: "Failed to load video")
//                }
//            }
//        }
//    }
//}
//
//// MARK: - Collection View Extension
//extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == episodeCollectionView {
//            return EpisodesArray.count
//        } else if collectionView == RecommendedCollection {
//            return RecommendedArray.count
//        } else if collectionView == EpisodesColleciton {
//            return EpisodesArray.count
//        }
//        return 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == episodeCollectionView {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodePlayerCell", for: indexPath) as! EpisodePlayerCell
//            cell.configure(with: EpisodesArray[indexPath.row], index: indexPath.row)
//            return cell
//        } else if collectionView == RecommendedCollection {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieAndSeriesCollectionCell
//            let urlString = RecommendedArray[indexPath.row].image.portrait
//            let url = URL(string: "https://one-tv.net/assets/images/item/portrait/\(urlString)")
//            cell.Imagee?.sd_setImage(with: url)
//            cell.TypeView.isHidden = true
//            return cell
//        } else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LiveTVCollectionCell
//            let urlString = EpisodesArray[indexPath.row].image
//            let url = URL(string: "https://one-tv.net/assets/images/item/episode/\(urlString)")
//            cell.Imagee?.sd_setImage(with: url)
//            cell.EpisodeLable.text = EpisodesArray[indexPath.row].title
//            return cell
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 148, height: 215)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        if collectionView == RecommendedCollection {
//            return UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
//        }
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let currentTime = Date().timeIntervalSince1970
//        guard currentTime - lastTapTime > 0.8 else { return }
//        lastTapTime = currentTime
//        
//        AudioServicesPlaySystemSound(1519) // Haptic feedback
//        
//        if collectionView == episodeCollectionView {
//            print("Episode selected in player: \(indexPath.row)")
//            
//            // Clear previous selection visual state if needed
//            if let previousSelected = collectionView.indexPathsForSelectedItems?.first, previousSelected != indexPath {
//                collectionView.deselectItem(at: previousSelected, animated: true)
//            }
//            
//            // Get the episode ID and update
//            episodeID = EpisodesArray[indexPath.row].id
//            
//            // Partially collapse the episode panel
//            toggleEpisodePanel()
//            
//            // Start loading the new episode
//            showLoadingIndicator()
//            
//            // Check requirements before playing
//            guard CheckInternet.Connection() else {
//                hideLoadingIndicator()
//                showNoInternetAlert()
//                return
//            }
//            
//            checkScreenRecordingStatus()
//            guard !isScreenRecording else {
//                hideLoadingIndicator()
//                showScreenRecordingAlert()
//                return
//            }
//            
//            // Call API to get video URLs
//            HomeAPI.PlayVideo(item_id: itemID, episode_id: episodeID) { [weak self] videos, remark, status in
//                guard let self = self else { return }
//                
//                DispatchQueue.main.async {
//                    self.hideLoadingIndicator()
//                    
//                    // Final check before playing
//                    self.checkScreenRecordingStatus()
//                    guard !self.isScreenRecording else {
//                        self.showScreenRecordingAlert()
//                        return
//                    }
//                    
//                    guard status == "success" else {
//                        self.showErrorAlert(message: "Failed to load video")
//                        return
//                    }
//                    
//                    self.videoQualities = videos.sorted { $0.size > $1.size }
//                    
//                    // Choose quality or show selection
//                    if self.videoQualities.count > 1 {
//                        // For player, use previous quality if possible
//                        if self.selectedQualityIndex < self.videoQualities.count,
//                           let url = URL(string: self.videoQualities[self.selectedQualityIndex].url) {
//                            self.changePlayerSource(to: url)
//                        } else {
//                            // Fallback to showing quality selection
//                            self.playerVC?.dismiss(animated: true) {
//                                self.showQualitySelection()
//                            }
//                        }
//                    } else if let firstVideo = self.videoQualities.first,
//                              let url = URL(string: firstVideo.url) {
//                        self.changePlayerSource(to: url)
//                    } else {
//                        self.showErrorAlert(message: "No video available")
//                    }
//                }
//            }
//        } else if collectionView == RecommendedCollection {
//            handleRecommendedSelection(at: indexPath)
//        } else if collectionView == EpisodesColleciton {
//            handleEpisodeSelection(at: indexPath)
//        }
//    }
//    
//    
//    private func changePlayerSource(to url: URL) {
//        // Create new player item
//        let asset = AVURLAsset(url: url)
//        let playerItem = AVPlayerItem(asset: asset)
//        
//        // Replace current item
//        player?.replaceCurrentItem(with: playerItem)
//        player?.play()
//        
//        // Update episode number in watch label if needed
//        if let selectedIndex = episodeCollectionView?.indexPathsForSelectedItems?.first?.row {
//            let episodeNumber = selectedIndex + 1
//            if XLanguage.get() == .English {
//                Watchlable.text = "Watch Episode \(episodeNumber)"
//            } else if XLanguage.get() == .Arabic {
//                Watchlable.text = "شاهد الحلقة \(episodeNumber)"
//            } else {
//                Watchlable.text = "ئەڵقەی \(episodeNumber) ببینە"
//            }
//        }
//    }
//
//    // 5. Helper to hide loading indicator
//    private func hideLoadingIndicator() {
//        loadingIndicator?.removeFromSuperview()
//        loadingIndicator = nil
//    }
//    
//    private func handleRecommendedSelection(at indexPath: IndexPath) {
//        guard UserDefaults.standard.string(forKey: "login") == "true" else {
//            showLoginScreen()
//            return
//        }
//        
//        LoginAPi.getUserInfo { [weak self] info in
//            guard let self = self else { return }
//            
//            if info.planId == 0 {
//                self.showSubscriptionScreen()
//            } else {
//                self.loadSelectedRecommendedItem(at: indexPath)
//            }
//        }
//    }
//    
//    private func handleEpisodeSelection(at indexPath: IndexPath) { print("2222")
//        LoginAPi.getUserInfo { [weak self] info in
//            guard let self = self else { return }
//            print("4444")
//            if info.planId == 0 { print("555")
//                self.showSubscriptionScreen()
//            } else { print("6666")
//                self.playSelectedEpisode(at: indexPath)
//            }
//        }
//    }
//    
//    private func showLoginScreen() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//        loginVC.modalPresentationStyle = .fullScreen
//        self.present(loginVC, animated: true)
//        loadingIndicator?.removeFromSuperview()
//    }
//    
//    private func showSubscriptionScreen() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let subscribeVC = storyboard.instantiateViewController(withIdentifier: "SubscribePlaneVC") as! SubscribePlaneVC
//        subscribeVC.modalPresentationStyle = .overFullScreen
//        self.present(subscribeVC, animated: true)
//        loadingIndicator?.removeFromSuperview()
//    }
//    
//    private func loadSelectedRecommendedItem(at indexPath: IndexPath) {
//        HomeAPI.GetPaidItemById(i_id: RecommendedArray[indexPath.row].id, episode_id: 0) { [weak self] items, remark, episodes, related, status in
//            guard let self = self else { return }
//            
//            DispatchQueue.main.async {
//                self.loadingIndicator?.removeFromSuperview()
//                
//                guard status == "success" else {
//                    self.showErrorAlert(message: "Failed to load item")
//                    return
//                }
//                
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let playVC = storyboard.instantiateViewController(withIdentifier: "PlaySeriesVC") as! PlaySeriesVC
//                
//                playVC.is_series = (remark == "episode_video")
//                playVC.EpisodesArray = episodes
//                playVC.RecommendedArray = related
//                playVC.Series = items
//                playVC.title = self.RecommendedArray[indexPath.row].title
//                
//                playVC.modalPresentationStyle = .overFullScreen
//                self.present(playVC, animated: true)
//            }
//        }
//    }
//    
//    private func playSelectedEpisode(at indexPath: IndexPath) { print("777")
//        
//        episodeID = EpisodesArray[indexPath.row].id
//        Watchlable.text = "Watch Episode \(indexPath.row + 1)"
//        
//        print(self.itemID)
//        print(episodeID)
//        
//        
//        guard CheckInternet.Connection() else {
//            showNoInternetAlert()
//            return
//        }
//        
//        print("fffff")
//        checkScreenRecordingStatus()
//        
//        guard !isScreenRecording else {
//            showScreenRecordingAlert()
//            return
//        }
//        print("ggggg")
//        showLoadingIndicator()
//        
//        HomeAPI.PlayVideo(item_id: itemID, episode_id: episodeID) { [weak self] videos, remark, status in
//            guard let self = self else { return }
//            print("8888")
//                DispatchQueue.main.async {
//                    self.loadingIndicator?.removeFromSuperview()
//                    self.checkScreenRecordingStatus()
//                    guard !self.isScreenRecording else {
//                        self.showScreenRecordingAlert()
//                        return
//                    }
//                    
//                    guard status == "success" else {
//                        self.showErrorAlert(message: "Failed to load video")
//                        return
//                    }
//                    
//                    self.videoQualities = videos.sorted { $0.size > $1.size }
//                    
//                    if self.videoQualities.count > 1 {
//                        self.showQualitySelection()
//                    } else if let firstVideo = self.videoQualities.first, let url = URL(string: firstVideo.url) {
//                        self.playVideo(url: url)
//                    } else {
//                        self.showErrorAlert(message: "No video available")
//                    }
//                }
//                
//            
//        }
//        
//        
//    }
//}
//extension ViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y < -150 {
//            dismiss(animated: true)
//        }
//    }
//}
//
//
//
//
//
//class EpisodePlayerCell: UICollectionViewCell {
//    
//    let imageView = UIImageView()
//    let episodeNumberLabel = UILabel()
//    let overlayView = UIView()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupViews()
//    }
//    
//    private func setupViews() {
//        // Configure image view
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 10
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(imageView)
//        
//        // Add overlay for selected state
//        overlayView.backgroundColor = UIColor(red: 0.02, green: 0.44, blue: 0.49, alpha: 0.5)
//        overlayView.layer.cornerRadius = 10
//        overlayView.alpha = 0
//        overlayView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(overlayView)
//        
//        // Configure episode number label
//        episodeNumberLabel.font = UIFont.boldSystemFont(ofSize: 12)
//        episodeNumberLabel.textColor = .white
//        episodeNumberLabel.backgroundColor = UIColor(red: 0.02, green: 0.44, blue: 0.49, alpha: 1.0)
//        episodeNumberLabel.textAlignment = .center
//        episodeNumberLabel.layer.cornerRadius = 10
//        episodeNumberLabel.clipsToBounds = true
//        episodeNumberLabel.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(episodeNumberLabel)
//        
//        // Setup constraints
//        NSLayoutConstraint.activate([
//            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            
//            overlayView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            overlayView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            overlayView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            overlayView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            
//            episodeNumberLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
//            episodeNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
//            episodeNumberLabel.widthAnchor.constraint(equalToConstant: 24),
//            episodeNumberLabel.heightAnchor.constraint(equalToConstant: 24),
//        ])
//        
//        // Improve touch feedback
//        self.isUserInteractionEnabled = true
//        
//        // Add tap animation
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
//        contentView.addGestureRecognizer(tapGesture)
//    }
//    
//    @objc private func cellTapped() {
//        // Add visual feedback when tapped
//        UIView.animate(withDuration: 0.1, animations: {
//            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
//        }) { _ in
//            UIView.animate(withDuration: 0.1) {
//                self.transform = CGAffineTransform.identity
//            }
//        }
//    }
//    
//    override var isSelected: Bool {
//        didSet {
//            UIView.animate(withDuration: 0.3) {
//                self.overlayView.alpha = self.isSelected ? 0.7 : 0
//            }
//        }
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        imageView.image = nil
//        episodeNumberLabel.text = ""
//        overlayView.alpha = 0
//    }
//    
//    func configure(with episode: Episode, index: Int) {
//        let urlString = episode.image
//        if let url = URL(string: "https://one-tv.net/assets/images/item/episode/\(urlString)") {
//            imageView.sd_setImage(with: url)
//        }
//        
//        episodeNumberLabel.text = "\(index + 1)"
//    }
//}

