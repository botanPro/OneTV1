import UIKit

@IBDesignable
open class Slider2: UIControl {
    /// The slider’s current lower value.
    @IBInspectable
    open var value: Int = 0 { // default 0. this value will be pinned to min/max/value2
        didSet {
            if value < minimumValue {
                value = minimumValue
                return
            }
            if oldValue == value {
                return
            }
            if value2 < value {
                value2 = value
                return
            }
            setNeedsLayout()
        }
    }
    
    /// The slider’s current upper value.
    @IBInspectable
    open var value2: Int = 0 { // default 0. this value will be pinned to min/max/value1
        didSet {
            if value2 > maximumValue {
                value2 = maximumValue
                return
            }
            if oldValue == value2 {
                return
            }
            if value2 < value {
                value = value2
                return
            }
            setNeedsLayout()
        }
    }
    
    /// The minimum value of the slider.
    @IBInspectable
    open var minimumValue: Int = .min // default Int.min. the current value may change if outside new min value
    
    /// The maximum value of the slider.
    @IBInspectable
    open var maximumValue: Int = .max // default Int.max. the current value may change if outside new max value
    
    /// A Bool value indicating whether changes in the slider’s value generate continuous update events.
    @IBInspectable
    open var isContinuous: Bool = true
    
    /// The image representing the slider’s minimum value.
    @IBInspectable
    open var minimumValueImage: UIImage? // default is nil. image that appears to left of control
    
    /// The image representing the slider’s maximum value.
    @IBInspectable
    open var maximumValueImage: UIImage? // default is nil. image that appears to right of control
    
    /// The color used to tint the default minimum track images.
    @IBInspectable
    open var minimumTrackTintColor: UIColor?
    
    /// The color used to tint the default maximum track images.
    @IBInspectable
    open var maximumTrackTintColor: UIColor?
    
    /// The height of all track views.
    @IBInspectable
    open var trackHeight: CGFloat = 1
    
    /// The image representing the thumb view.
    @IBInspectable
    open var thumbImage: UIImage? {
        didSet {
            thumbView.layer.contents = thumbImage?.cgImage
        }
    }
    
    /// The image representing the thumb view.
    @IBInspectable
    open var thumbImage2: UIImage? {
        didSet {
            thumbView2.layer.contents = thumbImage2?.cgImage
        }
    }
    
    @IBInspectable
    open var thumbSpacing: CGFloat = 0
    
    @IBInspectable
    open var thumbSize: CGSize = .zero
    
    @IBInspectable
    open var thumb2Spacing: CGFloat = 0
    
    @IBInspectable
    open var thumb2Size: CGSize = .zero
    
    /// The left thumb view of the slider.
    open var thumbView = UIView()
    
    /// The right thumb view of the slider.
    open var thumbView2 = UIView()
    
    /// The left track view of the slider.
    open var trackView1 = UIView()
    
    /// The middle track view of the slider.
    open var trackView2 = UIView()
    
    /// The right track view of the slider.
    open var trackView3 = UIView()
    
    private var isMovingThumb = false
    
    private lazy var containerView: UIView = self
    
    private lazy var panGestureRecognizer = UIPanGestureRecognizer(
        target: self, action: #selector(pan(recognizer:)))
    
    private var thumbViewCenterXConstraint: NSLayoutConstraint!
    
    private var thumbView2CenterXConstraint: NSLayoutConstraint!
    
    private var stepWidth: CGFloat {
        return (containerView.frame.width - (thumbSize.width + thumb2Size.width) / 2)
            / CGFloat(maximumValue - minimumValue)
    }
    
    private let impact = UISelectionFeedbackGenerator()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if thumbView.superview == nil {
            firstLayout()
        }
        
        let thumbViewCenterX = CGFloat(value - minimumValue) * stepWidth + thumbSize.width / 2
        thumbViewCenterXConstraint.constant = thumbViewCenterX
        let thumbView2CenterX = CGFloat(value2 - minimumValue) * stepWidth + thumbSize.width / 2
        thumbView2CenterXConstraint.constant = thumbView2CenterX
        sendActions(for: .valueChanged)
        impact.selectionChanged()
    }
    
    @objc internal func pan(recognizer: UIPanGestureRecognizer) {
        let p = recognizer.location(in: containerView)
        switch recognizer.state {
        case .began:
            isMovingThumb = thumbView.frame.maxX >= p.x - containerView.frame.minX
        case .changed, .ended:
            if !isContinuous && recognizer.state == .changed {
                return
            }
            let targetValue = minimumValue + Int(round(p.x / stepWidth))
            if isMovingThumb {
                value = targetValue
            } else {
                value2 = targetValue
            }
        default:
            break
        }
    }
    
