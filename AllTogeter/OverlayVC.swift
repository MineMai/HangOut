//
//  OverlayVC.swift
//  AllTogeter
//
//  Created by YenShao on 2017/4/1.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit
import Firebase

class OverlayVC: UIViewController {
    
    
    @IBOutlet weak var littleView: UIView!
    
    var overlayIndex = 0
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.bounds.size = CGSize(width: UIScreen.main.bounds.size.width - 145, height: 240)
        self.view.layer.cornerRadius = 10
        littleView.layer.cornerRadius = 10
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    @IBAction func goDetailBtn(_ sender: UIButton)
    {
        print("overlayIndex = \(overlayIndex)")
    }
    
    
    @IBAction func editBtn(_ sender: UIButton) {
    }
    
    
    @IBAction func checkApplyerBtn(_ sender: UIButton) {
    }
    
    
    @IBAction func deleteBtn(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "確定刪除？", message: nil, preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "刪除", style: .destructive) { (action) in
            
            let autoKey = hostMsg[self.overlayIndex].autoKey
            //刪資料庫
            DBProvider.Instance.dbRef.child("Activity").child(autoKey).removeValue()
            DBProvider.Instance.dbRef.child("enrolled").child(autoKey).removeValue()
            
            let apply_request = DBProvider.Instance.dbRef.child("Apply_Request")
            apply_request.observe(.value, with: { (snapshops) in
                if let snapshot = snapshops.children.allObjects as? [FIRDataSnapshot]
                {
                    for snap in snapshot //snap.key可取到autokey
                    {
                        print("snap = \(snap.key)")
                        if let snapDicts = snap.children.allObjects as? [FIRDataSnapshot]
                        {
                            for snapDict in snapDicts //snapDict.key可取到活動key
                            {
                                if snapDict.key == autoKey
                                {
                                    DBProvider.Instance.dbRef.child("Apply_Request").child(snap.key).removeValue()
                                    for i in 0..<actMsg.count
                                    {
                                        if actMsg[i].autoKey == snapDict.key
                                        {
                                            //刪陣列資料
                                            actMsg.remove(at: i)
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            })
            
            //刪陣列資料
            hostMsg.remove(at: self.overlayIndex)
            
            //發送通知
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadCollection"), object: nil, userInfo: [:])
            
            
            self.presentingViewController?.dismiss(animated: true, completion: nil)
            
            
            
            
        }
        let cancle = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        alert.addAction(cancle)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    

    

}














