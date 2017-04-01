//
//  ContainerViewController.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/28.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    
    @IBOutlet weak var hostContainerView: UIView!
    
    @IBOutlet weak var applyContainerView: UIView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        hostContainerView.isHidden = false
        applyContainerView.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.items?[1].badgeValue = nil
    }
    
    
    @IBAction func segmentBtn(_ sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex
        {
        case 0:
            hostContainerView.isHidden = false
            applyContainerView.isHidden = true
        case 1:
            hostContainerView.isHidden = true
            applyContainerView.isHidden = false
        default:
            break
        }
        
        
        
        
    }
    
    
    

    

}