    private func firstLayout() {
        var containerWidth = frame.width // Fix missing container width at first layout.
        if var minimumValueImage = minimumValueImage {
            let ratio = minimumValueImage.size.width / minimumValueImage.size.height
            containerWidth -= frame.height * ratio
            let imageView = UIImageView()
            if let minimumTrackTintColor = minimumTrackTintColor {
                imageView.tintColor = minimumTrackTintColor
                minimumValueImage = minimumValueImage.withRenderingMode(.alwaysTemplate)
            }
            imageView.image = minimumValueImage
            addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            addConstraints([
                .init(
                    item: imageView,
                    attribute: .height,
                    relatedBy: .equal,
                    toItem: self,
                    attribute: .height,
                    multiplier: 1,
                    constant: 0),
                .init(
                    item: imageView,
                    attribute: .width,
                    relatedBy: .equal,
                    toItem: self,
                    attribute: .height,
                    multiplier: ratio,
                    constant: 0),
                .init(
                    item: imageView,
                    attribute: .top,
                    relatedBy: .equal,
                    toItem: self,
                    attribute: .top,
                    multiplier: 1,
                    constant: 0),
                .init(
                    item: imageView,
                    attribute: .left,
                    relatedBy: .equal,
                    toItem: self,
                    attribute: .left,
                    multiplier: 1,
                    constant: 0)
            ])
            containerView = UIView()
            addSubview(containerView)
            containerView.translatesAutoresizingMaskIntoConstraints = false
            addConstraints([
                .init(
                    item: containerView,
                    attribute: .left,
                    relatedBy: .equal,
                    toItem: imageView,
                    attribute: .right,
                    multiplier: 1,
                    constant: 0),
                .init(
                    item: containerView,
                    attribute: .top,
                    relatedBy: .equal,
                    toItem: self,
                    attribute: .top,
                    multiplier: 1,
                    constant: 0),
                .init(
                    item: containerView,
                    attribute: .bottom,
                    relatedBy: .equal,
                    toItem: self,
                    attribute: .bottom,
                    multiplier: 1,
                    constant: 0)
            ])
            containerView.frame.size.width = containerWidth
        }
        
        if var maximumValueImage = maximumValueImage {
            let ratio = maximumValueImage.size.width / maximumValueImage.size.height
            containerWidth -= frame.height * ratio
            let imageView = UIImageView()
            if let maximumTrackTintColor = maximumTrackTintColor {
                imageView.tintColor = maximumTrackTintColor
                maximumValueImage = maximumValueImage.withRenderingMode(.alwaysTemplate)
            }
            imageView.image = maximumValueImage
            addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            addConstraints([
                .init(
                    item: imageView,
                    attribute: .height,
                    relatedBy: .equal,
                    toItem: self,
                    attribute: .height,
                    multiplier: 1,
                    constant: 0),
                .init(
                    item: imageView,
                    attribute: .width,
                    relatedBy: .equal,
                    toItem: self,
                    attribute: .height,
                    multiplier: ratio,
                    constant: 0),
                .init(
                    item: imageView,
                    attribute: .bottom,
                    relatedBy: .equal,
                    toItem: self,
                    attribute: .bottom,
                    multiplier: 1,
                    constant: 0),
                .init(
                    item: imageView,
                    attribute: .right,
                    relatedBy: .equal,
                    toItem: self,
                    attribute: .right,
                    multiplier: 1,
                    constant: 0)
            ])
            
            if containerView == self {
                containerView = UIView()
                addSubview(containerView)
                containerView.translatesAutoresizingMaskIntoConstraints = false
                addConstraints([
                    .init(
                        item: containerView,
                        attribute: .top,
                        relatedBy: .equal,
                        toItem: self,
                        attribute: .top,
                        multiplier: 1,
                        constant: 0),
                    .init(
                        item: containerView,
                        attribute: .bottom,
                        relatedBy: .equal,
                        toItem: self,
                        attribute: .bottom,
                        multiplier: 1,
                        constant: 0),
                    .init(
                        item: containerView,
                        attribute: .left,
                        relatedBy: .equal,
                        toItem: self,
                        attribute: .left,
                        multiplier: 1,
                        constant: 0)
                    
                ])
            }
            containerView.frame.size.width = containerWidth
            addConstraint(.init(
                item: containerView,
                attribute: .right,
                relatedBy: .equal,
                toItem: imageView,
                attribute: .left,
                multiplier: 1,
                constant: 0))
        } else if containerView != self {
            addConstraint(.init(
                item: containerView,
                attribute: .right,
                relatedBy: .equal,
                toItem: self,
                attribute: .right,
                multiplier: 1,
                constant: 0))
        }
        
        containerView.addGestureRecognizer(panGestureRecognizer)
        containerView.addSubview(thumbView)
        containerView.addSubview(thumbView2)
        containerView.addSubview(trackView1)
        containerView.addSubview(trackView2)
        containerView.addSubview(trackView3)
        
        thumbView.translatesAutoresizingMaskIntoConstraints = false
        thumbView2.translatesAutoresizingMaskIntoConstraints = false
        trackView1.translatesAutoresizingMaskIntoConstraints = false
        trackView2.translatesAutoresizingMaskIntoConstraints = false
        trackView3.translatesAutoresizingMaskIntoConstraints = false
        
        trackView1.backgroundColor = .init(red: 1, green: 0.172, blue: 0.49, alpha: 1)
        trackView2.backgroundColor = .init(red: 0, green: 0.57, blue: 1, alpha: 1)
        trackView3.backgroundColor = .init(red: 0.914, green: 0.933, blue: 0.988, alpha: 1)
        
        thumbViewCenterXConstraint = NSLayoutConstraint(
            item: thumbView,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: containerView,
            attribute: .left,
            multiplier: 1,
            constant: thumbSize.width / 2)
        
        containerView.addConstraints([
            .init(
                item: thumbView,
                attribute: .height,
                relatedBy: .equal, toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: thumbSize.height),
            .init(
                item: thumbView,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: thumbSize.width),
            .init(
                item: thumbView,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: containerView,
                attribute: .centerY,
                multiplier: 1,
                constant: 0),
            thumbViewCenterXConstraint
        ])
        
        thumbView2CenterXConstraint = NSLayoutConstraint(
            item: thumbView2,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: containerView,
            attribute: .left,
            multiplier: 1,
            constant: thumbSize.width / 2)
        
        containerView.addConstraints([
            .init(
                item: thumbView2,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: thumb2Size.height),
            .init(
                item: thumbView2,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: thumb2Size.width),
            .init(
                item: thumbView2,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: containerView,
                attribute: .centerY,
                multiplier: 1,
                constant: 0),
            thumbView2CenterXConstraint
        ])
        
        let trackView1RightConstraint = NSLayoutConstraint(
            item: trackView1,
            attribute: .right,
            relatedBy: .equal,
            toItem: thumbView,
            attribute: .left,
            multiplier: 1,
            constant: -thumbSpacing)
        trackView1RightConstraint.priority = .defaultLow
        
        containerView.addConstraints([
            .init(
                item: trackView1,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: trackHeight),
            .init(
                item: trackView1,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: containerView,
                attribute: .centerY,
                multiplier: 1,
                constant: 0),
            .init(
                item: trackView1,
                attribute: .left,
                relatedBy: .equal,
                toItem: containerView,
                attribute: .left,
                multiplier: 1,
                constant: thumbSize.width / 2),
            trackView1RightConstraint
        ])
        
        let trackView2LeftConstraint = NSLayoutConstraint(
            item: trackView2,
            attribute: .left,
            relatedBy: .equal,
            toItem: thumbView,
            attribute: .right,
            multiplier: 1,
            constant: thumbSpacing)
        trackView2LeftConstraint.priority = .defaultLow
        
        let trackView2RightConstraint = NSLayoutConstraint(
            item: trackView2,
            attribute: .right,
            relatedBy: .equal,
            toItem: thumbView2,
            attribute: .left,
            multiplier: 1,
            constant: -thumb2Spacing)
        trackView2RightConstraint.priority = .defaultLow
        
        containerView.addConstraints([
            .init(
                item: trackView2,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: trackHeight),
            .init(
                item: trackView2,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: containerView,
                attribute: .centerY,
                multiplier: 1,
                constant: 0),
            trackView2LeftConstraint,
            trackView2RightConstraint
        ])
        
        let trackView3Left = NSLayoutConstraint(
            item: trackView3,
            attribute: .left,
            relatedBy: .equal,
            toItem: thumbView2,
            attribute: .right,
            multiplier: 1,
            constant: thumb2Spacing)
        trackView3Left.priority = .defaultLow
        
        containerView.addConstraints([
            .init(
                item: trackView3,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: trackHeight),
            .init(
                item: trackView3,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: containerView,
                attribute: .centerY,
                multiplier: 1,
                constant: 0),
            .init(
                item: trackView3,
                attribute: .right,
                relatedBy: .equal,
                toItem: containerView,
                attribute: .right,
                multiplier: 1,
                constant: -thumbSize.width / 2),
            trackView3Left
        ])
    }
}
