//
//  ProfileClusterView.swift
//
//  Created by Chandan Karmakar on 26/11/20.
//

import UIKit

@IBDesignable
public class ProfileClusterView: UIView {
    public let stackView = UIStackView()
    private var leadingConst: NSLayoutConstraint!
    private var trailingConst: NSLayoutConstraint!
    private var centerConst: NSLayoutConstraint!

    public var configureMoreView: (((label: UILabel, more: Int)) -> Void)?
    public var configureImageView: (((imageView: UIImageView, index: Int)) -> Void)?
    
    public var configureMoreViewCustom: (((view: UIView, more: Int)) -> Void)?
    public var configureImageViewCustom: (((view: UIView, index: Int)) -> Void)?
    
    public var configureCount: (() -> Int)?
    public var reloadWhenLayout = true
    public var itemWidth: CGFloat?
    
    // view cache to optimize resizing
    private var imageViewCache = [Int: UIView]()
    public var widthConst: NSLayoutConstraint!
    
    @IBInspectable
    public var shadowLevel: CGFloat = 0.0 {
        didSet {
            setShadowLevel(shadowLevel)
        }
    }
    
    @IBInspectable
    public var maxVisible: Int = 0 {
        didSet {
            reloadDataInternal()
            if configureImageViewCustom == nil && configureMoreViewCustom == nil {
                stackView.arrangedSubviews.forEach { sub in
                    sub.subviews.first?.layer.cornerRadius = getItemWidth() / 2
                }
            }
        }
    }

    @IBInspectable
    public var spacing: CGFloat = -8 {
        didSet { updateStackViewSize() }
    }

    /// "left", "right", "center", "justify"
    @IBInspectable
    public var alignment: String = "left" {
        didSet { updateStackViewSize() }
    }

    /// "left", "right"
    @IBInspectable
    public var startFrom: String = "left" {
        didSet { updateStackViewSize() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override public func prepareForInterfaceBuilder() {
        configureCount = { 8 }
        reloadData()
    }

    private func commonInit() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        leadingConst = stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        trailingConst = trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0)
        centerConst = centerXAnchor.constraint(equalTo: stackView.centerXAnchor, constant: 0)
        topAnchor.constraint(equalTo: stackView.topAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        leadingConst.isActive = true
        trailingConst.isActive = true
        centerConst.isActive = true
        
        widthConst = widthAnchor.constraint(equalToConstant: 1)
        widthConst.isActive = false
        widthConst.priority = .defaultHigh

        updateStackViewSize()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        if reloadWhenLayout {
            reloadDataInternal()
        }
        if configureImageViewCustom == nil && configureMoreViewCustom == nil {
            stackView.arrangedSubviews.forEach { sub in
                sub.subviews.first?.layer.cornerRadius = getItemWidth() / 2
            }
        }
    }
    
    private func getItemWidth() -> CGFloat {
        return itemWidth ?? bounds.height
    }

    private func updateStackViewSize() {
        stackView.spacing = spacing
        stackView.distribution = .fillEqually

        centerConst?.isActive = false
        leadingConst?.isActive = false
        trailingConst?.isActive = false

        if alignment == "left" {
            leadingConst?.isActive = true
            trailingConst?.isActive = true
            leadingConst?.priority = .defaultHigh
            trailingConst?.priority = .defaultLow
        } else if alignment == "right" {
            leadingConst?.isActive = true
            trailingConst?.isActive = true
            leadingConst?.priority = .defaultLow
            trailingConst?.priority = .defaultHigh
        } else if alignment == "center" {
            centerConst?.isActive = true
        } else if alignment == "justify" {
            leadingConst?.isActive = true
            trailingConst?.isActive = true
            leadingConst?.priority = .defaultHigh
            trailingConst?.priority = .defaultHigh
            stackView.distribution = .equalSpacing
        } else {
            assertionFailure("ProfileClusterView alignment value wrong")
        }

        let scaleX: CGFloat = startFrom == "left" ? 1 : -1
        stackView.transform = .init(scaleX: scaleX, y: 1)
        stackView.arrangedSubviews.forEach { $0.transform = .init(scaleX: scaleX, y: 1) }
    }

    public func reloadData() {
        imageViewCache.removeAll()
        prevBounds = bounds.insetBy(dx: 10, dy: 10)
        reloadDataInternal()
        
        if configureImageViewCustom == nil {
            stackView.arrangedSubviews.forEach { sub in
                sub.subviews.first?.layer.cornerRadius = getItemWidth() / 2
            }
        }
    }

    private var prevBounds = CGRect.zero

    private func reloadDataInternal() {
        if bounds == prevBounds { return }
        prevBounds = bounds

        let count = configureCount?() ?? 0
        widthConst.constant = CGFloat(count) * getItemWidth() + (CGFloat(count - 1) * spacing)

        let singleWidth = getItemWidth() + spacing
        var visibleCount = 0
        if singleWidth > 0 {
            visibleCount = Int((bounds.width - getItemWidth()) / singleWidth)
        }
        if bounds.width > getItemWidth() {
            visibleCount += 1
        } else {
            visibleCount = 1
        }
        
        if maxVisible > 0 { visibleCount = maxVisible }

        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        if count == 0 { return }

        for i in 1 ... visibleCount {
            if i > count { break }
            if i == visibleCount { // last item
                let more = count - i + 1
                if more > 1 {
                    addLabel(more: more, index: i - 1)
                } else {
                    addImageView(index: i - 1)
                }
            } else {
                addImageView(index: i - 1)
            }
        }

        updateStackViewSize()
    }

    private func addImageView(index: Int) {
        if let found = imageViewCache[index] {
            stackView.addArrangedSubview(found)
            return
        }
        let sub = UIView()
        imageViewCache[index] = sub
        sub.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(sub)
        if let itemWidth = itemWidth {
            sub.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 1, constant: 0).isActive = true
            sub.widthAnchor.constraint(equalToConstant: itemWidth).isActive = true
        } else {
            sub.heightAnchor.constraint(equalTo: sub.widthAnchor, multiplier: 1, constant: 0).isActive = true
        }

        if let configureImageViewCustom = configureImageViewCustom {
            configureImageViewCustom((sub, index))
            return
        }
        
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = getRandomColor(index: index)
        iv.contentMode = .scaleAspectFill

        sub.addSubview(iv)
        addPinConstraints(view: iv, val: 0)

        configureImageView?((iv, index))
    }

