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
    
    let separatorLayer = CAShapeLayer()
    
    var separatorType: StackERSeparatorType = .none {
        didSet {
            layoutStack()
        }
    }
    
    open var separatorInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    open var separatorColor: CGColor? {
        get {
            separatorLayer.strokeColor
        }
        set {
            separatorLayer.strokeColor = newValue
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: stackInset.left + stackSize.width + stackInset.right, height: stackInset.top + stackSize.height + stackInset.bottom)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        separatorColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
        
        separatorLayer.lineWidth = 0.5
        layer.addSublayer(separatorLayer)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        let separatorPath = UIBezierPath()
        var frontView: UIView? = nil
        
        stack.forEach { node in
            guard !node.view.isHidden else {
                return
            }
            updateNodeFrame(node, origin: nodeOrigin, ignoreSpacing: ignoreFirstSpacing && !ignoredFirstSpacing)
            
            let height = node.view.frame.height
            
            newStackSize = CGSize(width: node.view.frame.maxX - stackInset.left, height: max(height, newStackSize.height))
            ignoredFirstSpacing = true
            
            if let front = frontView {
                let x = (front.frame.maxX + node.view.frame.minX) / 2
                
                separatorPath.move(to: CGPoint(x: x, y: separatorInset.top))
                separatorPath.addLine(to: CGPoint(x: x, y: frame.height - separatorInset.bottom))
            }
            
            frontView = node.view
            nodeOrigin.x = node.view.frame.maxX
        }
        
        separatorLayer.path = separatorType == .none ? nil : separatorPath.cgPath
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
