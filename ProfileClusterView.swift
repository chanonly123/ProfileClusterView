//  Created by Chandan Karmakar on 07/04/20.

import UIKit

@IBDesignable
class ProfileClusterView: UIView {
    
    let stackView = UIStackView()
    var leadingConst: NSLayoutConstraint!
    var trailingConst: NSLayoutConstraint!
    var centerConst: NSLayoutConstraint!
    
    var configureMoreView: (((label: UILabel, more: Int))->Void)?
    var configureImageView: (((imageView: UIImageView, index: Int))->Void)?
    var configureCount: (()->Int)?
    
    @IBInspectable
    var spacing: CGFloat = -8 {
        didSet { updateStackViewSize() }
    }
    
    /// "left", "right", "center"
    @IBInspectable
    var alignment: String = "left" {
        didSet { updateStackViewSize() }
    }
    
    /// "left", "right"
    @IBInspectable
    var startFrom: String = "left" {
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
    
    override func prepareForInterfaceBuilder() {
        configureCount = { return 8 }
        reloadData()
    }
    
    func commonInit() {
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
        
        updateStackViewSize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reloadDataInternal()
    }
    
    func updateStackViewSize() {
        stackView.spacing = spacing
        
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
        } else {
            centerConst?.isActive = true
        }
        
        let scaleX: CGFloat = startFrom == "left" ? 1 : -1
        stackView.transform = .init(scaleX: scaleX, y: 1)
        stackView.arrangedSubviews.forEach({ $0.transform = .init(scaleX: scaleX, y: 1) })
    }
    
    func reloadData() {
        prevBounds = CGRect.zero
        reloadDataInternal()
    }
    
    var prevBounds = CGRect.zero
    
    private func reloadDataInternal() {
        if bounds == prevBounds { return }
        prevBounds = bounds
        
        let count = configureCount?() ?? 0
        
        let singleWidth = bounds.height + spacing
        var visibleCount = 0
        if singleWidth > 0 {
            visibleCount = Int((bounds.width-bounds.height) / singleWidth)
        }
        if bounds.width > bounds.height {
            visibleCount += 1
        } else {
            visibleCount = 1
        }
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if count == 0 { return }
        
        for i in 1...visibleCount {
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
    
    func addImageView(index: Int) {
        let sub = UIView()
        sub.translatesAutoresizingMaskIntoConstraints = false
        sub.heightAnchor.constraint(equalTo: sub.widthAnchor, multiplier: 1, constant: 0).isActive = true
        stackView.addArrangedSubview(sub)
        
        let iv = UIImageView()
        iv.layer.cornerRadius = bounds.height / 2
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = getRandomColor(index: index)
        iv.contentMode = .scaleAspectFill
        
        sub.addSubview(iv)
        iv.addPinConstraints()
        configureImageView?((iv, index))
    }
    
    func addLabel(more: Int, index: Int) {
        let sub = UIView()
        sub.translatesAutoresizingMaskIntoConstraints = false
        sub.heightAnchor.constraint(equalTo: sub.widthAnchor, multiplier: 1, constant: 0).isActive = true
        stackView.addArrangedSubview(sub)
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.layer.cornerRadius = bounds.height / 2
        lbl.font = UIFont.boldSystemFont(ofSize: bounds.height / 2.5)
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.clipsToBounds = true
        lbl.textColor = .white
        lbl.backgroundColor = getLabelColor()
        lbl.text = "+\(more)"

        sub.addSubview(lbl)
        lbl.addPinConstraints()
        configureMoreView?((lbl, more))
    }
    
    func getRandomColor(index: Int) -> UIColor {
        let color1 = UIColor(red: 179/255, green: 235/255, blue: 242/255, alpha: 1)
        let color2 = UIColor(red: 239/255, green: 154/255, blue: 154/255, alpha: 1)
        let color3 = UIColor(red: 165/255, green: 214/255, blue: 167/255, alpha: 1)
        return index % 3 == 0 ? color1 : (index % 2 == 0 ? color2 : color3)
    }
    
    func getLabelColor() -> UIColor {
        return UIColor(red: 126/255, green: 87/255, blue: 194/255, alpha: 1)
    }
    
    func copyClosuresFrom(_ viewProfiles: ProfileClusterView) {
        configureCount = viewProfiles.configureCount
        configureImageView = viewProfiles.configureImageView
        configureMoreView = viewProfiles.configureMoreView
    }
}


extension UIView {
    func addPinConstraints(_ val: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: superview!.leadingAnchor, constant: val).isActive = true
        trailingAnchor.constraint(equalTo: superview!.trailingAnchor, constant: -val).isActive = true
        topAnchor.constraint(equalTo: superview!.topAnchor, constant: val).isActive = true
        bottomAnchor.constraint(equalTo: superview!.bottomAnchor, constant: -val).isActive = true
    }
}
