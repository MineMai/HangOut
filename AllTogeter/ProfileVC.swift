//
//  ProfileVC.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/18.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var profileEmail: UILabel!
    
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    @IBOutlet weak var profileBackImage: UIImageView!
    
    var profileImage:UIImageView?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //指定menuBarButton的目標是側邊欄controller
        if revealViewController() != nil
        {
            menuBarButton.target = revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        
        //首先建立一個模糊效果
        let blurEffect = UIBlurEffect(style: .dark)
        //建立一個view去接模糊效果
        let blurView = UIVisualEffectView(effect: blurEffect)
        //設定模糊view的大小（全螢幕）
        blurView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        //加入模糊圖到頁面view上
        self.view.insertSubview(blurView, belowSubview: profileName)
        
    
        
        let fullScreenSize = UIScreen.main.bounds.size
        //使用 UIImageView(frame:) 建立一個 UIImageView
        profileImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        
        //使用 UIImage(named:) 放置圖片檔案
        //profileImage?.image = UIImage(named: "profile_picture.png")
        
        //設置新的位置並放入畫面中
        profileImage?.center = CGPoint(
            x: fullScreenSize.width * 0.5,
            y: fullScreenSize.height * 0.32)
        
        //圖片圓型
        let layer = profileImage?.layer
        layer?.cornerRadius = (profileImage?.frame.width)! / 2
        layer?.masksToBounds = true
        
        profileImage?.contentMode = .scaleAspectFill
        self.view.addSubview(profileImage!)
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadProfileImage()
    }
    
    
    
    func loadProfileImage()
    {
        let currentID = FIRAuth.auth()?.currentUser?.uid
        
        DBProvider.Instance.dbRef.child("Users").child(currentID!).observeSingleEvent(of: .value) { (snapshot:FIRDataSnapshot) in
            
            let snap = snapshot.value as! [String:String]
            var userName = snap["name"]
            let userEmail = snap["email"]
            var userImageURL = snap["Image"]
            
            if userImageURL == nil
            {
                userImageURL = "gs://alltogeter-573f4.appspot.com/profile_picture.png"
            }
            if userName == nil
            {
                userName = "未命名"
            }
            
            self.profileName.text = userName
            sideProfileName = userName
            self.profileEmail?.text = userEmail
            
            if isFBLogin
            {
                let urlImage = try! UIImage(data: Data(contentsOf: (fbUsers?.pictureURL)!))
                sideProfileImage = urlImage
                self.profileImage?.image = urlImage
                self.profileBackImage.image = urlImage
            }
            else
            {
                let storage = FIRStorage.storage()
                let imageURL = storage.reference(forURL: userImageURL!)
                
                imageURL.downloadURL(completion: { (url, error) in
                    
                    if error != nil {
                        print("downloadURL Error:\(error?.localizedDescription)")
                        return
                    }
                    
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        
                        if error != nil {
                            print(error)
                            return
                        }
                        
                        guard let imageData = UIImage(data: data!) else { return }
                        
                        DispatchQueue.main.async {
                            self.profileImage?.image = imageData
                            self.profileBackImage.image = imageData
                            sideProfileImage = imageData
        
                        }
                        
                    }).resume()
                    
                })
                
            }
            
        }
        
    }

    
    

    

}














