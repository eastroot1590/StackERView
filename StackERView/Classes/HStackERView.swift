//
//  HStackERView.swift
//  StackER
//
//  Created by 이동근 on 2021/08/11.
//

import UIKit

open class HStackERView: UIView, StackERView {
    
    open var stackSize: CGSize {
        
        var newStackSize: CGSize = .zero
        var nodeOrigin: CGPoint = CGPoint(x: stackInset.left, y: stackInset.top)
        var ignoredFirstSpacing: Bool = false
        let maxWidth = findMaxWidth()
        
        stack.forEach { node in
            switch stackDistribution {
            case .fill:
                updateNodeFrame(node, origin: nodeOrigin, ignoreSpacing: ignoreFirstSpacing && !ignoredFirstSpacing)
            case.fillEqually:
                updateNodeFrameForSameWidth(node, width: maxWidth, origin: nodeOrigin, ignoreSpacing: ignoreFirstSpacing && !ignoredFirstSpacing)
            }
            
            let height = node.view.frame.height

            if !node.view.isHidden {
                newStackSize = CGSize(width: node.view.frame.maxX - stackInset.left, height: max(height, newStackSize.height))
                ignoredFirstSpacing = true
                nodeOrigin.x = node.view.frame.maxX
            }
        }
        
        return newStackSize
    }
    
    open var stackInset: UIEdgeInsets = .zero
    
    open var stackAlignment: StackERAlign = .center
    
    open var stackDistribution: StackERDistribution = .fill
    
    open var ignoreFirstSpacing: Bool = true
    
    var stack: [StackERNode] = []
    
    open override var intrinsicContentSize: CGSize {
        let content = stackSize
        
        let width = stackInset.left + content.width + stackInset.right
        let height = stackInset.top + content.height + stackInset.bottom
        
        return CGSize(width: width, height: height)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        var nodeOrigin: CGPoint = CGPoint(x: stackInset.left, y: stackInset.top)
        var ignoredFirstSpacing: Bool = false
        let maxWidth = findMaxWidth()
        
        stack.forEach { node in
            switch stackDistribution {
            case .fill:
                updateNodeFrame(node, origin: nodeOrigin, ignoreSpacing: ignoreFirstSpacing && !ignoredFirstSpacing)
            case.fillEqually:
                updateNodeFrameForSameWidth(node, width: maxWidth, origin: nodeOrigin, ignoreSpacing: ignoreFirstSpacing && !ignoredFirstSpacing)
            }

            if !node.view.isHidden {
                ignoredFirstSpacing = true
                nodeOrigin.x = node.view.frame.maxX
            }
        }
    }
    
    public func push(_ child: UIView, spacing: CGFloat = 0) {
        // add
        addSubview(child)
        stack.append(StackERNode(view: child, spacing: spacing))
    }
    
    open func updateNodeFrame(_ node: StackERNode, origin: CGPoint, ignoreSpacing: Bool) {
        var targetAlignment: StackERAlign = stackAlignment
        var size: CGSize = .zero
        
        let systemLayoutSize = node.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        // width
        if node.view.intrinsicContentSize.width > UIView.noIntrinsicMetric {
            size.width = node.view.intrinsicContentSize.width
        } else if systemLayoutSize.width > 0 {
            size.width = systemLayoutSize.width
        } else {
            size.width = 10
        }
        
        // height
        if node.view.intrinsicContentSize.height > UIView.noIntrinsicMetric {
            size.height = node.view.intrinsicContentSize.height
        } else if systemLayoutSize.height > 0 {
            size.height = systemLayoutSize.height
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
    
    open func updateNodeFrameForSameWidth(_ node: StackERNode, width: CGFloat, origin: CGPoint, ignoreSpacing: Bool) {
        var targetAlignment: StackERAlign = stackAlignment
        var height: CGFloat = 0
        
        let systemLayoutSize = node.view.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        
        // width
        
        // height
        if node.view.intrinsicContentSize.height > UIView.noIntrinsicMetric {
            height = node.view.intrinsicContentSize.height
        } else if systemLayoutSize.height > 0 {
            height = systemLayoutSize.height
        } else {
            targetAlignment = .fill
        }
        
        switch targetAlignment {
        case .leading:
            node.view.frame = CGRect(origin: CGPoint(x: origin.x + (ignoreSpacing ? 0 : node.spacing), y: stackInset.top), size: CGSize(width: width, height: height))
            
        case .center:
            node.view.frame = CGRect(origin: CGPoint(x: origin.x + (ignoreSpacing ? 0 : node.spacing), y: frame.height / 2 - height / 2), size: CGSize(width: width, height: height))
            
        case .trailing:
            node.view.frame = CGRect(origin: CGPoint(x: origin.x + (ignoreSpacing ? 0 : node.spacing), y: frame.height - stackInset.bottom - height), size: CGSize(width: width, height: height))
            
        case .fill:
            node.view.frame = CGRect(origin: CGPoint(x: origin.x + (ignoreSpacing ? 0 : node.spacing), y: stackInset.top), size: CGSize(width: width, height: frame.height - stackInset.top - stackInset.bottom))
        }
    }
    
    func findMaxWidth() -> CGFloat {
        var maxWidth: CGFloat = 0
        
        stack.forEach { node in
            let systemSize = node.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            
            maxWidth = max(systemSize.width, maxWidth)
        }
        
        return maxWidth
    }
}
