import UIKit

class AboutSectionCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.dataDetectorTypes = .link
        textView.linkTextAttributes = [
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Set cell background color
        contentView.backgroundColor = .black
        backgroundColor = .black
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionTextView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with aboutData: AboutData) {
        titleLabel.text = aboutData.title
        
        // First try to parse as HTML
        if let htmlData = aboutData.description.data(using: .utf8) {
            do {
                let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ]
                
                let attributedString = try NSMutableAttributedString(
                    data: htmlData,
                    options: options,
                    documentAttributes: nil)
                
                // Apply white color to all text
                attributedString.addAttribute(
                    .foregroundColor,
                    value: UIColor.white,
                    range: NSRange(location: 0, length: attributedString.length))
                
                // Apply font
                attributedString.addAttribute(
                    .font,
                    value: UIFont.systemFont(ofSize: 16),
                    range: NSRange(location: 0, length: attributedString.length))
                
                descriptionTextView.attributedText = attributedString
                return
            } catch {
                print("HTML parsing error: \(error)")
            }
        }
        
        // Fallback to plain text
        descriptionTextView.text = aboutData.description
        descriptionTextView.textColor = .white
    }
}
