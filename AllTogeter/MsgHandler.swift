//
//  MsgHandler.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/19.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


class MsgHandler
{
    private static let _instance = MsgHandler()
    static var Instance:MsgHandler {
        return _instance
    }
    
    
    func saveUser(ID:String , email:String, password:String)
    {
        let data:[String:Any] = ["email":email,"password":password]
        DBProvider.Instance.dbRef.child("Users").child(ID).setValue(data)
    }
    
    
    func saveActivity(from:String, topic:String, latitude:Double, longitude:Double, time:String, kind:String, people:Int)
    {
        let data:[String:Any] = ["from":from, "topic":topic, "latitude":latitude, "longitude":longitude, "time":time, "kind":kind, "people":people]
        DBProvider.Instance.dbRef.child("Activity").childByAutoId().setValue(data)
    }
    
    

    func readActivity()
    {
//        actMsg = []
//        hostMsg = []
//        
//        let currentID = FIRAuth.auth()?.currentUser?.uid
//        
//        DBProvider.Instance.dbRef.child("Activity").queryOrdered(byChild: "time").observe(.childAdded, with: { (snapshot) in
//            
//            if let snapshots = snapshot.value as? [String:String]
//            {
//                let autoKey = snapshot.key
//                let imageString = snapshots["imageURL"]!
//                
//                let act = ActMsg(from: snapshots["from"]!, topic: snapshots["topic"]!, latitude: snapshots["latitude"]!, longitude: snapshots["longitude"]!, time: snapshots["time"]!, kind: snapshots["kind"]!, people: snapshots["people"]!, imageURL: imageString, currentID: currentID!, autoKey: autoKey)
//                
//                actMsg.append(act)
//                
//                if currentID == snapshots["from"]
//                {
//                    hostMsg.append(act)
//                }
//                
//                //讀到URL後 開始下載圖片
//                let imageURL = FIRStorage.storage().reference(forURL: imageString)
//                
//                imageURL.downloadURL(completion: { (url, error) in
//                    
//                    if error != nil {
//                        print("downloadURL Error:\(error?.localizedDescription)")
//                        return
//                    }
//                    
//                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//                        
//                        if error != nil {
//                            print(error)
//                            return
//                        }
//                        
//                        guard let imageData = UIImage(data: data!) else { return }
//                        //下載好的圖片統一放進Array裡存
//                        forAllActVCtoShowImg.append(imageData)
//                        
//                        //要給HostTBVC顯示用的圖片
//                        if currentID == snapshots["from"]
//                        {
//                            forHostToShowImg.append(imageData)
//                        }
//                        
//                        //self.tableView.reloadData()
//                        
//                    }).resume()
//                    
//                })
//                
//            }
//            
//        })
//        
     }
    
    
    
    
    








}






















