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
//    let testStack = VStackERScrollView()
    let testStack = HStackERView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
//        testStack.translatesAutoresizingMaskIntoConstraints = false
//        testStack.backgroundColor = .systemBlue
//        testStack.stackInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        view.addSubview(testStack)
//        NSLayoutConstraint.activate([
//            testStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            testStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            testStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            testStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//        ])
        testStack.backgroundColor = .systemBlue
        testStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(testStack)
        NSLayoutConstraint.activate([
            testStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            testStack.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        for _ in 0 ..< 3 {
            let box = CustomView()
            box.backgroundColor = .systemYellow

            testStack.push(box, spacing: 10)
        }

        for _ in 0 ..< 3 {
            let label = UILabel()
            label.text = "Hello"

            testStack.push(label, spacing: 10)
        }
        
        for _ in 0 ..< 3 {
            let image = UIImageView(image: UIImage(named: "sample"))
            image.frame.size = CGSize(width: 100, height: 100)
            image.contentMode = .scaleAspectFit
            
            testStack.push(image, spacing: 10)
            NSLayoutConstraint.activate([
                image.widthAnchor.constraint(equalToConstant: 100),
                image.heightAnchor.constraint(equalToConstant: 100)
            ])
        }
        
        view.layoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

