//
//  MenuTBVC.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/17.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class MenuTBVC: UITableViewController {
    
    @IBOutlet weak var menuPicture: UIImageView!
    
    @IBOutlet weak var menuNameLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0.20, green: 0.27, blue: 0.38, alpha: 1.0)
        
        //如果是用FB登入的才去載FB的照片名字
        if FBSDKAccessToken.current() != nil
        {
            menuNameLabel.text = FBUser.currentFBUser.name
            menuPicture.image = try! UIImage(data: Data(contentsOf: URL(string: FBUser.currentFBUser.pictureURL!)!))
        }
        
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
            
            //.............................
            if AuthProvider.Instance.logOut()
            {
                actMsg = []
                hostMsg = []
                forAllActVCtoShowImg = []
                detailImagePass = []
                print("已登出Firebase帳號")
            }
            else
            {
                alertTheUser(title: "登出異常", message: "現在無法登出，請稍候再試")
            }
            
        }
    }
    
    func alertTheUser(title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

    

}














