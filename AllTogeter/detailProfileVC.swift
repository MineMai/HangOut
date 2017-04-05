//
//  detailProfileVC.swift
//  AllTogeter
//
//  Created by YenShao on 2017/4/5.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit
import Firebase

class detailProfileVC: UIViewController {
    
    @IBOutlet weak var backImage: UIImageView!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    
    var detailIndex = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //首先建立一個模糊效果
        let blurEffect = UIBlurEffect(style: .dark)
        //建立一個view去接模糊效果
        let blurView = UIVisualEffectView(effect: blurEffect)
        //設定模糊view的大小（全螢幕）
        blurView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        //加入模糊圖到頁面view上
        self.view.insertSubview(blurView, belowSubview: userImage)
        
        //圖片圓型
        let layer = userImage?.layer
        layer?.cornerRadius = 50
        layer?.masksToBounds = true
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }

    
    func loadData()
    {
        //let currentID = FIRAuth.auth()?.currentUser?.uid
        
        DBProvider.Instance.dbRef.child("Users").child(detailIndex).observeSingleEvent(of: .value) { (snapshot:FIRDataSnapshot) in
            
            let snap = snapshot.value as! [String:String]
            guard let userName = snap["name"] else { return }
            
            //let userEmail = snap["email"]
            let imageURL = snap["Image"]
            self.userName.text = userName
            
            let cacheURL = URL(string: imageURL!)
            self.userImage.sd_setImage(with: cacheURL, placeholderImage: UIImage(named: "picture_placeholder.png"))
            self.backImage.sd_setImage(with: cacheURL, placeholderImage: UIImage(named: "picture_placeholder.png"))
            
                    
            }
                
    }
            
    
    
    
    

}














