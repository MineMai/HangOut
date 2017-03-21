//
//  AllActVC.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/17.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class AllActVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    @IBOutlet weak var allTableView: UITableView!
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //指定menuBarButton的目標是側邊欄controller
        if revealViewController() != nil
        {
            menuBarButton.target = revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        //偷印使用者是誰登入
        let currentID = FIRAuth.auth()?.currentUser?.uid
        print("xxcurrentID = \(currentID)\n")
        print("xxFBCurrentUser2 = \(FBSDKAccessToken.current())\n")
        
        //loadData
        loadData()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //MsgHandler.Instance.readActivity()
    }
    
    
    
    func loadData()
    {
        actMsg = []
        hostMsg = []
        
        let currentID = FIRAuth.auth()?.currentUser?.uid
        
        DBProvider.Instance.dbRef.child("Activity").queryOrdered(byChild: "time").observe(.childAdded, with: { (snapshot) in
            
            if let snapshots = snapshot.value as? [String:String]
            {
                let autoKey = snapshot.key
                let imageString = snapshots["imageURL"]!
                
                let act = ActMsg(from: snapshots["from"]!, topic: snapshots["topic"]!, place: snapshots["place"]!, time: snapshots["time"]!, kind: snapshots["kind"]!, people: snapshots["people"]!, imageURL: imageString, currentID: currentID!, autoKey: autoKey)
                
                actMsg.append(act)
                
                if currentID == snapshots["from"]
                {
                    hostMsg.append(act)
                }
                
                //讀到URL後 開始下載圖片
                let imageURL = FIRStorage.storage().reference(forURL: imageString)
                
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
                        //下載好的圖片統一放進Array裡存
                        forAllActVCtoShowImg.append(imageData)
                        
                        //要給HostTBVC顯示用的圖片
                        if currentID == snapshots["from"]
                        {
                            forHostToShowImg.append(imageData)
                        }
                        
                        self.allTableView.reloadData()
                        
                    }).resume()
                    
                })
                
            }
            
        })
        
        
    }
    
    
    
    
    
    
        
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return actMsg.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllActCell", for: indexPath) as! AllActTBCell
        
        
        cell.activityTopicLabel.text = ""
        cell.activityTimeLabel.text = ""
        cell.activityKindLabel.text = ""
        cell.activityImage.image = nil
        cell.activityTopicLabel.text = actMsg[indexPath.row].topic
        cell.activityTimeLabel.text = actMsg[indexPath.row].time
        cell.activityKindLabel.text = actMsg[indexPath.row].kind
        cell.activityImage.image = forAllActVCtoShowImg[indexPath.row]
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailSegue"
        {
            let dvc = segue.destination as? DetailVC
            dvc?.detailindex = allTableView.indexPathForSelectedRow?.row
        
        }
    }
    
    
    
    
    
    //取消點選的灰色
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    

}














