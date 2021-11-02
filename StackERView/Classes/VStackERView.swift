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
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        var newStackSize: CGSize = .zero
        var nodeOrigin: CGPoint = CGPoint(x: 0, y: stackInset.top)
        var ignoredFirstSpacing: Bool = false
        
        stack.forEach { node in
            updateNodeFrame(node, origin: nodeOrigin, ignoreSpacing: ignoreFirstSpacing && !ignoredFirstSpacing)
            
            let width = node.view.frame.width

            if !node.view.isHidden {
                newStackSize = CGSize(width: max(width, newStackSize.width), height: node.view.frame.maxY - stackInset.top)
                ignoredFirstSpacing = true
                nodeOrigin.y = node.view.frame.maxY
            }
        }
        
        stackSize = newStackSize
    }
    
    public func push(_ child: UIView, spacing: CGFloat = 0) {
        // add
        addSubview(child)
        stack.append(StackERNode(view: child, spacing: spacing))
    }
    
    open func updateNodeFrame(_ node: StackERNode, origin: CGPoint, ignoreSpacing: Bool) {
        var targetAlignment: StackERAlign = stackAlignment
        var size: CGSize = .zero
        
        // width
        if node.view.intrinsicContentSize.width > UIView.noIntrinsicMetric {
            size.width = node.view.intrinsicContentSize.width
        } else {
            targetAlignment = .fill
        }
        
        // height
        if node.view.intrinsicContentSize.height > UIView.noIntrinsicMetric {
            size.height = node.view.intrinsicContentSize.height
        } else {
            size.height = 10
        }
        
        switch targetAlignment {
        case .leading:
            node.view.frame = CGRect(origin: CGPoint(x: stackInset.left, y: origin.y + (ignoreSpacing ? 0 : node.spacing)), size: size)
            
        case .center:
            node.view.frame = CGRect(origin: CGPoint(x: frame.width / 2 - size.width / 2, y: origin.y + (ignoreSpacing ? 0 : node.spacing)), size: size)
            
        case .trailing:
            node.view.frame = CGRect(origin: CGPoint(x: frame.width - stackInset.right - size.width, y: origin.y + (ignoreSpacing ? 0 : node.spacing)), size: size)
            
        case .fill:
            node.view.frame = CGRect(origin: CGPoint(x: stackInset.left, y: origin.y + (ignoreSpacing ? 0 : node.spacing)), size: CGSize(width: frame.width - stackInset.left - stackInset.right, height: size.height))
        }
    }
}
