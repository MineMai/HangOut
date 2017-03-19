//
//  AllActVC.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/17.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit

class AllActVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //指定menuBarButton的目標是側邊欄controller
        if revealViewController() != nil
        {
            menuBarButton.target = revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllActCell", for: indexPath)
        
        
        
        return cell
    }

    
    
    
    
    

}














