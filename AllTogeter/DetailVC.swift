//
//  DetailVC.swift
//  AllTogeter
//
//  Created by YenShao on 2017/3/17.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit
import Firebase

class DetailVC: UIViewController {
    
    @IBOutlet weak var detailTimeLable: UILabel!
    
    @IBOutlet weak var detailPeopleLabel: UILabel!
    
    @IBOutlet weak var detailKindLabel: UILabel!
    
    @IBOutlet weak var detailPlaceLabel: UILabel!
    
    @IBOutlet weak var detailImage: UIImageView!
    
    @IBOutlet weak var applyBtnOutlet: UIButton!
    
    @IBOutlet weak var enrollLabel: UILabel!
    
    
    
    var detailindex:Int?
    var indexImage:UIImage?
    
    var searchIndex:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let index = detailindex
        {
            let showTimeLabel = actMsg[index].time
            let showPlaceLabel = actMsg[index].place
            let showPeopleLabe = actMsg[index].people
            let showKindLabel = actMsg[index].kind
            
            detailTimeLable.text = String(showTimeLabel)
            detailPeopleLabel.text = String(showPeopleLabe)
            detailKindLabel.text = String(showKindLabel)
            detailPlaceLabel.text = String(showPlaceLabel)
            navigationItem.title = actMsg[index].topic
            
            //載圖片資料
            loadImage()
            checkApply()
            
            
        }
        else
        {
            if let index = searchIndex
            {
                let showTimeLabel = searchArray[index].time
                let showPlaceLabel = searchArray[index].place
                let showPeopleLabe = searchArray[index].people
                let showKindLabel = searchArray[index].kind
                
                detailTimeLable.text = String(showTimeLabel)
                detailPeopleLabel.text = String(showPeopleLabe)
                detailKindLabel.text = String(showKindLabel)
                detailPlaceLabel.text = String(showPlaceLabel)
                navigationItem.title = searchArray[index].topic
                
                //載圖片資料
                loadImage()
                checkApply()
            }
            
            
        }
        
        
        //移除返回鈕的文字
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //checkApply()
        checkEnrolled()
    }

    
    
    @IBAction func goMapBtn(_ sender: UIButton)
    {
        
    }
    
    //MARK: preparForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goMapSegue"
        {
            let mapvc = segue.destination as? MapVC
            mapvc?.targetLocation = detailPlaceLabel.text
        }
    }
    
    
    
    
    @IBAction func applyBtn(_ sender: UIButton)
    {
        let currentID = FIRAuth.auth()?.currentUser?.uid
        
        if let index = detailindex
        {
            if let name = sideProfileName
            {
                let data:[String:Any] = ["host":actMsg[index].from, "apply":currentID!, "applyName":name]
              DBProvider.Instance.dbRef.child("Apply_Request").childByAutoId().child(actMsg[index].autoKey).setValue(data)
                
                //updata報名人數
                DBProvider.Instance.dbRef.child("enrolled").child(actMsg[index].autoKey).childByAutoId().setValue(["name": name])
            }
            
        }
        else
        {
            if let index = searchIndex
            {
                if let name = sideProfileName
                {
                    let data:[String:Any] = ["host":searchArray[index].from, "apply":currentID!, "applyName":name]
                    DBProvider.Instance.dbRef.child("Apply_Request").childByAutoId().child(searchArray[index].autoKey).setValue(data)
                    
                    //updata報名人數
                    DBProvider.Instance.dbRef.child("enrolled").child(searchArray[index].autoKey).childByAutoId().setValue(["name": name])
                }
            }
        }
    
        checkApply()
        
    }
    
    
    func checkApply()
    {
        //檢查方式：點進活動後會取得一組當初建立活動的AutoKey，進來"Apply_Request"
        //撈出所有資料，表示有被申請的活動，裡面會有申請人ID。用當初建立活動的AutoKey
        //來"Apply_Request"裡面比較是否有相同的Key，若有代表你點進來的活動中有人申請，
        //然後就用currentID與活動申請人ID比較，若有相同的就是已申請過
        
        let currentID = FIRAuth.auth()?.currentUser?.uid
        
        if let index = detailindex
        {
            DBProvider.Instance.dbRef.child("Apply_Request").observe(.value, with: { (snapshot) in
                
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]
                {
                    for snap in snapshots
                    {
                        let temp = snap.value as? [String:Any]
                        let buff = temp?[actMsg[index].autoKey] as? [String:String]
                        let getWhoApply = buff?["apply"] //拿到誰申請
                        
                        if getWhoApply == currentID && currentID != nil
                        {
                            self.applyBtnOutlet.setTitle("已報名", for: .normal)
                            self.applyBtnOutlet.tintColor = UIColor.white
                            self.applyBtnOutlet.backgroundColor = UIColor.darkGray
                            self.applyBtnOutlet.isEnabled = false
                        }
                        
                    }
                }
                
            })
            
        }
        else
        {
            if let index = searchIndex
            {
                DBProvider.Instance.dbRef.child("Apply_Request").observe(.value, with: { (snapshot) in
                    
                    if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]
                    {
                        for snap in snapshots
                        {
                            let temp = snap.value as? [String:Any]
                            let buff = temp?[searchArray[index].autoKey] as? [String:String]
                            let getWhoApply = buff?["apply"] //拿到誰申請
                            
                            if getWhoApply == currentID && currentID != nil
                            {
                                self.applyBtnOutlet.setTitle("已報名", for: .normal)
                                self.applyBtnOutlet.tintColor = UIColor.white
                                self.applyBtnOutlet.backgroundColor = UIColor.darkGray
                                self.applyBtnOutlet.isEnabled = false
                            }
                            
                        }
                    }
                    
                })
            }
        }
        
    }
    
    
    func checkEnrolled()
    {
        //let currentID = FIRAuth.auth()?.currentUser?.uid
        if let index = detailindex
        {
            DBProvider.Instance.dbRef.child("enrolled").child(actMsg[index].autoKey).observe(.value, with: { (snapshot) in
                
                var countNum = 0
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]
                {
                    for snap in snapshots //如果snap加.key可以拿到活動Key
                    {
                        //print("snap = \(snap)")
                        countNum += 1
                    }
                }
                //print("count = \(countNum)") // 統計出報名人數
                self.enrollLabel.text = String(countNum)
            })
            
        }
        else
        {
            if let index = searchIndex
            {
                DBProvider.Instance.dbRef.child("enrolled").child(searchArray[index].autoKey).observe(.value, with: { (snapshot) in
                    
                    var countNum = 0
                    if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]
                    {
                        for snap in snapshots //如果snap加.key可以拿到活動Key
                        {
                            print("snap = \(snap)")
                            countNum += 1
                        }
                    }
                    print("count = \(countNum)") // 統計出報名人數
                    self.enrollLabel.text = String(countNum)
                })
            }
            
        }
        
    }
    
    
    
    
    
    
    func loadImage()
    {
        if let index = detailindex
        {
            let cacheURL = URL(string: actMsg[index].imageURL)
            detailImage.sd_setImage(with: cacheURL)
        }
        else
        {
            if let index = searchIndex
            {
                let cacheURL = URL(string: searchArray[index].imageURL)
                detailImage.sd_setImage(with: cacheURL)
            }
        }
        
    }
    
    
    
    
    
    

    

}















