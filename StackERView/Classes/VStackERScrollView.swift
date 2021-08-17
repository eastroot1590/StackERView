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
    
    var banner: UIView = UIView()
    var bannerHeight: CGFloat = 0
    
    let contentView: VStackERView = VStackERView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 크기가 0인 배너로 시작
        addSubview(banner)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor),
            contentView.topAnchor.constraint(equalTo: banner.bottomAnchor)
        ])
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func updateConstraints() {
        // recalculate content size
        contentSize = CGSize(width: contentView.intrinsicContentSize.width, height: bannerHeight + contentView.intrinsicContentSize.height)
        
        super.updateConstraints()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        bannerLayout()
    }
    
    public func push(_ child: UIView, spacing: CGFloat = 0) {
        contentView.push(child, spacing: spacing)
        
        invalidateIntrinsicContentSize()
    }
    
    public func setBanner(_ child: UIView, height: CGFloat) {
        // remove old banner
        banner.removeFromSuperview()
        
        // add banner
        banner = child
        bannerHeight = height
        addSubview(banner)
        
        // constraint
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: banner.bottomAnchor)
        ])
    }
    
    /// sticky banner layout
    private func bannerLayout() {
        let offset = min(contentOffset.y, 0)
        
        banner.frame.origin = CGPoint(x: 0, y: offset)
        banner.frame.size = CGSize(width: frame.width, height: bannerHeight - offset)
    }
}
