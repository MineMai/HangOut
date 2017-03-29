//
//  EditProfileVC.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/22.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class EditProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var editImage: UIImageView!
    
    @IBOutlet weak var editName: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = editImage.layer
        layer.cornerRadius = 30
        layer.masksToBounds = true
        
        //在圖片上加入點擊手勢效果
        editImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectProfileImage)))
        

        
    }
    
    
    func selectProfileImage()
    {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        show(imagePickerController, sender: self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        editImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveBtn(_ sender: UIBarButtonItem)
    {
        if isFBLogin
        {
            let alert = UIAlertController(title: "無法修改資料", message: "使用FaceBook帳號登入，無法修改", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "確定修改？", message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .destructive) { (action) in
                
                let currentID = FIRAuth.auth()?.currentUser?.uid
                var userName = ""
                if self.editName.text != nil && self.editName.text != ""
                {
                    userName = self.editName.text!
                }
                else
                {
                    userName = "未命名"
                }
                //存資料與圖片
                let uidString = NSUUID().uuidString
                let activityImagesRef = DBProvider.Instance.storageRef.child("Users_images").child(currentID!).child(uidString)
                let imageData:Data = UIImageJPEGRepresentation(self.editImage.image!, 0.2)!
                activityImagesRef.put(imageData, metadata: nil) { (metadata, error) in
                    if error != nil
                    {
                        print("上傳大頭錯誤: \(error?.localizedDescription)")
                        return
                    }
                    
                    //照片儲存位置
                    let imageURL:String = (metadata?.downloadURL()?.absoluteString)!
                    let data:[String:Any] = ["name":userName, "Image":imageURL]
                    DBProvider.Instance.dbRef.child("Users").child(currentID!).updateChildValues(data)
                    
                    let _ = self.navigationController?.popViewController(animated: true)
                }
            }//ok
            
            let cancle = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            alert.addAction(ok)
            alert.addAction(cancle)
            present(alert, animated: true, completion: nil)
        }
        
        
        
    }
    
    
    
    

    

}















