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
        testStack.delegate = self
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
        ribbon.layer.shadowColor = UIColor.black.cgColor
        ribbon.layer.shadowOpacity = 0.8
        testStack.setRibbon(ribbon, height: 50)

        
        view.layoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let ribbon = testStack.ribbon else {
            return
        }
        
        let offset = max((ribbon.frame.height - 50) / 10, 10)
        let shadowRect = CGRect(origin: CGPoint(x: -10, y: 10), size: CGSize(width: ribbon.frame.width + 20, height: max(ribbon.frame.height - 20, 0)))
        
        ribbon.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
        ribbon.layer.shadowOffset = CGSize(width: 0, height: offset)
        print(offset)
    }
}
