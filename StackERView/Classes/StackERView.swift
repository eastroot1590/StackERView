//
//  StackERView.swift
//  StackER
//
//  Created by 이동근 on 2021/08/11.
//

import UIKit

public enum StackERAlign {
    case leading
    case center
    case trailing
    case fill
}

public enum StackERSeparatorType {
    case none
    case line
}

protocol StackERView: UIView {
    var stackSize: CGSize { get set }
    
    var stackInset: UIEdgeInsets { get set }
    
    var stackAlignment: StackERAlign { get set }
    
    var ignoreFirstSpacing: Bool { get set }
    
    var stack: [StackERNode] { get }
    
    var separatorLayer: CAShapeLayer { get }
    
    var separatorType: StackERSeparatorType { get set }
    
    var separatorInset: UIEdgeInsets { get set }
    
    var separatorColor: CGColor? { get set }
    
    func push(_ child: UIView, spacing: CGFloat)
    
    func updateNodeFrame(_ node: StackERNode, origin: CGPoint, ignoreSpacing: Bool)
}
