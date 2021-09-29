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
    let testStack = VStackERView()
    
    let hStack = HStackERView()
    
    let name = UILabel()
    let badge = UIImageView(image: UIImage(named: "newS"))
    let secondBadge = UIImageView(image: UIImage(named: "bestS"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        testStack.translatesAutoresizingMaskIntoConstraints = false
        testStack.backgroundColor = .systemBlue
        testStack.stackInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.addSubview(testStack)
        NSLayoutConstraint.activate([
            testStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        testStack.push(hStack)
        
        
        name.textColor = .black
        name.font = .systemFont(ofSize: 16)
        name.text = "안녕하세요 난 이름이에요"
        hStack.push(name)
        
        
        hStack.push(badge, spacing: 10)
        
        
        hStack.push(secondBadge, spacing: 10)
        
        let age = UILabel()
        age.font = .systemFont(ofSize: 16)
        age.textColor = .black
        age.text = "난 7살입니다."
        testStack.push(age)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTouch)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func handleTouch() {
        name.text = "사실 난 성명이에요"
        badge.isHidden = !badge.isHidden
        
        hStack.invalidateIntrinsicContentSize()
//        view.invalidateIntrinsicContentSize()
//        testStack.invalidateIntrinsicContentSize()
    }
}
