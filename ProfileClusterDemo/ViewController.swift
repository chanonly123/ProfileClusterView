//
//  ViewController.swift
//  ProfileClusterDemo
//
//  Created by Chandan Karmakar on 20/07/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var profileCluster: ProfileClusterView!

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
    }


}

