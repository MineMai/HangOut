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
        
        self.view.bounds.size = CGSize(width: UIScreen.main.bounds.size.width - 120, height: 270)
        self.view.layer.cornerRadius = 10
        littleView.layer.cornerRadius = 10
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //加入點擊手勢判斷消失彈跳視窗
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)

        
    }
    
    //判斷手勢要做的方法
    func didTapView(gesture:UITapGestureRecognizer)
    {
        //消失彈跳視窗
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func goDetailBtn(_ sender: UIButton)
    {
        //print("overlayIndex = \(overlayIndex)")
        //發送通知(goToReviewDetail)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goToReviewDetail"), object: nil, userInfo: [:])
        //消失彈跳視窗
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    //按編輯鈕時，其實是讓上一個ViewController(HostVC)去做轉場，
    //所以就發送通知給上一頁，然後把彈跳視窗關掉
    @IBAction func editBtn(_ sender: UIButton)
    {
        //發送通知(goToEdit)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goToEdit"), object: nil, userInfo: [:])
        //消失彈跳視窗
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func checkApplyerBtn(_ sender: UIButton)
    {
        //發送通知(goToAllow)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goToAllow"), object: nil, userInfo: [:])
        //消失彈跳視窗
        self.presentingViewController?.dismiss(animated: true, completion: nil)
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
                                    for j in 0..<applyKey.count
                                    {
                                        if applyKey[j] == snapDict.key
                                        {
                                            //刪陣列資料
                                            applyKey.remove(at: j)
                                            //刪資料後發送重整通知
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadApplyVC"), object: nil, userInfo: [:])
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
            
            //發送通知(reloadCollection)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadCollection"), object: nil, userInfo: [:])
            //消失彈跳視窗
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














