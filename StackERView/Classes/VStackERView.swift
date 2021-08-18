//
//  VStackERView.swift
//  StackER
//
//  Created by 이동근 on 2021/08/11.
//

import UIKit

open class VStackERView: UIView, StackERView {
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
            
            if node.view.frame.width > 0 {
                node.constraints[2].constant = node.view.frame.width
            } else {
                node.constraints[2].constant = node.view.intrinsicContentSize.width
            }
            
            if node.view.frame.height > 0 {
                node.constraints[3].constant = node.view.frame.height
            } else {
                node.constraints[3].constant = node.view.intrinsicContentSize.height
            }
            
            width = node.constraints[2].constant
            height = node.constraints[3].constant
            
            stackSize = CGSize(width: max(width, stackSize.width), height: stackSize.height + node.spacing + height)
        }
        
        superview?.invalidateIntrinsicContentSize()
        
        super.updateConstraints()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        var height = stackInset.top

        for node in stack {
            layoutNode(node, min: height)

            height += node.spacing
            height += node.view.frame.height
        }
    }
    
    public func push(_ child: UIView, spacing: CGFloat = 0) {
        // add
        addSubview(child)
        
        // constraint
        child.translatesAutoresizingMaskIntoConstraints = false
        
        let top = stack.last?.view.bottomAnchor ?? self.topAnchor
        let topConstraint = child.topAnchor.constraint(equalTo: top, constant: spacing)
        topConstraint.priority = UILayoutPriority(500)
        
        let leading = stack.last?.view.leadingAnchor ?? self.leadingAnchor
        let leadingConstraint = child.leadingAnchor.constraint(equalTo: leading, constant: stackInset.left)
        leadingConstraint.priority = UILayoutPriority(500)
        
        let widthConstraint = child.widthAnchor.constraint(equalToConstant: self.frame.width - stackInset.left - stackInset.right)
        widthConstraint.priority = UILayoutPriority(500)
        
        let heightConstraint = child.heightAnchor.constraint(equalToConstant: child.frame.height)
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
        if node.view.frame.width == 0 {
            node.view.frame.size = CGSize(width: frame.width - stackInset.left - stackInset.right, height: node.view.frame.height)
        }
        
        switch stackAlignment {
        case .left:
            node.view.frame.origin = CGPoint(x: stackInset.left, y: min + node.spacing)
            
        case .right:
            node.view.frame.origin = CGPoint(x: frame.width - stackInset.right - node.view.frame.width, y: min + node.spacing)
            
        default:
            // default center layout
            node.view.frame.origin = CGPoint(x: frame.width / 2 - node.view.frame.width / 2, y: min + node.spacing)
            break
        }
    }
}
