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
        layoutStack()
        
        super.updateConstraints()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutStack()
    }
    
    public func push(_ child: UIView, spacing: CGFloat = 0) {
        // add
        addSubview(child)
        stack.append(StackERNode(view: child, spacing: spacing))
    }
    
    func layoutStack() {
        var newStackSize: CGSize = .zero
        var nodeOrigin: CGPoint = CGPoint(x: stackInset.left, y: 0)
        var ignoredFirstSpacing: Bool = false
        
        stack.forEach { node in
            updateNodeFrame(node, origin: nodeOrigin, ignoreSpacing: ignoreFirstSpacing && !ignoredFirstSpacing)
            
            let height = node.view.frame.height

            if !node.view.isHidden {
                newStackSize = CGSize(width: node.view.frame.maxX - stackInset.left, height: max(height, newStackSize.height))
                ignoredFirstSpacing = true
                nodeOrigin.x = node.view.frame.maxX
            }
        }
        
        stackSize = newStackSize
    }
    
    func updateNodeFrame(_ node: StackERNode, origin: CGPoint, ignoreSpacing: Bool) {
        var targetAlignment: StackERAlign = stackAlignment
        var size: CGSize = .zero
        
        // width
        if node.view.intrinsicContentSize.width > UIView.noIntrinsicMetric {
            size.width = node.view.intrinsicContentSize.width
        } else {
            size.width = 10
        }
        
        // height
        if node.view.intrinsicContentSize.height > UIView.noIntrinsicMetric {
            size.height = node.view.intrinsicContentSize.height
        } else {
            targetAlignment = .fill
        }
        
        switch targetAlignment {
        case .leading:
            node.view.frame = CGRect(origin: CGPoint(x: origin.x + (ignoreSpacing ? 0 : node.spacing), y: stackInset.top), size: size)
            
        case .center:
            node.view.frame = CGRect(origin: CGPoint(x: origin.x + (ignoreSpacing ? 0 : node.spacing), y: frame.height / 2 - size.height / 2), size: size)
            
        case .trailing:
            node.view.frame = CGRect(origin: CGPoint(x: origin.x + (ignoreSpacing ? 0 : node.spacing), y: frame.height - stackInset.bottom - size.height), size: size)
            
        case .fill:
            node.view.frame = CGRect(origin: CGPoint(x: origin.x + (ignoreSpacing ? 0 : node.spacing), y: stackInset.top), size: CGSize(width: size.width, height: frame.height - stackInset.top - stackInset.bottom))
        }
    }
}
