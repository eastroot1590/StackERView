//
//  VStackERView.swift
//  StackER
//
//  Created by 이동근 on 2021/08/11.
//

import UIKit

open class VStackERView: UIView, StackERView {
    
    open var stackSize: CGSize {
        var size: CGSize = .zero
        var pivotOrigin: CGPoint = CGPoint(x: 0, y: stackInset.top)
        var ignoredFirstSpacing: Bool = false
        let maxHeight = findMaxHeight()
        
        stack.forEach { node in
            switch stackDistribution {
            case .fill:
                updateNodeFrame(node, origin: pivotOrigin, ignoreSpacing: ignoreFirstSpacing && !ignoredFirstSpacing)
            case .fillEqually:
                updateNodeFrameForSameHeight(node, height: maxHeight, origin: pivotOrigin, ignoreSpacing: ignoreFirstSpacing && !ignoredFirstSpacing)
            }
            
            let width = node.view.frame.width
            
            if !node.view.isHidden {
                size = CGSize(width: max(width, size.width), height: node.view.frame.maxY - stackInset.top)
                ignoredFirstSpacing = true
                pivotOrigin.y = node.view.frame.maxY
            }
        }
        
        return size
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
        
        var pivotOrigin: CGPoint = CGPoint(x: stackInset.left, y: stackInset.top)
        var ignoredFirstSpacing: Bool = false
        let maxHeight = findMaxHeight()
        
        stack.forEach { node in
            switch stackDistribution {
            case .fill:
                updateNodeFrame(node, origin: pivotOrigin, ignoreSpacing: ignoreFirstSpacing && !ignoredFirstSpacing)
            case .fillEqually:
                updateNodeFrameForSameHeight(node, height: maxHeight, origin: pivotOrigin, ignoreSpacing: ignoreFirstSpacing && !ignoredFirstSpacing)
            }

            if !node.view.isHidden {
                ignoredFirstSpacing = true
                pivotOrigin.y = node.view.frame.maxY
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
        } else if systemLayoutSize.width > 10 {
            size.width = systemLayoutSize.width
        } else {
            targetAlignment = .fill
        }
        
        // height
        if node.view.intrinsicContentSize.height > UIView.noIntrinsicMetric {
            size.height = node.view.intrinsicContentSize.height
        } else if systemLayoutSize.height > 10 {
            size.height = systemLayoutSize.height
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
    
    open func updateNodeFrameForSameHeight(_ node: StackERNode, height: CGFloat, origin: CGPoint, ignoreSpacing: Bool) {
        var targetAlignment: StackERAlign = stackAlignment
        var width: CGFloat = 0
        
        let systemLayoutSize = node.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        // width
        if node.view.intrinsicContentSize.width > UIView.noIntrinsicMetric {
            width = node.view.intrinsicContentSize.width
        } else if systemLayoutSize.width > 10 {
            width = systemLayoutSize.width
        } else {
            targetAlignment = .fill
        }
        
        switch targetAlignment {
        case .leading:
            node.view.frame = CGRect(origin: CGPoint(x: stackInset.left, y: origin.y + (ignoreSpacing ? 0 : node.spacing)), size: CGSize(width: width, height: height))
            
        case .center:
            node.view.frame = CGRect(origin: CGPoint(x: frame.width / 2 - width / 2, y: origin.y + (ignoreSpacing ? 0 : node.spacing)), size: CGSize(width: width, height: height))
            
        case .trailing:
            node.view.frame = CGRect(origin: CGPoint(x: frame.width - stackInset.right - width, y: origin.y + (ignoreSpacing ? 0 : node.spacing)), size: CGSize(width: width, height: height))
            
        case .fill:
            node.view.frame = CGRect(origin: CGPoint(x: stackInset.left, y: origin.y + (ignoreSpacing ? 0 : node.spacing)), size: CGSize(width: frame.width - stackInset.left - stackInset.right, height: height))
        }
    }
    
    open func updateNodeOrigin(_ node: StackERNode, origin: CGPoint, ignoreSpacing: Bool) {
        let size = node.view.frame.size
        
        switch stackAlignment {
        case .leading:
            node.view.frame.origin = CGPoint(x: stackInset.left, y: origin.y + (ignoreSpacing ? 0 : node.spacing))
            
        case .center:
            node.view.frame.origin = CGPoint(x: frame.width / 2 - size.width / 2, y: origin.y + (ignoreSpacing ? 0 : node.spacing))
            
        case .trailing:
            node.view.frame.origin = CGPoint(x: frame.width - stackInset.right - size.width, y: origin.y + (ignoreSpacing ? 0 : node.spacing))
            
        case .fill:
            node.view.frame.origin = CGPoint(x: stackInset.left, y: origin.y + (ignoreSpacing ? 0 : node.spacing))
        }
    }
    
    func findMaxHeight() -> CGFloat {
        var maxHeight: CGFloat = 0
        
        stack.forEach { node in
            let systemLayoutSize = node.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            
            maxHeight = max(systemLayoutSize.height, maxHeight)
        }
        
        return maxHeight
    }
    
}
