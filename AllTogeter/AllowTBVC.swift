//
//  AllowTBVC.swift
//  AllTogeter
//
//  Created by YenShao on 2017/4/2.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class AllowTBVC: UITableViewController {
    
    var allowIndex = 0
    
    var isFirst = true //檢查chieldadd是否第一次執行用
    
    struct EnrollUser {
        var name:String?
        var imageString:String?
        var confirm:String?
        var autoKey:String?
        var actKey:String?
        var id:String?
    }
    var enrolluser = [EnrollUser]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //移除返回鈕的文字
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //因為這個TableViewController每次進來都是被storyboard生出新的
        //所以每次都會執行viewDidLoad
        loadData()
        
        navigationItem.title = hostMsg[allowIndex].topic
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //let _ = navigationController?.popViewController(animated: true)
    }
    
    
    func loadData()
    {
        let enrolled = DBProvider.Instance.dbRef.child("enrolled")
        
        enrolled.observeSingleEvent(of: .value, with: {
            (snapshots) in
            self.enrolluser = []
            
            if let snapshot = snapshots.children.allObjects as? [FIRDataSnapshot]
            {
                for snap in snapshot  //snap.key 拿到活動Key
                {
                    if let snapDicts = snap.children.allObjects as? [FIRDataSnapshot]
                    {
                        for snapDict in snapDicts //snapDict.key可取到Autokey
                        {
                            if let snapString = snapDict.value as? [String:String]
                            {
                                //print("xxx = \(snapString["name"])") //拿到名字
                                if  snap.key == hostMsg[self.allowIndex].autoKey
                                {
                                    let aUser = EnrollUser(name: snapString["name"]!, imageString: snapString["image"]!, confirm: snapString["confirm"]!,autoKey:snapDict.key,actKey:snap.key, id:snapString["id"]!)
                                    self.enrolluser.append(aUser)
                                }
                                //self.tableView.reloadData()
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        })
    }
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return enrolluser.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllowCell", for: indexPath) as! AllowTBVCell

        cell.allowName.text = enrolluser[indexPath.row].name
        
        let cacheURL = URL(string: enrolluser[indexPath.row].imageString!)
        
        cell.allowImage.sd_setImage(with: cacheURL, placeholderImage: UIImage(named: "picture_placeholder.png"))
        
        if enrolluser[indexPath.row].confirm == "true"
        {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //消除點選的灰色
        //tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "detailProfileSegue", sender: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailProfileSegue"
        {
            if let dpvc = segue.destination as? detailProfileVC
            {
                if let row = tableView.indexPathForSelectedRow?.row
                {
                    dpvc.detailIndex = enrolluser[row].id!
                }
            }
        }
    }
    
    //左滑帶出其他按鈕
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let confirmOK = UITableViewRowAction(style: .destructive, title: "同意") { (action, indexPath) in
            DBProvider.Instance.dbRef.child("enrolled").child(self.enrolluser[indexPath.row].actKey!).child(self.enrolluser[indexPath.row].autoKey!).updateChildValues(["confirm":"true"])
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            tableView.setEditing(false, animated: true)//點擊左滑按鈕後回復成原狀態
            
            //推播寫在這.......
            //self.pushNotification(title: self.enrolluser[indexPath.row].name!, confirm: true)
            
            
        }
        let confirmNO = UITableViewRowAction(style: .destructive, title: "拒絕") { (action, indexPath) in
            DBProvider.Instance.dbRef.child("enrolled").child(self.enrolluser[indexPath.row].actKey!).child(self.enrolluser[indexPath.row].autoKey!).updateChildValues(["confirm":"false"])
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            tableView.setEditing(false, animated: true)//點擊左滑按鈕後回復成原狀態
            
            //推播寫在這.......
            //self.pushNotification(title: self.enrolluser[indexPath.row].name!, confirm: false)
        }
        confirmOK.backgroundColor = UIColor(red: 0.46, green: 0.57, blue: 0.89, alpha: 1.0)
        confirmNO.backgroundColor = UIColor(red: 0.90, green: 0.46, blue: 0.46, alpha: 1.0)
        return [confirmNO,confirmOK]
    }
    
    
    
    
    
    
    

    

}













