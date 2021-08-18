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
    let testStack = VStackERScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        testStack.translatesAutoresizingMaskIntoConstraints = false
        testStack.backgroundColor = .systemBlue
        testStack.stackInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.addSubview(testStack)
        NSLayoutConstraint.activate([
            testStack.topAnchor.constraint(equalTo: view.topAnchor),
            testStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            testStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            testStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
        for _ in 0 ..< 5 {
            let box = CustomView()
            box.backgroundColor = .systemYellow

            testStack.push(box, spacing: 10)
        }

        for _ in 0 ..< 5 {
            let label = UILabel()
            label.text = "Hello"

            testStack.push(label, spacing: 10)
        }
        
        for _ in 0 ..< 5 {
            let image = UIImageView(image: UIImage(named: "sample"))
            image.frame.size = CGSize(width: 100, height: 100)
            image.contentMode = .scaleAspectFit
            
            testStack.push(image, spacing: 10)
            NSLayoutConstraint.activate([
                image.widthAnchor.constraint(equalToConstant: 100),
                image.heightAnchor.constraint(equalToConstant: 100)
            ])
        }
        
        let banner = UIView()
        banner.backgroundColor = .systemPink
        testStack.setBanner(banner, height: 400)
        
        let ribbon = UIView()
        ribbon.backgroundColor = .systemGreen
        testStack.setRibbon(ribbon, height: 50)
        
        if let _ = testStack.banner {
            testStack.removeBanner()
        }

        if let _ = testStack.ribbon {
            testStack.removeRibbon()
        }
        
        view.layoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

