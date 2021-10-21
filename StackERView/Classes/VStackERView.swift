//
//  VStackERView.swift
//  StackER
//
//  Created by 이동근 on 2021/08/11.
//

import UIKit

open class VStackERView: UIView, StackERView {
    
    open var stackSize: CGSize = .zero {
        didSet {
            if !stackSize.equalTo(oldValue) {
                superview?.updateConstraints()
            }
        }
    }
    
    open var stackInset: UIEdgeInsets = .zero
    
    open var stackAlignment: StackERAlign = .center
    
    open var ignoreFirstSpacing: Bool = true
    
    var stack: [StackERNode] = []
    
    open override class var requiresConstraintBasedLayout: Bool {
        false
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: stackInset.left + stackSize.width + stackInset.right, height: stackInset.top + stackSize.height + stackInset.bottom)
    }

    open override func updateConstraints() {
        for node in stack {
            updateNodeConstraint(node)
        }

        super.updateConstraints()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        var newStackSize: CGSize = .zero
        
        stack.forEach { node in
            let width = node.view.frame.width
            let height = node.view.frame.height

            if !node.view.isHidden {
                newStackSize = CGSize(width: max(width, newStackSize.width), height: newStackSize.height + node.spacing + height)
            }
        }
        
        stackSize = newStackSize
    }
    
    public func push(_ child: UIView, spacing: CGFloat = 0) {
        // add
        addSubview(child)
        
        // constraint
        child.translatesAutoresizingMaskIntoConstraints = false

        let top = stack.last?.view.bottomAnchor ?? self.topAnchor
        var topSpacing = spacing
        if stack.isEmpty, ignoreFirstSpacing {
            topSpacing = 0
        }
        let topConstraint = child.topAnchor.constraint(equalTo: top, constant: topSpacing)
        topConstraint.priority = UILayoutPriority(500)
        topConstraint.isActive = true

        let leadingConstraint = child.leadingAnchor.constraint(equalTo: leadingAnchor, constant: stackInset.left)
        leadingConstraint.priority = UILayoutPriority(500)
        
        let trailingConstraint = child.trailingAnchor.constraint(equalTo: trailingAnchor, constant: stackInset.right)
        trailingConstraint.priority = UILayoutPriority(500)
        
        let centerConstraint = child.centerXAnchor.constraint(equalTo: centerXAnchor)
        centerConstraint.priority = UILayoutPriority(500)
        centerConstraint.isActive = true

        let widthConstraint = child.widthAnchor.constraint(equalToConstant: frame.width)
        widthConstraint.priority = UILayoutPriority(500)
        widthConstraint.isActive = true

        let heightConstraint = child.heightAnchor.constraint(greaterThanOrEqualToConstant: 10)
        heightConstraint.priority = UILayoutPriority(500)
        heightConstraint.isActive = true
        
        
        // append stack node
        if stack.isEmpty, ignoreFirstSpacing {
            stack.append(StackERNode(view: child, spacing: 0, constraints: [topConstraint, leadingConstraint, centerConstraint, trailingConstraint, widthConstraint, heightConstraint]))
        } else {
            stack.append(StackERNode(view: child, spacing: spacing, constraints: [topConstraint, leadingConstraint, centerConstraint, trailingConstraint, widthConstraint, heightConstraint]))
        }
    }
    
    open func updateNodeConstraint(_ node: StackERNode) {
        // width
        if node.view.intrinsicContentSize.width > UIView.noIntrinsicMetric {
            node.constraints[4].constant = node.view.intrinsicContentSize.width
        } else {
            node.constraints[4].constant = node.view.frame.width
        }
        
        // height
        if node.view.intrinsicContentSize.height > UIView.noIntrinsicMetric {
            node.constraints[5].constant = node.view.intrinsicContentSize.height
        } else {
            node.constraints[5].constant = 10
        }
        
        switch stackAlignment {
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
