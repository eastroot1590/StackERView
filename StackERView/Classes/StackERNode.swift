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
    /// - [0] : linked (leading in HStack, top in VStack)
    /// - [1] : leading (top in HStack, leading in VStack)
    /// - [2] : center
    /// - [3] : trailing (bottom in HStack, trailing in VStack)
    /// - [4] : width
    /// - [3] : height
    var constraints: [NSLayoutConstraint]
}
