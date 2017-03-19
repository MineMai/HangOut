//
//  MenuTBVC.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/17.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit

class MenuTBVC: UITableViewController {
    
    @IBOutlet weak var menuPicture: UIImageView!
    
    @IBOutlet weak var menuNameLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0.20, green: 0.27, blue: 0.38, alpha: 1.0)
        
        menuNameLabel.text = FBUser.currentFBUser.name
        menuPicture.image = try! UIImage(data: Data(contentsOf: URL(string: FBUser.currentFBUser.pictureURL!)!))
        menuPicture.layer.cornerRadius = 70 / 2
        menuPicture.layer.borderWidth = 1.0
        menuPicture.layer.borderColor = UIColor.white.cgColor

        menuPicture.clipsToBounds = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "logOutSegue"
        {
            FBManager.shared.logOut()
            FBUser.currentFBUser.resetInfo()
        }
    }

    

}














