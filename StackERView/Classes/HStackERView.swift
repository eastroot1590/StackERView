//
//  HStackERView.swift
//  StackER
//
//  Created by 이동근 on 2021/08/11.
//

import UIKit

open class HStackERView: UIView, StackERView {
    open var stackSize: CGSize = .zero
    
    open var stackInset: UIEdgeInsets = .zero
    
    open var stackAlignment: UIView.ContentMode = .center
    
    open var ignoreFirstSpacing: Bool = true
    
    var stack: [StackERNode] = []
    
    open override class var requiresConstraintBasedLayout: Bool {
        false
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: stackInset.left + stackSize.width + stackInset.right, height: stackInset.top + stackSize.height + stackInset.bottom)
    }
    open override func updateConstraints() {
        // recalculate content size
        stackSize = .zero
        
        for node in stack {
            var height: CGFloat = 0
            var width: CGFloat = 0
            
            if node.view.intrinsicContentSize.width > UIView.noIntrinsicMetric {
                node.constraints[2].constant = node.view.intrinsicContentSize.width
            } else {
                node.constraints[2].constant = node.view.frame.width
            }
        
            if node.view.intrinsicContentSize.height > UIView.noIntrinsicMetric {
                node.constraints[3].constant = node.view.intrinsicContentSize.height
            } else {
                node.constraints[3].constant = node.view.frame.height
            }
            
            if !node.view.isHidden {
                width = node.constraints[2].constant
                height = node.constraints[3].constant
                
                stackSize = CGSize(width: max(width, stackSize.width), height: stackSize.height + node.spacing + height)
            }
        }
        
        superview?.invalidateIntrinsicContentSize()
        
        super.updateConstraints()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        var width = stackInset.left

        for node in stack {
            layoutNode(node, min: width)

            width += node.spacing
            width += node.view.frame.width
        }
    }
    
    public func push(_ child: UIView, spacing: CGFloat = 0) {
        // add
        addSubview(child)
        
        // constraint
        child.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = child.topAnchor.constraint(equalTo: topAnchor, constant: stackInset.top)
        topConstraint.priority = UILayoutPriority(500)
        
        let leading = stack.last?.view.trailingAnchor ?? self.leadingAnchor
        let leadingConstraint = child.leadingAnchor.constraint(equalTo: leading, constant: spacing)
        leadingConstraint.priority = UILayoutPriority(500)
        
        let widthConstraint = child.widthAnchor.constraint(equalToConstant: child.frame.width)
        widthConstraint.priority = UILayoutPriority(500)
        
        let heightConstraint = child.heightAnchor.constraint(equalToConstant: frame.height - stackInset.top - stackInset.bottom)
        heightConstraint.priority = UILayoutPriority(500)
        
        
        // append stack node
        if stack.isEmpty, ignoreFirstSpacing {
            stack.append(StackERNode(view: child, spacing: 0, constraints: [topConstraint, leadingConstraint, widthConstraint, heightConstraint]))
        } else {
            stack.append(StackERNode(view: child, spacing: spacing, constraints: [topConstraint, leadingConstraint, widthConstraint, heightConstraint]))
        }
        
        if let currentNode = stack.last {
            NSLayoutConstraint.activate(currentNode.constraints)
        }
        
        // update content size
        invalidateIntrinsicContentSize()
        superview?.invalidateIntrinsicContentSize()
        
        setNeedsUpdateConstraints()
    }
    
    open func layoutNode(_ node: StackERNode, min: CGFloat) {
        if node.view.frame.height == 0 {
            node.view.frame.size = CGSize(width: node.view.frame.width, height: frame.height - stackInset.top - stackInset.bottom)
        }
        
        switch stackAlignment {
        case .top:
            node.view.frame.origin = CGPoint(x: min + node.spacing, y: stackInset.top)
            
        case .bottom:
            node.view.frame.origin = CGPoint(x: min + node.spacing, y: frame.height - stackInset.bottom - node.view.frame.height)
            
        default:
            // default center layout
            node.view.frame.origin = CGPoint(x: min + node.spacing, y: frame.height / 2 - node.view.frame.height / 2)
            break
        }
    }
}
