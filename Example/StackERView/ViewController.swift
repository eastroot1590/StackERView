//
//  ViewController.swift
//  StackERView
//
//  Created by eastroot1590@gmail.com on 08/17/2021.
//  Copyright (c) 2021 eastroot1590@gmail.com. All rights reserved.
//

import UIKit
import StackERView

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let stack = HStackERView()
        stack.separatorType = .line
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        let label = UILabel()
        label.text = "Hello StackERView"
        stack.push(label)
        
        let image = UIImageView(image: UIImage(named: "sample"))
        stack.push(image, spacing: 50)
        
        let otherStack = VStackERView()
        stack.push(otherStack, spacing: 20)
        
        for _ in 0 ..< 5 {
            let otherLabel = UILabel()
            otherLabel.text = "I'm in HStack"
            otherStack.push(otherLabel, spacing: 10)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
