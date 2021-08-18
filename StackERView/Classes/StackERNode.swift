//
//  StackERNode.swift
//  StackER
//
//  Created by 이동근 on 2021/08/11.
//

import UIKit

public struct StackERNode {
    let view: UIView
    let spacing: CGFloat
    
    /// constraints
    /// - [0] : top
    /// - [1] : leading
    /// - [2] : width
    /// - [3] : height
    var constraints: [NSLayoutConstraint]
}
