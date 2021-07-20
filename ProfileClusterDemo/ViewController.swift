//
//  ViewController.swift
//  ProfileClusterDemo
//
//  Created by Chandan Karmakar on 20/07/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileCluster: ProfileClusterView!
    lazy var gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(gesture:)))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        profileCluster.configureCount = { 20 }
        profileCluster.configureImageView = { view in
            view.imageView.backgroundColor = view.index % 2 == 0 ? UIColor.darkGray : .lightGray
        }
        
        profileCluster.configureMoreView = { view in
            view.label.backgroundColor = UIColor.gray
        }
        profileCluster.reloadData()
        
        
        view.addGestureRecognizer(gesture)
    }

    @objc func handleGesture(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began, .changed:
            trailingConstraint.constant -= (gesture.translation(in: view).x * 0.04)
        @unknown default:
            break
        }
    }
}

