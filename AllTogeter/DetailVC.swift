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
    
    var detailindex:Int?
    var indexImage:UIImage?
    
    

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
            
            detailImage.image = forAllActVCtoShowImg[index]
            
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        checkApply()
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
        if let index = detailindex
        {
            let currentID = FIRAuth.auth()?.currentUser?.uid
            
            let data:[String:Any] = ["host":actMsg[index].from, "apply":currentID!]
            
            DBProvider.Instance.dbRef.child("Apply_Request").childByAutoId().child(actMsg[index].autoKey).setValue(data)
            
            
        }
        
        checkApply()
        
    }
    
    
    func checkApply()
    {
        //檢查方式：點進活動後會取得一組當初建立活動的AutoKey，進來"Apply_Request"
        //撈出所有資料，表示有被申請的活動，裡面會有申請人ID。用組當初建立活動的AutoKey
        //來"Apply_Request"裡面比較是否有相同的Key，若有代表你點進來的活動中有人申請，
        //然後就用currentID與活動申請人ID比較，若有相同的就是已申請過
        
        let currentID = FIRAuth.auth()?.currentUser?.uid
        
        if let index = detailindex
        {
            DBProvider.Instance.dbRef.child("Apply_Request").observeSingleEvent(of: .value, with: { (snapshot) in
                
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
        
    }
    

    

}















