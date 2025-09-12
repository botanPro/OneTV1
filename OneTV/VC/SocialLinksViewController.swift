//
//  SocialLinksViewController.swift
//  OneTV
//
//  Created by Botan Amedi on 05/05/2025.
//

import UIKit
import Alamofire
import SwiftyJSON

class SocialLinksViewController: UIViewController {
    
    // MARK: - Properties
    private var socialLinks: [SocialObject] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SocialLinkCell.self, forCellReuseIdentifier: SocialLinkCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSocialLinks()
    }
    
    // MARK: - Setup
    private func setupUI() {
        if XLanguage.get() == .English{
            title = "Social media Links"
        }else if XLanguage.get() == .Arabic{
            title = "روابط وسائل التواصل الاجتماعي"
        }else{
            title = "لینکی سۆشیال میدیا"
        }
        view.backgroundColor = .black
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Data Loading
    private func loadSocialLinks() {
        SocialAPi.getSocial { [weak self] socialLinks in
            self?.socialLinks = socialLinks
            self?.tableView.reloadData()
        }
    }
}

// MARK: - UITableView DataSource & Delegate
extension SocialLinksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return socialLinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SocialLinkCell.identifier, for: indexPath) as? SocialLinkCell else {
            return UITableViewCell()
        }
        
        let socialLink = socialLinks[indexPath.row]
        cell.configure(with: socialLink)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let socialLink = socialLinks[indexPath.row]
        
        // Handle phone number differently
        if socialLink.title == "Phone Number" {
            if let url = URL(string: "tel://\(socialLink.url)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            // Open web URLs
            if let url = URL(string: socialLink.url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}

// MARK: - Custom TableView Cell
class SocialLinkCell: UITableViewCell {
    static let identifier = "SocialLinkCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Set cell background color
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // Configure container view
        containerView.backgroundColor = #colorLiteral(red: 0.23563537, green: 0.2386012375, blue: 0.2385489941, alpha: 1)
        
        // Configure selected background
        let bgColorView = UIView()
        bgColorView.backgroundColor = #colorLiteral(red: 0.23563537, green: 0.2386012375, blue: 0.2385489941, alpha: 1).withAlphaComponent(0.7)
        selectedBackgroundView = bgColorView
        
        // Add views to hierarchy
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            // Container view constraints
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            // Title label constraints
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupAppearance() {
        // Round corners
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
    }
    
    func configure(with socialLink: SocialObject) {
        titleLabel.text = socialLink.title
    }
}
