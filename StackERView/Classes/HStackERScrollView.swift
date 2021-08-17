//
//  HStackERScrollView.swift
//  StackER
//
//  Created by 이동근 on 2021/08/11.
//

import UIKit

open class HStackERScrollView: UIScrollView {
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
    
    public let contentView: HStackERView = HStackERView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        super.addSubview(contentView)
        
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
                contentView.heightAnchor.constraint(equalTo: heightAnchor),
                contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
                contentView.heightAnchor.constraint(equalTo: heightAnchor),
                contentView.leadingAnchor.constraint(equalTo: leadingAnchor)
            ])
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func updateConstraints() {
        // recalculate content size
        contentSize = contentView.intrinsicContentSize
        
        super.updateConstraints()
    }
    
    public func push(_ child: UIView, spacing: CGFloat = 0) {
        contentView.push(child, spacing: spacing)
        
        invalidateIntrinsicContentSize()
    }
}
