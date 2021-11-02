//
//  HStackERView.swift
//  StackER
//
//  Created by 이동근 on 2021/08/11.
//

import UIKit

open class HStackERView: UIView, StackERView {
    open var stackSize: CGSize = .zero {
        didSet {
            if !stackSize.equalTo(oldValue) {
                invalidateIntrinsicContentSize()
            }
        }
    }
    
    open var stackInset: UIEdgeInsets = .zero
    
    open var stackAlignment: StackERAlign = .center
    
    open var ignoreFirstSpacing: Bool = true
    
    var stack: [StackERNode] = []
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: stackInset.left + stackSize.width + stackInset.right, height: stackInset.top + stackSize.height + stackInset.bottom)
    }
    
    open override func updateConstraints() {
        stack.forEach { updateNodeConstraint($0) }
        
        super.updateConstraints()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        var newStackSize: CGSize = .zero
        
        stack.forEach { node in
            let width = node.view.frame.width
            let height = node.view.frame.height

            if !node.view.isHidden {
                newStackSize = CGSize(width: newStackSize.width + node.spacing + width, height: max(height, newStackSize.height))
            }
        }
        
        stackSize = newStackSize
    }
    
    public func push(_ child: UIView, spacing: CGFloat = 0) {
        // add
        addSubview(child)
        
        // constraint
        child.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = child.topAnchor.constraint(equalTo: topAnchor, constant: stackInset.top)
        topConstraint.priority = UILayoutPriority(500)
        
        let lead = stack.last?.view.trailingAnchor ?? self.leadingAnchor
        var leadSpacing = spacing
        if stack.isEmpty {
            if ignoreFirstSpacing {
                leadSpacing = stackInset.left
            } else {
                leadSpacing += stackInset.left
            }
        }
        
        let leadingConstraint = child.leadingAnchor.constraint(equalTo: lead, constant: leadSpacing)
        leadingConstraint.priority = UILayoutPriority(500)
        leadingConstraint.isActive = true
        
        let bottomConstraint = child.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -stackInset.bottom)
        bottomConstraint.priority = UILayoutPriority(500)
        
        let centerConstraint = child.centerYAnchor.constraint(equalTo: centerYAnchor)
        centerConstraint.priority = UILayoutPriority(500)
        centerConstraint.isActive = true
        
        let widthConstraint = child.widthAnchor.constraint(greaterThanOrEqualToConstant: 10)
        widthConstraint.priority = UILayoutPriority(500)
        widthConstraint.isActive = true
        
        let heightConstraint = child.heightAnchor.constraint(equalToConstant: frame.height)
        heightConstraint.priority = UILayoutPriority(500)
        heightConstraint.isActive = true
        
        // append stack node
        if stack.isEmpty, ignoreFirstSpacing {
            stack.append(StackERNode(view: child, spacing: 0, constraints: [leadingConstraint, topConstraint, centerConstraint, bottomConstraint, widthConstraint, heightConstraint]))
        } else {
            stack.append(StackERNode(view: child, spacing: spacing, constraints: [leadingConstraint, topConstraint, centerConstraint, bottomConstraint, widthConstraint, heightConstraint]))
        }
        
        if let currentNode = stack.last {
            NSLayoutConstraint.activate(currentNode.constraints)
        }
        
        // update content size
        invalidateIntrinsicContentSize()
        superview?.invalidateIntrinsicContentSize()
        
        setNeedsUpdateConstraints()
    }
    
    open func updateNodeConstraint(_ node: StackERNode) {
        var targetAlignment: StackERAlign = stackAlignment
        
        // width
        if node.view.intrinsicContentSize.width > UIView.noIntrinsicMetric {
            node.constraints[4].constant = node.view.intrinsicContentSize.width
        } else {
            node.constraints[4].constant = 10
        }
        
        // height
        if node.view.intrinsicContentSize.height > UIView.noIntrinsicMetric {
            node.constraints[5].constant = node.view.intrinsicContentSize.height
        } else {
            targetAlignment = .fill
        }
        
        switch targetAlignment {
        case .leading:
            node.constraints[1].isActive = true
            node.constraints[2].isActive = false
            node.constraints[3].isActive = false
            
        case .center:
            node.constraints[1].isActive = false
            node.constraints[2].isActive = true
            node.constraints[3].isActive = false
            
        case .trailing:
            node.constraints[1].isActive = false
            node.constraints[2].isActive = false
            node.constraints[3].isActive = true
            
        case .fill:
            node.constraints[1].isActive = true
            node.constraints[2].isActive = false
            node.constraints[3].isActive = true
            node.constraints[4].isActive = false
        }
    }
}
