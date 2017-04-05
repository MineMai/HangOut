//
//  ReViewDetailVC.swift
//  AllTogeter
//
//  Created by YenShao on 2017/4/2.
//  Copyright © 2017年 YenShao. All rights reserved.
//

import UIKit
import Firebase

class ReViewDetailVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var peopleCountLabel: UILabel!
    
    @IBOutlet weak var reviewCollectionView: UICollectionView!
    
    //要從這個VC連結到包著的TableViewController，需要的變數
    var reviewTBVC:ReviewTBVC?
    
    var reviewIndex = 0
    
    var isFromSegue = false
    var fromSegueIndex = 0
    
    struct CollecData {
        var name:String?
        var imageString:String?
        var count:Int?
    }
    var collecData = [CollecData]()
    var collecData2 = [CollecData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("fromSegueIndex = \(fromSegueIndex)")
        print("isFromSegue = \(isFromSegue)")
        
        reviewCollectionView.delegate = self
        reviewCollectionView.dataSource = self
        
        if isFromSegue
        {
            reviewTBVC?.reviewTopic.text = applyMsg[fromSegueIndex].topic
            reviewTBVC?.reviewPlace.text = applyMsg[fromSegueIndex].place
            reviewTBVC?.reviewTime.text = applyMsg[fromSegueIndex].time
            reviewTBVC?.reviewKind.text = applyMsg[fromSegueIndex].kind
            reviewTBVC?.reviewPeople.text = applyMsg[fromSegueIndex].people
            
            let cacheURL = URL(string: applyMsg[fromSegueIndex].imageURL)
            reviewTBVC?.reviewImage.sd_setImage(with: cacheURL, placeholderImage: UIImage(named: "picture_placeholder.png"))
        }
        else
        {
            reviewTBVC?.reviewTopic.text = hostMsg[reviewIndex].topic
            reviewTBVC?.reviewPlace.text = hostMsg[reviewIndex].place
            reviewTBVC?.reviewTime.text = hostMsg[reviewIndex].time
            reviewTBVC?.reviewKind.text = hostMsg[reviewIndex].kind
            reviewTBVC?.reviewPeople.text = hostMsg[reviewIndex].people
            
            let cacheURL = URL(string: hostMsg[reviewIndex].imageURL)
            reviewTBVC?.reviewImage.sd_setImage(with: cacheURL, placeholderImage: UIImage(named: "picture_placeholder.png"))
        }
        
        
        loadData()
        
    }
    
    //要從這個VC連結到包著的TableViewController，要用segue的preperforsegue來連結
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "reviewSegue"
        {
            reviewTBVC = segue.destination as? ReviewTBVC
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isFromSegue
        {
            peopleCountLabel.text = "(" + String(collecData2.count) + ")"
            return collecData2.count
        }
        else
        {
            peopleCountLabel.text = "(" + String(collecData.count) + ")"
            return collecData.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as! ReviewCell
        
        //cell.reviewCellImage.image = UIImage(named: "profile_picture.png")
        
        if isFromSegue
        {
            let cacheURL = URL(string: collecData2[indexPath.row].imageString!)
            
            cell.reviewCellImage.sd_setImage(with: cacheURL, placeholderImage: UIImage(named: "picture_placeholder.png"))
        }
        else
        {
            let cacheURL = URL(string: collecData[indexPath.row].imageString!)
            
            cell.reviewCellImage.sd_setImage(with: cacheURL, placeholderImage: UIImage(named: "picture_placeholder.png"))
        }
        
        return cell
    }
    
    
    
    
    func loadData()
    {
        if isFromSegue
        {
            let enrolled = DBProvider.Instance.dbRef.child("enrolled").child(applyMsg[fromSegueIndex].autoKey)
            
            enrolled.observe(.value, with: { (snapshots) in
                self.collecData2 = []
                
                if let snapshot = snapshots.children.allObjects as? [FIRDataSnapshot]
                {
                    for snap in snapshot //snapshot.count可拿到有幾筆
                    {
                        if let snapData = snap.value as? [String:String]
                        {
                            if snapData["confirm"] == "true"
                            {
                                if let name = snapData["name"], let image = snapData["image"]
                                {
                                    let aData = CollecData(name: name, imageString: image, count: snapshot.count)
                                    
                                    self.collecData2.append(aData)
                                }
                            }
                        }
                    }
                    self.reviewCollectionView.reloadData()
                }
            })
        }
        else
        {
            let enrolled = DBProvider.Instance.dbRef.child("enrolled").child(hostMsg[reviewIndex].autoKey)
            
            enrolled.observe(.value, with: { (snapshots) in
                self.collecData = []
                
                //print("snapshots = \(snapshots)")
                
                if let snapshot = snapshots.children.allObjects as? [FIRDataSnapshot]
                {
                    for snap in snapshot //snapshot.count可拿到有幾筆
                    {
                        if let snapData = snap.value as? [String:String]
                        {
                            if snapData["confirm"] == "true"
                            {
                                if let name = snapData["name"], let image = snapData["image"]
                                {
                                    let aData = CollecData(name: name, imageString: image, count: snapshot.count)
                                    
                                    self.collecData.append(aData)
                                }
                            }
                        }
                    }
                    self.reviewCollectionView.reloadData()
                }
            })
        }
        
    }
    
    
    
    
    
    


}


















