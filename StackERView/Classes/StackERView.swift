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

protocol StackERView: UIView {
    var stackSize: CGSize { get set }
    
    var stackInset: UIEdgeInsets { get set }
    
    var stackAlignment: StackERAlign { get set }
    
    var ignoreFirstSpacing: Bool { get set }
    
    var stack: [StackERNode] { get }
    
    func push(_ child: UIView, spacing: CGFloat)
    
    func layoutStack()
    
    func updateNodeFrame(_ node: StackERNode, origin: CGPoint, ignoreSpacing: Bool)
}
