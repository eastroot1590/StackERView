//
//  StackERView.swift
//  StackER
//
//  Created by 이동근 on 2021/08/11.
//

import UIKit

protocol StackERView: UIView {
    var stackSize: CGSize { get set }
    
    var stackInset: UIEdgeInsets { get set }
    
    var stackAlignment: UIView.ContentMode { get set }
    
    var ignoreFirstSpacing: Bool { get set }
    
    var stack: [StackERNode] { get }
    
    func push(_ child: UIView, spacing: CGFloat)
    
    func layoutNode(_ node: StackERNode, min: CGFloat)
}