    private func addLabel(more: Int, index: Int) {
        let sub = UIView()
        sub.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(sub)
        if let itemWidth = itemWidth {
            sub.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 1, constant: 0).isActive = true
            sub.widthAnchor.constraint(equalToConstant: itemWidth).isActive = true
        } else {
            sub.heightAnchor.constraint(equalTo: sub.widthAnchor, multiplier: 1, constant: 0).isActive = true
        }
        
        if let configureMoreViewCustom = configureMoreViewCustom {
            configureMoreViewCustom((sub, more))
            return
        }

        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: getItemWidth() / 2.5)
        lbl.numberOfLines = 1
        lbl.baselineAdjustment = .alignCenters
        lbl.adjustsFontSizeToFitWidth = true
        lbl.lineBreakMode = .byClipping
        lbl.textAlignment = .center
        lbl.clipsToBounds = true
        lbl.textColor = .white
        lbl.backgroundColor = getLabelColor()
        lbl.text = "+\(more)"

        sub.addSubview(lbl)
        addPinConstraints(view: lbl, val: 0)
        configureMoreView?((lbl, more))
    }

    private func getRandomColor(index: Int) -> UIColor {
        let color1 = UIColor(red: 179 / 255, green: 235 / 255, blue: 242 / 255, alpha: 1)
        let color2 = UIColor(red: 239 / 255, green: 154 / 255, blue: 154 / 255, alpha: 1)
        let color3 = UIColor(red: 165 / 255, green: 214 / 255, blue: 167 / 255, alpha: 1)
        return index % 3 == 0 ? color1 : (index % 2 == 0 ? color2 : color3)
    }

    private func getLabelColor() -> UIColor {
        return UIColor(red: 126 / 255, green: 87 / 255, blue: 194 / 255, alpha: 1)
    }

    public func copyClosuresFrom(_ viewProfiles: ProfileClusterView) {
        configureCount = viewProfiles.configureCount
        configureImageView = viewProfiles.configureImageView
        configureMoreView = viewProfiles.configureMoreView
    }

    private func addPinConstraints(view: UIView, val: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: view.superview!.leadingAnchor, constant: val).isActive = true
        view.trailingAnchor.constraint(equalTo: view.superview!.trailingAnchor, constant: -val).isActive = true
        view.topAnchor.constraint(equalTo: view.superview!.topAnchor, constant: val).isActive = true
        view.bottomAnchor.constraint(equalTo: view.superview!.bottomAnchor, constant: -val).isActive = true
    }
    
    private func setShadowLevel(_ shadowLevel: CGFloat, layer: CALayer? = nil) {
        let layer = layer ?? self.layer
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: shadowLevel * 0.5, height: shadowLevel * 0.5)
        layer.shadowRadius = CGFloat(abs(shadowLevel))
        layer.shadowOpacity = Float(0.25 * abs(shadowLevel) * 0.4)
    }
}
