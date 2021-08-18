//
//  VStackERScrollView.swift
//  StackER
//
//  Created by 이동근 on 2021/08/11.
//

import UIKit

open class VStackERScrollView: UIScrollView {
    public var stackInset: UIEdgeInsets {
        get {
            contentView.stackInset
        }
        set {
            contentView.stackInset = newValue
        }
    }
    
    public var stackAlignment: UIView.ContentMode {
        get {
            contentView.stackAlignment
        }
        set {
            contentView.stackAlignment = newValue
        }
    }
    
    var bannerView: UIView?
    public var banner: UIView? {
        return bannerView
    }
    
    var bannerHeight: CGFloat = 0
    
    var ribbonView: UIView?
    public var ribbon: UIView? {
        return ribbonView
    }
    
    var ribbonHeight: CGFloat = 0
    
    let contentView: VStackERView = VStackERView()
    var contentViewTopConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentViewTopConstraint = contentView.topAnchor.constraint(equalTo: topAnchor)
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor),
            contentViewTopConstraint
        ])
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func updateConstraints() {
        contentViewTopConstraint.constant = bannerHeight + ribbonHeight
        
        // recalculate content size
        contentSize = CGSize(width: contentView.intrinsicContentSize.width, height: bannerHeight + ribbonHeight + contentView.intrinsicContentSize.height)
        
        super.updateConstraints()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        bannerLayout()
        ribbonLayout()
    }
    
    public func push(_ child: UIView, spacing: CGFloat = 0) {
        contentView.push(child, spacing: spacing)
        
        invalidateIntrinsicContentSize()
    }
    
    public func setBanner(_ child: UIView, height: CGFloat) {
        // add banner
        bannerView = child
        bannerHeight = height
        addSubview(child)
        
        // constraint
        setNeedsUpdateConstraints()
    }
    
    public func removeBanner() {
        bannerView?.removeFromSuperview()
        bannerView = nil
        bannerHeight = 0
        
        setNeedsUpdateConstraints()
    }
    
    public func setRibbon(_ view: UIView, height: CGFloat) {
        ribbonView = view
        ribbonHeight = height
        addSubview(view)
        
        // constraint
        setNeedsUpdateConstraints()
    }
    
    public func removeRibbon() {
        ribbonView?.removeFromSuperview()
        ribbonView = nil
        ribbonHeight = 0
        
        setNeedsUpdateConstraints()
    }
    
    /// sticky banner layout
    private func bannerLayout() {
        guard let banner = bannerView else {
            return
        }
        
        stickyHeaderLayout(banner, height: bannerHeight)
    }
    
    /// pivot ribbon layout
    private func ribbonLayout() {
        guard let ribbon = ribbonView else {
            return
        }
        
        // 베너가 없으면 sticky header
        if banner == nil {
            stickyHeaderLayout(ribbon, height: ribbonHeight)
        } else {
            pivotLayout(ribbon, height: ribbonHeight)
        }
    }
    
    private func stickyHeaderLayout(_ view: UIView, height: CGFloat) {
        let offset = min(contentOffset.y, 0)
        
        view.frame.origin = CGPoint(x: 0, y: offset)
        view.frame.size = CGSize(width: frame.width, height: height - offset)
    }
    
    private func pivotLayout(_ view: UIView, height: CGFloat) {
        view.frame.origin = CGPoint(x: 0, y: max(contentOffset.y, bannerHeight))
        
        let offset = max(contentOffset.y + adjustedContentInset.top, bannerHeight) - bannerHeight
        let newHeight = min(height + offset, height + adjustedContentInset.top)
        view.frame.size = CGSize(width: frame.width, height: newHeight)
    }
}
